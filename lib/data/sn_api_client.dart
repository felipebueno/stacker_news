import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/auth/sign_in_failed_page.dart';

import './models/post.dart';
import './models/post_type.dart';
import './models/session.dart';
import './models/user.dart';
import './shared_prefs_manager.dart' show SharedPrefsManager;

const String baseUrl = String.fromEnvironment(
  'BASE_URL',
  defaultValue: 'https://stacker.news',
);

final class SNApiClient {
  SNApiClient() {
    assert(baseUrl.isNotEmpty);

    _cookieJar();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final statusCode = error.response?.statusCode;

          if (statusCode == 403 || statusCode == 404) {
            // Ignore 403 errors when unable to login with magic link
            // Ignore 404 errors so we can update the build-id and re-fetch posts
            handler.resolve(
              Response(
                requestOptions: error.requestOptions,
                statusCode: statusCode,
              ),
            );
          } else {
            debugPrint(error.response?.data.toString());
            handler.next(error);
          }
        },
      ),
    );
  }

  final Dio _dio = Dio(
    BaseOptions(
      // TODO: Keep only the necessary values
      baseUrl: '$baseUrl/_next/data',
      headers: {
        'User-Agent':
            'Mozilla/5.0 (X11; Linux x86_64; rv:126.0) Gecko/20100101 Firefox/126.0',
        'Accept': '*/*',
        'Accept-Language': 'en-US,en;q=0.5',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<void> _cookieJar() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage('$appDocPath/.cookies/'),
    );
    _dio.interceptors.add(CookieManager(jar));
  }

  // #region Posts
  Future<List<Post>> fetchInitialPosts(PostType postType) async {
    try {
      String endpoint = postType.endpoint;

      String? currCommit = await _getCurrBuildId();

      final response = await _dio.get('/$currCommit/$endpoint');

      if (response.statusCode == 200) {
        return await _parsePosts(response.data, postType);
      }

      if (response.statusCode == 404) {
        await _fetchAndSaveCurrBuildId();

        currCommit = await _getCurrBuildId();

        final retryResponse = await _dio.get('/$currCommit/$endpoint');

        if (retryResponse.statusCode == 200) {
          return await _parsePosts(retryResponse.data, postType);
        } else {
          throw Exception('Error fetching posts');
        }
      } else {
        throw Exception('Error parsing build id');
      }
    } catch (e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
      Utils.showException(e.toString(), st);

      rethrow;
    }
  }

  Future<List<Post>> _parsePosts(
    dynamic responseData,
    PostType postType,
  ) async {
    final response = (responseData['pageProps'] ?? responseData);
    final data = response['ssrData'] ?? response['data'];

    final itemsMap =
        (data['items'] ?? data['topItems'] ?? data['notifications']);
    final List items = itemsMap['items'] ?? itemsMap['notifications'];

    if (postType == PostType.home) {
      // TODO: Temporary solution to get Stacker Saloon on the list
      final List? pins = itemsMap['pins'];
      if (pins != null && pins.isNotEmpty) {
        for (var pin in pins) {
          items.insert(pin['position'], pin);
        }
      }
    }

    final cursor = itemsMap['cursor'];
    if (cursor != null) {
      await SharedPrefsManager.set(
        '${postType.name}-cursor',
        cursor,
      );
    }

    return items.map((item) {
      return Post.fromJson(item);
    }).toList();
  }

  String _getGraphQLBodyFor(
    PostType postType, {
    required String cursor,
  }) {
    if (postType == PostType.top ||
        postType == PostType.home ||
        postType == PostType.recent) {
      // TODO: Use GqlBody and keep only the required fields
      return '{"operationName":"SubItems","variables":{"includeComments":false,"cursor":"$cursor"},"query":"fragment SubFields on Sub {\\n  name\\n  postTypes\\n  allowFreebies\\n  rankingType\\n  billingType\\n  billingCost\\n  billingAutoRenew\\n  billedLastAt\\n  billPaidUntil\\n  baseCost\\n  userId\\n  desc\\n  status\\n  moderated\\n  moderatedCount\\n  meMuteSub\\n  meSubscription\\n  nsfw\\n  __typename\\n}\\n\\nfragment SubFullFields on Sub {\\n  ...SubFields\\n  user {\\n    name\\n    id\\n    optional {\\n      streak\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nfragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    id\\n    name\\n    optional {\\n      streak\\n      __typename\\n    }\\n    meMute\\n    __typename\\n  }\\n  sub {\\n    name\\n    userId\\n    moderated\\n    meMuteSub\\n    meSubscription\\n    nsfw\\n    __typename\\n  }\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  noteId\\n  path\\n  upvotes\\n  meSats\\n  meDontLikeSats\\n  meBookmark\\n  meSubscription\\n  meForward\\n  outlawed\\n  freebie\\n  bio\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  pollExpiresAt\\n  status\\n  uploadId\\n  mine\\n  imgproxyUrls\\n  rel\\n  __typename\\n}\\n\\nfragment CommentItemExtFields on Item {\\n  text\\n  root {\\n    id\\n    title\\n    bounty\\n    bountyPaidTo\\n    subName\\n    sub {\\n      name\\n      userId\\n      moderated\\n      meMuteSub\\n      __typename\\n    }\\n    user {\\n      name\\n      optional {\\n        streak\\n        __typename\\n      }\\n      id\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nquery SubItems(\$sub: String, \$sort: String, \$cursor: String, \$type: String, \$name: String, \$when: String, \$from: String, \$to: String, \$by: String, \$limit: Limit, \$includeComments: Boolean = false) {\\n  sub(name: \$sub) {\\n    ...SubFullFields\\n    __typename\\n  }\\n  items(\\n    sub: \$sub\\n    sort: \$sort\\n    cursor: \$cursor\\n    type: \$type\\n    name: \$name\\n    when: \$when\\n    from: \$from\\n    to: \$to\\n    by: \$by\\n    limit: \$limit\\n  ) {\\n    cursor\\n    items {\\n      ...ItemFields\\n      ...CommentItemExtFields @include(if: \$includeComments)\\n      position\\n      __typename\\n    }\\n    pins {\\n      ...ItemFields\\n      ...CommentItemExtFields @include(if: \$includeComments)\\n      position\\n      __typename\\n    }\\n    __typename\\n  }\\n}"}';
    } else if (postType == PostType.notifications) {
      // TODO: Use GqlBody and keep only the required fields
      return '{"operationName":"Notifications","variables":{"cursor":"$cursor"},"query":"fragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    id\\n    name\\n    optional {\\n      streak\\n      __typename\\n    }\\n    meMute\\n    __typename\\n  }\\n  sub {\\n    name\\n    userId\\n    moderated\\n    meMuteSub\\n    meSubscription\\n    nsfw\\n    __typename\\n  }\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  noteId\\n  path\\n  upvotes\\n  meSats\\n  meDontLikeSats\\n  meBookmark\\n  meSubscription\\n  meForward\\n  outlawed\\n  freebie\\n  bio\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  pollExpiresAt\\n  status\\n  uploadId\\n  mine\\n  imgproxyUrls\\n  rel\\n  apiKey\\n  __typename\\n}\\n\\nfragment ItemFullFields on Item {\\n  ...ItemFields\\n  text\\n  root {\\n    id\\n    title\\n    bounty\\n    bountyPaidTo\\n    subName\\n    user {\\n      id\\n      name\\n      optional {\\n        streak\\n        __typename\\n      }\\n      __typename\\n    }\\n    sub {\\n      name\\n      userId\\n      moderated\\n      meMuteSub\\n      meSubscription\\n      __typename\\n    }\\n    __typename\\n  }\\n  forwards {\\n    userId\\n    pct\\n    user {\\n      name\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nfragment InviteFields on Invite {\\n  id\\n  createdAt\\n  invitees {\\n    id\\n    name\\n    __typename\\n  }\\n  gift\\n  limit\\n  revoked\\n  user {\\n    id\\n    name\\n    optional {\\n      streak\\n      __typename\\n    }\\n    __typename\\n  }\\n  poor\\n  __typename\\n}\\n\\nfragment SubFields on Sub {\\n  name\\n  createdAt\\n  postTypes\\n  allowFreebies\\n  rankingType\\n  billingType\\n  billingCost\\n  billingAutoRenew\\n  billedLastAt\\n  billPaidUntil\\n  baseCost\\n  userId\\n  desc\\n  status\\n  moderated\\n  moderatedCount\\n  meMuteSub\\n  meSubscription\\n  nsfw\\n  __typename\\n}\\n\\nquery Notifications(\$cursor: String, \$inc: String) {\\n  notifications(cursor: \$cursor, inc: \$inc) {\\n    cursor\\n    lastChecked\\n    notifications {\\n      __typename\\n      ... on Mention {\\n        id\\n        sortTime\\n        mention\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on ItemMention {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Votification {\\n        id\\n        sortTime\\n        earnedSats\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Revenue {\\n        id\\n        sortTime\\n        earnedSats\\n        subName\\n        __typename\\n      }\\n      ... on ForwardedVotification {\\n        id\\n        sortTime\\n        earnedSats\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Streak {\\n        id\\n        sortTime\\n        days\\n        __typename\\n      }\\n      ... on Earn {\\n        id\\n        sortTime\\n        minSortTime\\n        earnedSats\\n        sources {\\n          posts\\n          comments\\n          tipPosts\\n          tipComments\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Referral {\\n        id\\n        sortTime\\n        __typename\\n      }\\n      ... on Reply {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on FollowActivity {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on TerritoryPost {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on TerritoryTransfer {\\n        id\\n        sortTime\\n        sub {\\n          ...SubFields\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Invitification {\\n        id\\n        sortTime\\n        invite {\\n          ...InviteFields\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on JobChanged {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFields\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on SubStatus {\\n        id\\n        sortTime\\n        sub {\\n          ...SubFields\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on InvoicePaid {\\n        id\\n        sortTime\\n        earnedSats\\n        invoice {\\n          id\\n          nostr\\n          comment\\n          lud18Data\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on WithdrawlPaid {\\n        id\\n        sortTime\\n        earnedSats\\n        withdrawl {\\n          autoWithdraw\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Reminder {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFullFields\\n          __typename\\n        }\\n        __typename\\n      }\\n    }\\n    __typename\\n  }\\n}"}';
    }

    // TODO: Use GqlBody and keep only the required fields
    return '{"operationName":"SubItems","variables":{"includeComments":false,"sub":"${postType.name}","cursor":"$cursor"},"query":"fragment SubFields on Sub {\\n  name\\n  postTypes\\n  allowFreebies\\n  rankingType\\n  billingType\\n  billingCost\\n  billingAutoRenew\\n  billedLastAt\\n  billPaidUntil\\n  baseCost\\n  userId\\n  desc\\n  status\\n  moderated\\n  moderatedCount\\n  meMuteSub\\n  meSubscription\\n  nsfw\\n  __typename\\n}\\n\\nfragment SubFullFields on Sub {\\n  ...SubFields\\n  user {\\n    name\\n    id\\n    optional {\\n      streak\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nfragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    id\\n    name\\n    optional {\\n      streak\\n      __typename\\n    }\\n    meMute\\n    __typename\\n  }\\n  sub {\\n    name\\n    userId\\n    moderated\\n    meMuteSub\\n    meSubscription\\n    nsfw\\n    __typename\\n  }\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  noteId\\n  path\\n  upvotes\\n  meSats\\n  meDontLikeSats\\n  meBookmark\\n  meSubscription\\n  meForward\\n  outlawed\\n  freebie\\n  bio\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  pollExpiresAt\\n  status\\n  uploadId\\n  mine\\n  imgproxyUrls\\n  rel\\n  __typename\\n}\\n\\nfragment CommentItemExtFields on Item {\\n  text\\n  root {\\n    id\\n    title\\n    bounty\\n    bountyPaidTo\\n    subName\\n    sub {\\n      name\\n      userId\\n      moderated\\n      meMuteSub\\n      __typename\\n    }\\n    user {\\n      name\\n      optional {\\n        streak\\n        __typename\\n      }\\n      id\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nquery SubItems(\$sub: String, \$sort: String, \$cursor: String, \$type: String, \$name: String, \$when: String, \$from: String, \$to: String, \$by: String, \$limit: Limit, \$includeComments: Boolean = false) {\\n  sub(name: \$sub) {\\n    ...SubFullFields\\n    __typename\\n  }\\n  items(\\n    sub: \$sub\\n    sort: \$sort\\n    cursor: \$cursor\\n    type: \$type\\n    name: \$name\\n    when: \$when\\n    from: \$from\\n    to: \$to\\n    by: \$by\\n    limit: \$limit\\n  ) {\\n    cursor\\n    items {\\n      ...ItemFields\\n      ...CommentItemExtFields @include(if: \$includeComments)\\n      position\\n      __typename\\n    }\\n    pins {\\n      ...ItemFields\\n      ...CommentItemExtFields @include(if: \$includeComments)\\n      position\\n      __typename\\n    }\\n    __typename\\n  }\\n}"}';
  }

  Future<void> _fetchAndSaveCurrBuildId() async {
    final response = await _dio.get(baseUrl);

    if (response.statusCode != 200) {
      throw Exception('Error fetching build id');
    }

    final regex = RegExp(r'\/_next\/static\/(\w+)\/_buildManifest.js');
    final match = regex.firstMatch(response.data);

    final buildId = match?.group(1);
    if (buildId == null) {
      throw Exception('Error parsing build id');
    }

    await SharedPrefsManager.set('build-id', buildId);
  }

  Future<String?> _getCurrBuildId() async {
    return await SharedPrefsManager.get('build-id');
  }

  Future<List<Post>> fetchMorePosts(PostType postType) async {
    final cursor = await SharedPrefsManager.get('${postType.name}-cursor');

    if (cursor == null) {
      throw Exception('Error fetching more');
    }

    try {
      final graphBody = _getGraphQLBodyFor(
        postType,
        cursor: cursor,
      );
      final body = jsonDecode(graphBody);
      final response = await _dio.post(
        '$baseUrl/api/graphql',
        data: body,
      );

      if (response.statusCode == 200) {
        return await _parsePosts(response.data, postType);
      }
    } catch (e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);

      final msg =
          ((e is DioException) ? e.response?.data.toString() : e.toString()) ??
              '';
      Utils.showException(msg, st);

      rethrow;
    }

    throw Exception('Error fetching more posts');
  }

  Future<Post> fetchPostDetails(String id) async {
    String? currCommit = await _getCurrBuildId();
    final response = await _dio.get('/$currCommit/items/$id.json');
    if (response.statusCode != 200) {
      throw Exception('Error fetching comments');
    }

    final props = response.data['pageProps'];

    final data = (props['ssrData'] ?? props['data'])['item'];

    return Post.fromJson(data);
  }
  // #endregion Posts

  // #region Profile
  Future<User?> fetchMe() async {
    final response = await _dio.post(
      '$baseUrl/api/graphql',
      data: // TODO: Use GqlBody and keep only the required fields
          '{"variables":{},"query":"{\\n  me {\\n    id\\n    name\\n    bioId\\n    photoId\\n    privates {\\n      autoDropBolt11s\\n      diagnostics\\n      noReferralLinks\\n      fiatCurrency\\n      greeterMode\\n      hideCowboyHat\\n      hideFromTopUsers\\n      hideGithub\\n      hideNostr\\n      hideTwitter\\n      hideInvoiceDesc\\n      hideIsContributor\\n      hideWalletBalance\\n      hideWelcomeBanner\\n      imgproxyOnly\\n      lastCheckedJobs\\n      nostrCrossposting\\n      noteAllDescendants\\n      noteCowboyHat\\n      noteDeposits\\n      noteWithdrawals\\n      noteEarning\\n      noteForwardedSats\\n      noteInvites\\n      noteItemSats\\n      noteJobIndicator\\n      noteMentions\\n      noteItemMentions\\n      sats\\n      tipDefault\\n      tipPopover\\n      turboTipping\\n      zapUndos\\n      upvotePopover\\n      wildWestMode\\n      withdrawMaxFeeDefault\\n      lnAddr\\n      autoWithdrawMaxFeePercent\\n      autoWithdrawThreshold\\n      __typename\\n    }\\n    optional {\\n      isContributor\\n      stacked\\n      streak\\n      githubId\\n      nostrAuthPubkey\\n      twitterId\\n      __typename\\n    }\\n    __typename\\n  }\\n}"}',
    );

    if (response.statusCode != 200) {
      Utils.showError('ERRN01 Error fetching profile');

      return null;
    }

    final me = response.data?['data']?['me'];

    if (me == null) {
      Utils.showError('ERRN02 Error fetching profile');

      return null;
    }

    await SharedPrefsManager.set(
      'me',
      jsonEncode(me),
    );

    return User.fromJson(me);
  }

  Future<User> fetchProfile(String userName) async {
    String? currCommit = await _getCurrBuildId();

    final response =
        await _dio.get('/$currCommit/$userName.json?name=$userName');

    if (response.statusCode == 200) {
      return _parseProfile(response.data);
    }

    if (response.statusCode == 404) {
      await _fetchAndSaveCurrBuildId();

      currCommit = await _getCurrBuildId();

      final retryResponse =
          await _dio.get('/$currCommit/$userName.json?name=$userName');

      if (retryResponse.statusCode == 200) {
        return _parseProfile(retryResponse.data);
      } else {
        throw Exception('Error fetching profile');
      }
    } else {
      throw Exception('Error parsing build id');
    }
  }

  User _parseProfile(dynamic responseData) {
    final response = (responseData['pageProps'] ?? responseData);
    final data = response['ssrData'] ?? response['data'];
    final userMap = data['user'] as Map<String, dynamic>;

    return User.fromJson(userMap);
  }
  // #endregion Profile

  // #region Auth
  void _goToLoginFailedPage() {
    final context = Utils.navigatorKey.currentContext;
    if (context == null) {
      Utils.showError('Error navigating to login failed page. Context null');

      return;
    }

    if (context.mounted) {
      Navigator.pushNamed(context, LoginFailedPage.id);

      return;
    }
  }

  Future<Session?> login(String link) async {
    final uri = Uri.parse(link);
    final queryParams = uri.queryParameters;

    final email = queryParams['email'];
    final token = queryParams['token'];

    if (email == null || token == null) {
      Utils.showError('1 Error validating token');

      return null;
    }

    final redirected = await _dio.get(
      uri.toString(),
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          if (status == null) {
            return false;
          }

          return status < 500;
        },
      ),
    );

    final value = redirected.headers.value(HttpHeaders.locationHeader);

    if (value == null) {
      Utils.showError('2 Error validating token');

      return null;
    }

    final response = await _dio.get(value);

    if (response.data is String &&
        response.data.contains('This magic link has expired')) {
      Utils.showError('This magic link has expired');

      return null;
    }

    if (response.statusCode != 200 &&
        response.statusCode != 302 &&
        response.statusCode != 403) {
      Utils.showError('3 Error validating token');

      return null;
    }

    if (response.statusCode == 403 &&
        response.realUri.toString() ==
            '$baseUrl/api/auth/error?error=Verification') {
      final sessionData = await SharedPrefsManager.get('session');
      if (sessionData == null || sessionData == 'null' || sessionData == '{}') {
        _goToLoginFailedPage();

        return null;
      }

      final session = Session.fromJson(jsonDecode(sessionData));

      if (email != session.user?.email) {
        _goToLoginFailedPage();

        return null;
      }
    }

    final sessionResponse = await _dio.get(
      '$baseUrl/api/auth/session',
    );

    if (sessionResponse.statusCode != 200) {
      Utils.showError(
        '4 Error validating token (Expected sessionResponse.statusCode 200 but got ${sessionResponse.statusCode})',
      );

      return null;
    }

    if (sessionResponse.data == {}) {
      Utils.showError(
        '5 Error validating token (Expected sessionResponse.data != {})',
      );

      return null;
    }

    await SharedPrefsManager.set(
      'session',
      jsonEncode(sessionResponse.data),
    );

    return Session.fromJson(sessionResponse.data);
  }

  Future<bool> requestMagicLink(String email) async {
    final csrfResponse = await _dio.get(
      '$baseUrl/api/auth/csrf',
      options: Options(
        headers: {
          'x-csrf-token': '1',
        },
      ),
    );

    if (csrfResponse.statusCode != 200) {
      Utils.showError('Error fetching csrf token');

      return false;
    }

    final csrfToken = csrfResponse.data['csrfToken'];
    _dio.options.headers['x-csrf-token'] = csrfToken;

    final response = await _dio.post(
      '$baseUrl/api/auth/signin/email?',
      data: {
        'email': email,
        'callbackUrl': '$baseUrl/',
        'csrfToken': csrfToken,
        'json': true,
      },
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          if (status == null) {
            return false;
          }

          return status < 500;
        },
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 302) {
      Utils.showError('Unknonw Error ');

      return false;
    }

    return true;
  }
  // #endregion Auth

  // #region Notifications
  Future<bool> hasNewNotes() async {
    debugPrint('fetching hasNewNotes');

    final response = await _dio.post(
      '$baseUrl/api/graphql',
      data:
          '{"variables":{},"query":"{\\n  hasNewNotes\\n}\\n"}', // TODO: Use GqlBody
    );

    if (response.statusCode == 200) {
      final ret = response.data['data']?['hasNewNotes'] as bool?;

      debugPrint('hasNewNotes: $ret');

      return ret == true;
    }

    debugPrint('hasNewNotes: false, statusCode: ${response.statusCode}');

    return false;
  }
  // #endregion Notifications

  // #region Zap Things
  Future<int?> zapPost(String id) async {
    final me = await fetchMe();

    if (me == null) {
      Utils.showError('Error fetching me');

      return 0;
    }

    final sats = me.tipDefault ?? 1;

    final response = await _dio.post(
      '$baseUrl/api/graphql',
      data: jsonEncode(
        GqlBody(
          operationName: 'idempotentAct',
          variables: {
            'id': id,
            'sats': sats,
          },
          query: '''
            mutation idempotentAct(\$id: ID!, \$sats: Int!) {
              act(id: \$id, sats: \$sats, idempotent: true) {
                id
                sats
              }
            }
          ''',
        ),
      ),
    );

    if (response.statusCode == 200) {
      final errors = (response.data['errors'] ?? []) as List;
      final error = errors.isEmpty ? null : errors[0]?['message'];

      if (error != null) {
        Utils.showError(error);

        return null;
      }

      return sats;
    }

    return 0;
  }
  // #endregion Zap Things

  // #region Items & Comments
  Future<Post?> upsertDiscussion({
    required String sub,
    required String title,
    required String text,
  }) async {
    title = title.replaceAll('\n', '\\n');
    text = text.replaceAll('\n', '\\n');

    final response = await _dio.post(
      '$baseUrl/api/graphql',
      data: // TODO: Use GqlBody and keep only the required fields
          '{"operationName":"upsertDiscussion","variables":{"sub":"$sub","title":"$title","text":"$text","forward":[]},"query":"mutation upsertDiscussion(\$sub: String, \$id: ID, \$title: String!, \$text: String, \$boost: Int, \$forward: [ItemForwardInput], \$hash: String, \$hmac: String) {\\n  upsertDiscussion(\\n    sub: \$sub\\n    id: \$id\\n    title: \$title\\n    text: \$text\\n    boost: \$boost\\n    forward: \$forward\\n    hash: \$hash\\n    hmac: \$hmac\\n  ) {\\n    id\\n    __typename\\n  }\\n}"}',
    );

    if (response.statusCode == 200) {
      final errors = (response.data['errors'] ?? []) as List;
      final error = errors.isEmpty ? null : errors[0]?['message'];

      if (error != null) {
        Utils.showError(error);

        throw Exception(error);
      }

      return Post.fromJson(response.data);
    }

    throw Exception('Failed to post discussion');
  }

  Future<Post?> upsertComment({
    required String parentId,
    required String text,
  }) async {
    text = text.replaceAll('\n', '\\n');

    final response = await _dio.post(
      '$baseUrl/api/graphql',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      data: jsonEncode(
        GqlBody(
          operationName: 'upsertComment',
          variables: {
            'parentId': parentId,
            'text': text,
          },
          query: '''
		mutation upsertComment(\$parentId: ID!, \$text: String!) {
			upsertComment(parentId: \$parentId, text: \$text) {
				id
			}
		}
          ''',
        ),
      ),
    );

    if (response.statusCode == 200) {
      final errors = (response.data['errors'] ?? []) as List;
      final error = errors.isEmpty ? null : errors[0]?['message'];

      if (error != null) {
        Utils.showError(error);
        throw Exception(error);
      }

      return Post.fromJson(response.data);
    }

    throw Exception('Failed to create comment');
  }
  // #endregion Items & Comments
}

class GqlBody {
  final String? operationName;
  final String? query;
  final Map<String, dynamic>? variables;

  GqlBody({
    this.operationName,
    this.query,
    this.variables,
  });

  Map<String, dynamic> toJson() => {
        'operationName': operationName,
        'query': query,
        'variables': variables,
      };
}

class GqlError {
  final String? message;

  GqlError({
    this.message,
  });
}
