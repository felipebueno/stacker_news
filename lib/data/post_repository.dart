import 'package:dio/dio.dart';
import 'package:stacker_news/data/models/item.dart';

enum PostType {
  top,
  bitcoin,
  nostr,
  job,
}

abstract class PostRepository {
  Future<List<Item>> fetchPosts(PostType postType);

  Future<List<Item>> fetchMorePosts(PostType postType, int from, int to);

  Future<Item> fetchItem(Item post);
}

final class PostRepositoryImpl implements PostRepository {
  static const apiUrl = 'https://stacker.news/_next/data/ef533';
  final Dio dio = Dio();

  @override
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

      case PostType.job:
        stories = '~/jobs.json?sub=jobs';

        break;

      default:
        break;
    }

    final response = await dio.get('$apiUrl/$stories');
    if (response.statusCode == 200) {
      final data = response.data['pageProps']['data'];
      final List items = (data['items'] ?? data['topItems'])['items'];

      return items.isEmpty
          ? []
          : items.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }

  @override
  Future<List<Item>> fetchMorePosts(PostType postType, int from, int to) async {
    throw UnimplementedError();
  }

  @override
  Future<Item> fetchItem(Item post) async {
    final response = await dio.get('$apiUrl/items/${post.id}.json');
    if (response.statusCode == 200) {
      final data = response.data['pageProps']['data']['item'];

      return Item.fromJson(data);
    } else {
      throw Exception('Error fetching comments');
    }
  }
}

class NetworkError extends Error {}
