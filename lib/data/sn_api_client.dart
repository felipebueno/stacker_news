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
            final requestUrl = error.requestOptions.uri.toString();
            final requestMethod = error.requestOptions.method;

            debugPrint('=== DIO Error Interceptor ===');
            debugPrint('Status Code: $statusCode');
            debugPrint('Request: $requestMethod $requestUrl');
            debugPrint('Error Message: ${error.message}');

            // Log response body/data for debugging GraphQL errors
            if (error.response?.data != null) {
              debugPrint('Response Data: ${error.response!.data}');
            }

            // Log request data if available (for debugging what was sent)
            if (error.requestOptions.data != null) {
              debugPrint('Request Data: ${error.requestOptions.data}');
            }
   
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
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:126.0) Gecko/20100101 Firefox/126.0',
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
      final endpoint = postType.endpoint;

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

    final itemsMap = (data['items'] ?? data['topItems'] ?? data['notifications']);
    final List items = itemsMap['items'] ?? itemsMap['notifications'];

    if (postType == PostType.home) {
      // TODO: Temporary solution to get Stacker Saloon on the list
      final List? pins = itemsMap['pins'];
      if (pins != null && pins.isNotEmpty) {
        for (final pin in pins) {
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
    if (postType == PostType.top || postType == PostType.home || postType == PostType.recent) {
      return jsonEncode(
        GqlBody(
          operationName: 'SubItems',
          variables: {
            'includeComments': false,
            'cursor': cursor,
          },
          query: '''
            fragment SubFields on Sub {
              name
              postTypes
              allowFreebies
              rankingType
              billingType
              billingCost
              billingAutoRenew
              billedLastAt
              billPaidUntil
              baseCost
              userId
              desc
              status
              meMuteSub
              meSubscription
              nsfw
              __typename
            }

            fragment SubFullFields on Sub {
              ...SubFields
              user {
                name
                id
                optional {
                  streak
                  __typename
                }
                __typename
              }
              __typename
            }

            fragment ItemFields on Item {
              id
              parentId
              createdAt
              deletedAt
              title
              url
              user {
                id
                name
                optional {
                  streak
                  __typename
                }
                meMute
                __typename
              }
              sub {
                name
                userId
                meMuteSub
                meSubscription
                nsfw
                __typename
              }
              otsHash
              position
              sats
              boost
              bounty
              bountyPaidTo
              noteId
              path
              upvotes
              meSats
              meDontLikeSats
              meBookmark
              meSubscription
              meForward
              freebie
              bio
              ncomments
              commentSats
              lastCommentAt
              isJob
              company
              location
              remote
              subName
              pollCost
              pollExpiresAt
              status
              uploadId
              mine
              imgproxyUrls
              rel
              __typename
            }

            fragment CommentItemExtFields on Item {
              text
              root {
                id
                title
                bounty
                bountyPaidTo
                subName
                sub {
                  name
                  userId
                  meMuteSub
                  __typename
                }
                user {
                  name
                  optional {
                    streak
                    __typename
                  }
                  id
                  __typename
                }
                __typename
              }
              __typename
            }

            query SubItems(\$sub: String, \$sort: String, \$cursor: String, \$type: String, \$name: String, \$when: String, \$from: String, \$to: String, \$by: String, \$limit: Limit, \$includeComments: Boolean = false) {
              sub(name: \$sub) {
                ...SubFullFields
                __typename
              }
              items(
                sub: \$sub
                sort: \$sort
                cursor: \$cursor
                type: \$type
                name: \$name
                when: \$when
                from: \$from
                to: \$to
                by: \$by
                limit: \$limit
              ) {
                cursor
                items {
                  ...ItemFields
                  ...CommentItemExtFields @include(if: \$includeComments)
                  position
                  __typename
                }
                pins {
                  ...ItemFields
                  ...CommentItemExtFields @include(if: \$includeComments)
                  position
                  __typename
                }
                __typename
              }
            }
          ''',
        ),
      );
    } else if (postType == PostType.notifications) {
      return jsonEncode(
        GqlBody(
          operationName: 'Notifications',
          variables: {
            'cursor': cursor,
          },
          query: '''
            fragment ItemFields on Item {
              id
              parentId
              createdAt
              deletedAt
              title
              url
              user {
                id
                name
                optional {
                  streak
                  __typename
                }
                meMute
                __typename
              }
              sub {
                name
                userId
                meMuteSub
                meSubscription
                nsfw
                __typename
              }
              otsHash
              position
              sats
              boost
              bounty
              bountyPaidTo
              noteId
              path
              upvotes
              meSats
              meDontLikeSats
              meBookmark
              meSubscription
              meForward
              freebie
              bio
              ncomments
              commentSats
              lastCommentAt
              isJob
              company
              location
              remote
              subName
              pollCost
              pollExpiresAt
              status
              uploadId
              mine
              imgproxyUrls
              rel
              apiKey
              __typename
            }

            fragment ItemFullFields on Item {
              ...ItemFields
              text
              root {
                id
                title
                bounty
                bountyPaidTo
                subName
                user {
                  id
                  name
                  optional {
                    streak
                    __typename
                  }
                  __typename
                }
                sub {
                  name
                  userId
                  meMuteSub
                  meSubscription
                  __typename
                }
                __typename
              }
              forwards {
                userId
                pct
                user {
                  name
                  __typename
                }
                __typename
              }
              __typename
            }

            fragment InviteFields on Invite {
              id
              createdAt
              invitees {
                id
                name
                __typename
              }
              gift
              limit
              revoked
              user {
                id
                name
                optional {
                  streak
                  __typename
                }
                __typename
              }
              poor
              __typename
            }

            fragment SubFields on Sub {
              name
              createdAt
              postTypes
              allowFreebies
              rankingType
              billingType
              billingCost
              billingAutoRenew
              billedLastAt
              billPaidUntil
              baseCost
              userId
              desc
              status
              meMuteSub
              meSubscription
              nsfw
              __typename
            }

            query Notifications(\$cursor: String, \$inc: String) {
              notifications(cursor: \$cursor, inc: \$inc) {
                cursor
                lastChecked
                notifications {
                  __typename
                  ... on Mention {
                    id
                    sortTime
                    mention
                    item {
                      ...ItemFullFields
                      text
                      __typename
                    }
                    __typename
                  }
                  ... on ItemMention {
                    id
                    sortTime
                    item {
                      ...ItemFullFields
                      text
                      __typename
                    }
                    __typename
                  }
                  ... on Votification {
                    id
                    sortTime
                    earnedSats
                    item {
                      ...ItemFullFields
                      text
                      __typename
                    }
                    __typename
                  }
                  ... on Revenue {
                    id
                    sortTime
                    earnedSats
                    subName
                    __typename
                  }
                  ... on ForwardedVotification {
                    id
                    sortTime
                    earnedSats
                    item {
                      ...ItemFullFields
                      text
                      __typename
                    }
                    __typename
                  }
                  ... on Streak {
                    id
                    sortTime
                    days
                    __typename
                  }
                  ... on Earn {
                    id
                    sortTime
                    minSortTime
                    earnedSats
                    sources {
                      posts
                      comments
                      tipPosts
                      tipComments
                      __typename
                    }
                    __typename
                  }
                  ... on Referral {
                    id
                    sortTime
                    __typename
                  }
                  ... on Reply {
                    id
                    sortTime
                    item {
                      ...ItemFullFields
                      text
                      __typename
                    }
                    __typename
                  }
                  ... on FollowActivity {
                    id
                    sortTime
                    item {
                      ...ItemFullFields
                      text
                      __typename
                    }
                    __typename
                  }
                  ... on TerritoryPost {
                    id
                    sortTime
                    item {
                      ...ItemFullFields
                      text
                      __typename
                    }
                    __typename
                  }
                  ... on TerritoryTransfer {
                    id
                    sortTime
                    sub {
                      ...SubFields
                      __typename
                    }
                    __typename
                  }
                  ... on Invitification {
                    id
                    sortTime
                    invite {
                      ...InviteFields
                      __typename
                    }
                    __typename
                  }
                  ... on JobChanged {
                    id
                    sortTime
                    item {
                      ...ItemFields
                      __typename
                    }
                    __typename
                  }
                  ... on SubStatus {
                    id
                    sortTime
                    sub {
                      ...SubFields
                      __typename
                    }
                    __typename
                  }
                  ... on InvoicePaid {
                    id
                    sortTime
                    earnedSats
                    invoice {
                      id
                      nostr
                      comment
                      lud18Data
                      __typename
                    }
                    __typename
                  }
                  ... on WithdrawlPaid {
                    id
                    sortTime
                    earnedSats
                    withdrawl {
                      autoWithdraw
                      __typename
                    }
                    __typename
                  }
                  ... on Reminder {
                    id
                    sortTime
                    item {
                      ...ItemFullFields
                      __typename
                    }
                    __typename
                  }
                }
                __typename
              }
            }
          ''',
        ),
      );
    }

    return jsonEncode(
      GqlBody(
        operationName: 'SubItems',
        variables: {
          'includeComments': false,
          'sub': postType.name,
          'cursor': cursor,
        },
        query: '''
          fragment SubFields on Sub {
            name
            postTypes
            allowFreebies
            rankingType
            billingType
            billingCost
            billingAutoRenew
            billedLastAt
            billPaidUntil
            baseCost
            userId
            desc
            status
            meMuteSub
            meSubscription
            nsfw
            __typename
          }

          fragment SubFullFields on Sub {
            ...SubFields
            user {
              name
              id
              optional {
                streak
                __typename
              }
              __typename
            }
            __typename
          }

          fragment ItemFields on Item {
            id
            parentId
            createdAt
            deletedAt
            title
            url
            user {
              id
              name
              optional {
                streak
                __typename
              }
              meMute
              __typename
            }
            sub {
              name
              userId
              meMuteSub
              meSubscription
              nsfw
              __typename
            }
            otsHash
            position
            sats
            boost
            bounty
            bountyPaidTo
            noteId
            path
            upvotes
            meSats
            meDontLikeSats
            meBookmark
            meSubscription
            meForward
            freebie
            bio
            ncomments
            commentSats
            lastCommentAt
            isJob
            company
            location
            remote
            subName
            pollCost
            pollExpiresAt
            status
            uploadId
            mine
            imgproxyUrls
            rel
            __typename
          }

          fragment CommentItemExtFields on Item {
            text
            root {
              id
              title
              bounty
              bountyPaidTo
              subName
              sub {
                name
                userId
                meMuteSub
                __typename
              }
              user {
                name
                optional {
                  streak
                  __typename
                }
                id
                __typename
              }
              __typename
            }
            __typename
          }

          query SubItems(\$sub: String, \$sort: String, \$cursor: String, \$type: String, \$name: String, \$when: String, \$from: String, \$to: String, \$by: String, \$limit: Limit, \$includeComments: Boolean = false) {
            sub(name: \$sub) {
              ...SubFullFields
              __typename
            }
            items(
              sub: \$sub
              sort: \$sort
              cursor: \$cursor
              type: \$type
              name: \$name
              when: \$when
              from: \$from
              to: \$to
              by: \$by
              limit: \$limit
            ) {
              cursor
              items {
                ...ItemFields
                ...CommentItemExtFields @include(if: \$includeComments)
                position
                __typename
              }
              pins {
                ...ItemFields
                ...CommentItemExtFields @include(if: \$includeComments)
                position
                __typename
              }
              __typename
            }
          }
        ''',
      ),
    );
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

      final msg = ((e is DioException) ? e.response?.data.toString() : e.toString()) ?? '';
      Utils.showException(msg, st);

      rethrow;
    }

    throw Exception('Error fetching more posts');
  }

  Future<Post?> fetchPostDetails(String id) async {
    final currCommit = await _getCurrBuildId();
    final response = await _dio.get('/$currCommit/items/$id.json');
    // print(response);
    if (response.statusCode != 200) {
      throw Exception('Error fetching comments');
    }

    final props = response.data['pageProps'];

    final data = (props['ssrData'] ?? props['data'])['item'];

    Post? post;

    try {
      post = Post.fromJson(data);
    } catch (e, st) {
      // TODO
      print(e);
      print(st);

      throw Exception(e);
    }

    return post;
  }
  // #endregion Posts

  // #region Profile
  Future<User?> fetchMe() async {
    final response = await _dio.post(
      '$baseUrl/api/graphql',
      data: jsonEncode(
        GqlBody(
          variables: {},
          query: '''
            {
              me {
                id
                name
                bioId
                photoId
                privates {
                  autoDropBolt11s
                  diagnostics
                  noReferralLinks
                  fiatCurrency
                  hideCowboyHat
                  hideFromTopUsers
                  hideGithub
                  hideNostr
                  hideTwitter
                  hideInvoiceDesc
                  imgproxyOnly
                  nostrCrossposting
                  noteAllDescendants
                  noteCowboyHat
                  noteDeposits
                  noteWithdrawals
                  noteEarning
                  noteForwardedSats
                  noteInvites
                  noteItemSats
                  noteMentions
                  noteItemMentions
                  sats
                  tipDefault
                  tipPopover
                  turboTipping
                  zapUndos
                  upvotePopover
                  autoWithdrawThreshold
                  __typename
                }
                optional {
                  isContributor
                  stacked
                  streak
                  githubId
                  nostrAuthPubkey
                  twitterId
                  __typename
                }
                __typename
              }
            }
          ''',
        ),
      ),
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

    final response = await _dio.get('/$currCommit/$userName.json?name=$userName');

    if (response.statusCode == 200) {
      return _parseProfile(response.data);
    }

    if (response.statusCode == 404) {
      await _fetchAndSaveCurrBuildId();

      currCommit = await _getCurrBuildId();

      final retryResponse = await _dio.get('/$currCommit/$userName.json?name=$userName');

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

  Future<Session?> loginWithMagicCode({
    required String email,
    required String magicCode,
  }) async {
    if (magicCode.isEmpty) {
      Utils.showError('Error: Magic Code is empty');
      return null;
    }

    try {
      // First request to the callback endpoint with minimal headers
      final callbackResponse = await _dio.get(
        '$baseUrl/api/auth/callback/email?callbackUrl=${Uri.encodeComponent(baseUrl)}&token=$magicCode&email=${Uri.encodeComponent(email)}',
        options: Options(
          headers: {
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
            'Service-Worker-Navigation-Preload': 'true',
            'Upgrade-Insecure-Requests': '1',
            'User-Agent':
                'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
            'sec-ch-prefers-color-scheme': 'dark',
            'sec-ch-ua': '"Not)A;Brand";v="8", "Chromium";v="138"',
            'sec-ch-ua-mobile': '?0',
            'sec-ch-ua-platform': '"Linux"',
          },
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // Handle redirect location
      final location = callbackResponse.headers.value(HttpHeaders.locationHeader);
      if (location == null) {
        Utils.showError('Error validating token: No redirect location');
        return null;
      }

      // Check if we got redirected to the error page
      if (location.contains('/api/auth/error?error=Verification')) {
        // Try to get existing session
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

        // If we have a valid session, return it
        return session;
      }

      // If we got redirected to a success page, follow it
      final response = await _dio.get(
        location,
        options: Options(
          headers: {
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
            'User-Agent':
                'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
          },
        ),
      );

      // Check for expired magic link
      if (response.data is String && response.data.contains('This magic link has expired')) {
        Utils.showError('This magic link has expired');
        return null;
      }

      // Get the session after successful login
      final sessionResponse = await _dio.get(
        '$baseUrl/api/auth/session',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (sessionResponse.statusCode != 200) {
        Utils.showError(
          'Error validating token (Expected sessionResponse.statusCode 200 but got ${sessionResponse.statusCode})',
        );
        return null;
      }

      if (sessionResponse.data == null || sessionResponse.data.isEmpty) {
        Utils.showError('Error validating token: Empty session data');
        return null;
      }

      // Save the session
      await SharedPrefsManager.set(
        'session',
        jsonEncode(sessionResponse.data),
      );

      return Session.fromJson(sessionResponse.data);
    } catch (e) {
      Utils.showError('Login failed: ${e.toString()}');
      return null;
    }
  }

  Future<bool> requestMagicToken(String email) async {
    // Fetch CSRF token
    final csrfResponse = await _dio.get(
      '$baseUrl/api/auth/csrf',
      options: Options(
        headers: {'x-csrf-token': '1'},
      ),
    );

    if (csrfResponse.statusCode != 200) {
      Utils.showError('Error fetching CSRF token');
      return false;
    }

    final csrfToken = csrfResponse.data['csrfToken'];

    final formData =
        'email=${Uri.encodeComponent(email)}'
        '&callbackUrl=${Uri.encodeComponent('$baseUrl/')}'
        '&multiAuth=false'
        '&csrfToken=${Uri.encodeComponent(csrfToken)}'
        '&json=true';

    final response = await _dio.post(
      '$baseUrl/api/auth/signin/email',
      data: formData,
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
        headers: {
          'origin': baseUrl,
          'referer': '$baseUrl/login?callbackUrl=${Uri.encodeComponent('$baseUrl/')}',
          'sec-ch-ua': '"Not)A;Brand";v="8", "Chromium";v="138"',
          'sec-ch-ua-mobile': '?0',
          'sec-ch-ua-platform': '"Linux"',
          'sec-fetch-dest': 'empty',
          'sec-fetch-mode': 'cors',
          'sec-fetch-site': 'same-origin',
        },
        followRedirects: false,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 302) {
      Utils.showError('Failed with status: ${response.statusCode}');
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
      data: jsonEncode(
        GqlBody(
          variables: {},
          query: '''
            {
              hasNewNotes
            }
          ''',
        ),
      ),
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
          operationName: 'Act',
          variables: {
            'id': id,
            'sats': sats,
          },
          query: '''
            mutation Act(\$id: ID!, \$sats: Int!) {
              act(id: \$id, sats: \$sats) {
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
      data: jsonEncode(
        GqlBody(
          operationName: 'upsertDiscussion',
          variables: {
            'sub': sub,
            'title': title,
            'text': text,
            'forward': [],
          },
          query: '''
            mutation upsertDiscussion(
              \$sub: String
              \$id: ID
              \$title: String!
              \$text: String
              \$boost: Int
              \$forward: [ItemForwardInput]
              \$hash: String
              \$hmac: String
            ) {
              upsertDiscussion(
                sub: \$sub
                id: \$id
                title: \$title
                text: \$text
                boost: \$boost
                forward: \$forward
                hash: \$hash
                hmac: \$hmac
              ) {
                id
                __typename
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
        __typename
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
