import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/data/models/user.dart';

final class Api {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://stacker.news/_next/data',
    ),
  );

  // Ignore 404 errors so we can update the build-id and re-fetch posts
  Api() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response?.statusCode == 404) {
            handler.resolve(Response(
              requestOptions: error.requestOptions,
              statusCode: 404,
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
}

class NetworkError extends Error {}
