// ignore_for_file: prefer_single_quotes

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
import './shared_prefs_manager.dart';

final class Api {
  Api() {
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
      // TODO: Keep only the relevant values
      baseUrl: 'https://stacker.news/_next/data',
      headers: {
        'authority': 'stacker.news',
        'accept': '*/*',
        'accept-language': 'en-US,en;q=0.9,pt;q=0.8',
        'content-type': 'application/json',
        'origin': 'https://stacker.news',
        'sec-ch-ua':
            '"Not.A/Brand";v="8", "Chromium";v="114", "Google Chrome";v="114"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"Linux"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
        'user-agent':
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
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

    final cursor = itemsMap['cursor'];
    if (cursor != null) {
      await SharedPrefsManager.create(
        '${postType.name}-cursor',
        cursor,
      );
    }

    return items.map((item) {
      return Post.fromJson(item);
    }).toList();
  }

  Future<void> _fetchAndSaveCurrBuildId() async {
    final response = await _dio.get('https://stacker.news');

    if (response.statusCode != 200) {
      throw Exception('Error fetching build id');
    }

    final regex = RegExp(r'\/_next\/static\/(\w+)\/_buildManifest.js');
    final match = regex.firstMatch(response.data);

    final buildId = match?.group(1);
    if (buildId == null) {
      throw Exception('Error parsing build id');
    }

    await _saveBuildId(buildId);
  }

  Future<void> _saveBuildId(String newBuildId) async {
    await SharedPrefsManager.create('build-id', newBuildId);
  }

  Future<String?> _getCurrBuildId() async {
    return await SharedPrefsManager.read('build-id');
  }

  Future<List<Post>> fetchMorePosts(PostType postType) async {
    final cursor = await SharedPrefsManager.read('${postType.name}-cursor');

    if (cursor == null) {
      throw Exception('Error fetching more');
    }

    try {
      final body = jsonDecode(postType.getGraphQLBody(cursor));
      final response = await _dio.post(
        'https://stacker.news/api/graphql',
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
      'https://stacker.news/api/graphql',
      data:
          "{\"variables\":{},\"query\":\"{\\n  me {\\n    id\\n    name\\n    bioId\\n    privates {\\n      autoDropBolt11s\\n      diagnostics\\n      fiatCurrency\\n      greeterMode\\n      hideCowboyHat\\n      hideFromTopUsers\\n      hideInvoiceDesc\\n      hideIsContributor\\n      hideWalletBalance\\n      hideWelcomeBanner\\n      imgproxyOnly\\n      lastCheckedJobs\\n      nostrCrossposting\\n      noteAllDescendants\\n      noteCowboyHat\\n      noteDeposits\\n      noteEarning\\n      noteForwardedSats\\n      noteInvites\\n      noteItemSats\\n      noteJobIndicator\\n      noteMentions\\n      sats\\n      tipDefault\\n      tipPopover\\n      turboTipping\\n      upvotePopover\\n      wildWestMode\\n      withdrawMaxFeeDefault\\n      __typename\\n    }\\n    optional {\\n      isContributor\\n      stacked\\n      streak\\n      __typename\\n    }\\n    __typename\\n  }\\n}\"}",
    );

    if (response.statusCode != 200) {
      Utils.showError('1 Error fetching profile');

      return null;
    }

    final me = response.data?['data']?['me'];

    if (me == null) {
      Utils.showError('2 Error fetching profile');

      return null;
    }

    await SharedPrefsManager.create(
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
            'https://stacker.news/api/auth/error?error=Verification') {
      final sessionData = await SharedPrefsManager.read('session');
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
      'https://stacker.news/api/auth/session',
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

    await SharedPrefsManager.create(
      'session',
      jsonEncode(sessionResponse.data),
    );

    return Session.fromJson(sessionResponse.data);
  }

  Future<bool> requestMagicLink(String email) async {
    final csrfResponse = await _dio.get(
      'https://stacker.news/api/auth/csrf',
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
      'https://stacker.news/api/auth/signin/email?',
      data: {
        'email': email,
        'callbackUrl': 'http://stacker.news/',
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
      'https://stacker.news/api/graphql',
      data: '{"variables":{},"query":"{\\n  hasNewNotes\\n}\\n"}',
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

    final amount = me.tipDefault ?? 1;

    final response = await _dio.post(
      'https://stacker.news/api/graphql',
      data:
          '{"operationName":"act","variables":{"id":"$id","sats": $amount},"query":"mutation act(\$id: ID!, \$sats: Int!) {\\n  act(id: \$id, sats: \$sats) {\\n    vote\\n        __typename\\n  }\\n}\\n"}',
    );

    if (response.statusCode == 200) {
      final errors = (response.data['errors'] ?? []) as List;
      final error = errors.isEmpty ? null : errors[0]?['message'];

      if (error != null) {
        Utils.showError(error);

        return null;
      }

      return amount;
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
      'https://stacker.news/api/graphql',
      data:
          "{\"operationName\":\"upsertDiscussion\",\"variables\":{\"sub\":\"$sub\",\"title\":\"$title\",\"text\":\"$text\",\"forward\":[]},\"query\":\"mutation upsertDiscussion(\$sub: String, \$id: ID, \$title: String!, \$text: String, \$boost: Int, \$forward: [ItemForwardInput], \$hash: String, \$hmac: String) {\\n  upsertDiscussion(\\n    sub: \$sub\\n    id: \$id\\n    title: \$title\\n    text: \$text\\n    boost: \$boost\\n    forward: \$forward\\n    hash: \$hash\\n    hmac: \$hmac\\n  ) {\\n    id\\n    __typename\\n  }\\n}\"}",
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
      'https://stacker.news/api/graphql',
      data:
          "{\"operationName\":\"upsertComment\",\"variables\":{\"parentId\":\"$parentId\",\"text\":\"$text\"},\"query\":\"fragment CommentFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  text\\n  user {\\n    id\\n    name\\n    optional {\\n      streak\\n      __typename\\n    }\\n    meMute\\n    __typename\\n  }\\n  sats\\n  upvotes\\n  wvotes\\n  boost\\n  meSats\\n  meDontLike\\n  meBookmark\\n  meSubscription\\n  outlawed\\n  freebie\\n  path\\n  commentSats\\n  mine\\n  otsHash\\n  ncomments\\n  imgproxyUrls\\n  __typename\\n}\\n\\nfragment CommentsRecursive on Item {\\n  ...CommentFields\\n  comments {\\n    ...CommentFields\\n    comments {\\n      ...CommentFields\\n      comments {\\n        ...CommentFields\\n        comments {\\n          ...CommentFields\\n          comments {\\n            ...CommentFields\\n            comments {\\n              ...CommentFields\\n              comments {\\n                ...CommentFields\\n                __typename\\n              }\\n              __typename\\n            }\\n            __typename\\n          }\\n          __typename\\n        }\\n        __typename\\n      }\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nmutation upsertComment(\$text: String!, \$parentId: ID!, \$hash: String, \$hmac: String) {\\n  upsertComment(text: \$text, parentId: \$parentId, hash: \$hash, hmac: \$hmac) {\\n    ...CommentFields\\n    comments {\\n      ...CommentsRecursive\\n      __typename\\n    }\\n    __typename\\n  }\\n}\"}",
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
