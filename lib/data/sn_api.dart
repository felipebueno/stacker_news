import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/data/models/user.dart';

enum PostType {
  top,
  bitcoin,
  nostr,
  tech,
  meta,
  job,
}

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
// START Posts / Items
  Future<List<Item>> fetchPosts(PostType postType) async {
    String stories = '';

    switch (postType) {
      case PostType.top:
        stories = 'top/posts/day.json?when=day';

        break;

      case PostType.bitcoin:
        stories = '~/bitcoin.json?sub=bitcoin';

        break;

      case PostType.nostr:
        stories = '~/nostr.json?sub=bitcoin';

        break;

      case PostType.tech:
        stories = '~/tech.json?sub=tech';

      case PostType.meta:
        stories = '~/meta.json?sub=meta';

      case PostType.job:
        stories = '~/jobs.json?sub=jobs';

        break;

      default:
        break;
    }

    String? currCommit = await _getCurrBuildId();

    final response = await _dio.get('/$currCommit/$stories');

    if (response.statusCode == 200) {
      return await _parseItems(response.data);
    }

    if (response.statusCode == 404) {
      await _fetchAndSaveCurrBuildId();

      currCommit = await _getCurrBuildId();

      final retryResponse = await _dio.get('/$currCommit/$stories');

      if (retryResponse.statusCode == 200) {
        return await _parseItems(retryResponse.data);
      } else {
        throw Exception('Error fetching posts');
      }
    } else {
      throw Exception('Error parsing build id');
    }
  }

  Future<List<Item>> _parseItems(dynamic responseData) async {
    final data = (responseData['pageProps'] ?? responseData)['data'];
    final itemsMap = (data['items'] ?? data['topItems']);
    final List items = itemsMap['items'];

    // Get cursor from list
    final cursor = itemsMap['cursor'];
    // Save cursor to shared prefs
    if (cursor != null) {
      await _saveCursor(cursor);
    }

    return items.map((item) => Item.fromJson(item)).toList();
  }

  Future<void> _saveCursor(String cursor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cursor', cursor);
  }

  Future<String?> _getCursor() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('cursor');
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

  Future<List<Item>> fetchMorePosts(PostType postType) async {
    final cursor = await _getCursor();

    final response = await _dio.post(
      'https://stacker.news/api/graphql',
      data:
          '{\"operationName\":\"topItems\",\"variables\":{\"when\":\"day\",\"cursor\":\"$cursor\"},\"query\":\"fragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    name\\n    streak\\n    hideCowboyHat\\n    id\\n    __typename\\n  }\\n  fwdUserId\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  path\\n  upvotes\\n  meSats\\n  meDontLike\\n  meBookmark\\n  meSubscription\\n  outlawed\\n  freebie\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  status\\n  uploadId\\n  mine\\n  __typename\\n}\\n\\nquery topItems(\$sort: String, \$cursor: String, \$when: String) {\\n  topItems(sort: \$sort, cursor: \$cursor, when: \$when) {\\n    cursor\\n    items {\\n      ...ItemFields\\n      __typename\\n    }\\n    pins {\\n      ...ItemFields\\n      __typename\\n    }\\n    __typename\\n  }\\n}\\n\"}',
    );

    if (response.statusCode == 200) {
      return await _parseItems(response.data);
    }

    throw Exception('Error fetching more');
  }

  Future<Item> fetchItem(Item post) async {
    String? currCommit = await _getCurrBuildId();
    final response = await _dio.get('/$currCommit/items/${post.id}.json');
    if (response.statusCode != 200) {
      throw Exception('Error fetching comments');
    }

    final data = response.data['pageProps']['data']['item'];

    return Item.fromJson(data);
  }

// END Posts / Items

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
