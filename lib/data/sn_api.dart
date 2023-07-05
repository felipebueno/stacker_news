import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/data/models/session.dart';
import 'package:stacker_news/data/models/user.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/about/login_failed_page.dart';

final class Api {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://stacker.news/_next/data',
      headers: {
        'authority': 'stacker.news',
        'accept': '*/*',
        'accept-language': 'en-US,en;q=0.9,pt;q=0.8',
        'content-type': 'application/x-www-form-urlencoded',
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

  Api() {
    _cookieJar();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final statusCode = error.response?.statusCode;

          if (statusCode == 403 || statusCode == 404) {
            // Ignore 403 errors when unable to login with magic link
            // Ignore 404 errors so we can update the build-id and re-fetch posts
            handler.resolve(Response(
              requestOptions: error.requestOptions,
              statusCode: statusCode,
            ));
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }
// START Posts
  Future<List<Post>> fetchInitialPosts(PostType postType) async {
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
  }

  Future<List<Post>> _parsePosts(
    dynamic responseData,
    PostType postType,
  ) async {
    final data = (responseData['pageProps'] ?? responseData)['data'];
    final itemsMap = (data['items'] ?? data['topItems']);
    final List items = itemsMap['items'];

    final cursor = itemsMap['cursor'];
    if (cursor != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${postType.name}-cursor', cursor);
    }

    return items.map((item) => Post.fromJson(item)).toList();
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('build-id', newBuildId);
  }

  Future<String?> _getCurrBuildId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('build-id');
  }

  Future<List<Post>> fetchMorePosts(PostType postType) async {
    final prefs = await SharedPreferences.getInstance();
    final cursor = prefs.getString('${postType.name}-cursor');

    if (cursor == null) {
      throw Exception('Error fetching more');
    }

    final response = await _dio.post(
      'https://stacker.news/api/graphql',
      data: postType.getBody(cursor),
    );

    if (response.statusCode == 200) {
      return await _parsePosts(response.data, postType);
    }

    throw Exception('Error fetching more');
  }

  Future<Post> fetchPostDetails(String id) async {
    String? currCommit = await _getCurrBuildId();
    final response = await _dio.get('/$currCommit/items/$id.json');
    if (response.statusCode != 200) {
      throw Exception('Error fetching comments');
    }

    final data = response.data['pageProps']['data']['item'];

    return Post.fromJson(data);
  }

// END Posts

// START Profile
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
    final userMap =
        responseData['pageProps']['data']['user'] as Map<String, dynamic>;

    return User.fromJson(userMap);
  }
// END Profile

// START Auth
  Future<void> validateLink(String link) async {
    final uri = Uri.parse(link);
    final queryParams = uri.queryParameters;

    final email = queryParams['email'];
    final token = queryParams['token'];

    if (email == null || token == null) {
      throw Exception('1 Error validating token');
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
      throw Exception('2 Error validating token');
    }

    final response = await _dio.get(value);

    if (response.statusCode != 302) {
      if (response.statusCode == 403 &&
          response.realUri.toString() ==
              'https://stacker.news/api/auth/error?error=Verification') {
        // TODO: If the magiclink.email == savedSession?.email then we can just navigate to the home page
        final context = Utils.navigatorKey.currentState!.overlay!.context;
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, LoginFailedPage.id);
        }
      }

      throw Exception('3 Error validating token');
    }
  }

  Future<Session> getSession(String link) async {
    final sessionResponse =
        await _dio.get('https://stacker.news/api/auth/session');

    if (sessionResponse.statusCode != 200) {
      throw Exception('Error validating token');
    }

    final session = Session.fromJson(sessionResponse.data);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session', jsonEncode(sessionResponse.data));

    print(session);

    return session;
  }

  Future<void> requestMagicLink(String email) async {
    final csrfResponse = await _dio.get(
      'https://stacker.news/api/auth/csrf',
      options: Options(
        headers: {
          'x-csrf-token': '1',
        },
      ),
    );

    if (csrfResponse.statusCode != 200) {
      throw Exception('Error fetching csrf token');
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
    );

    if (response.statusCode != 200) {
      throw Exception('Unknonw Error ');
    }
  }
// END Auth
}
