import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/auth/sign_in_failed_page.dart';

import './models/post.dart';
import './models/session.dart';
import './models/sub.dart';
import './models/user.dart';
import 'package:stacker_news/utils/log_service.dart';
import './shared_prefs_manager.dart' show SharedPrefsManager;

const String baseUrl = String.fromEnvironment(
  'BASE_URL',
  defaultValue: 'https://stacker.news',
);

final class SNApiClient {
  SNApiClient() {
    assert(baseUrl.isNotEmpty);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          LogService().info('[API] Request: ${options.method} ${options.uri}');
          LogService().debug('[API] Request Data: ${options.data}');
          return handler.next(options);
        },
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
            if (kDebugMode) {
              LogService().debug('=== DIO Error Interceptor ===');
              LogService().debug('Status Code: $statusCode');
              LogService().info('Request: $requestMethod $requestUrl');
              LogService().error('Error Message: ${error.message}');
            } // Log response body/data for debugging GraphQL errors
            if (error.response?.data != null) {
              LogService().debug('Response Data: ${error.response!.data}');
            }

            // Log request data if available (for debugging what was sent)
            if (error.requestOptions.data != null) {
              LogService().debug('Request Data: ${error.requestOptions.data}');
            }

            handler.next(error);
          }
        },
      ),
    );
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '$baseUrl/_next/data',
      headers: {
        'Accept': '*/*',
        'Accept-Language': 'en-US,en;q=0.5',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<void> init() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage('$appDocPath/.cookies/'),
    );
    _dio.interceptors.add(CookieManager(jar));
  }

  // #region Posts
  Map<String, dynamic> _getSortVariables(
    String sortType, {
    String? type,
    String? by,
    String? when,
    DateTime? from,
    DateTime? to,
  }) {
    switch (sortType.toUpperCase()) {
      case 'NEW':
        return {'sort': 'new'};
      case 'TOP':
        final vars = {
          'sort': 'top',
          'type': type ?? 'posts',
          'when': when ?? 'day',
        };
        // Add custom date range if provided
        if (when == 'custom' && from != null && to != null) {
          vars['from'] = from.toIso8601String();
          vars['to'] = to.toIso8601String();
        }
        return vars;
      case 'LIT':
      default:
        return {};
    }
  }

  Future<List<Post>> fetchInitialPosts(
    String subName, {
    String sort = 'LIT',
    String? type,
    String? by,
    String? when,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      // Special handling for 'home' - it doesn't filter by sub in the same way
      if (subName == 'home') {
        return await _fetchHomeTimeline(
          sort: sort,
          type: type,
          by: by,
          when: when,
          from: from,
          to: to,
        );
      } else if (subName == 'notifications') {
        return await _fetchNotifications();
      }

      final sortVars = _getSortVariables(sort, type: type, by: by, when: when, from: from, to: to);
      final body = jsonDecode(
        jsonEncode(
          GqlBody(
            operationName: 'SubItems',
            variables: {
              'includeComments': false,
              'sub': subName,
              ...sortVars,
            },
            query:
                '''\n            fragment SubFields on Sub {\n              name\n              postTypes\n              allowFreebies\n              rankingType\n              billingType\n              billingCost\n              billingAutoRenew\n              billedLastAt\n              billPaidUntil\n              baseCost\n              userId\n              desc\n              status\n              meMuteSub\n              meSubscription\n              nsfw\n              __typename\n            }\n\n            fragment SubFullFields on Sub {\n              ...SubFields\n              user {\n                name\n                id\n                optional {\n                  streak\n                  __typename\n                }\n                __typename\n              }\n              __typename\n            }\n\n            fragment ItemFields on Item {\n              id\n              parentId\n              createdAt\n              deletedAt\n              title\n              url\n              user {\n                id\n                name\n                optional {\n                  streak\n                  __typename\n                }\n                meMute\n                __typename\n              }\n              sub {\n                name\n                userId\n                meMuteSub\n                meSubscription\n                nsfw\n                __typename\n              }\n              otsHash\n              position\n              sats\n              boost\n              bounty\n              bountyPaidTo\n              noteId\n              path\n              upvotes\n              meSats\n              meDontLikeSats\n              meBookmark\n              meSubscription\n              meForward\n              freebie\n              bio\n              ncomments\n              commentSats\n              lastCommentAt\n              isJob\n              company\n              location\n              remote\n              subName\n              pollCost\n              pollExpiresAt\n              status\n              uploadId\n              mine\n              imgproxyUrls\n              rel\n              __typename\n            }\n\n            fragment CommentItemExtFields on Item {\n              text\n              root {\n                id\n                title\n                bounty\n                bountyPaidTo\n                subName\n                sub {\n                  name\n                  userId\n                  meMuteSub\n                  __typename\n                }\n                user {\n                  name\n                  optional {\n                    streak\n                    __typename\n                  }\n                  id\n                  __typename\n                }\n                __typename\n              }\n              __typename\n            }\n\n            query SubItems(\$sub: String, \$sort: String, \$cursor: String, \$type: String, \$name: String, \$when: String, \$from: String, \$to: String, \$by: String, \$limit: Limit, \$includeComments: Boolean = false) {\n              sub(name: \$sub) {\n                ...SubFullFields\n                __typename\n              }\n              items(\n                sub: \$sub\n                sort: \$sort\n                cursor: \$cursor\n                type: \$type\n                name: \$name\n                when: \$when\n                from: \$from\n                to: \$to\n                by: \$by\n                limit: \$limit\n              ) {\n                cursor\n                items {\n                  ...ItemFields\n                  ...CommentItemExtFields @include(if: \$includeComments)\n                  position\n                  __typename\n                }\n                pins {\n                  ...ItemFields\n                  ...CommentItemExtFields @include(if: \$includeComments)\n                  position\n                  __typename\n                }\n                __typename\n              }\n            }\n          ''',
          ),
        ),
      );

      if (kDebugMode) {
        LogService().info('[API] POST $baseUrl/api/graphql');
        LogService().debug('[API] Request body: ${jsonEncode(body)}');
      }

      final response = await _dio.post(
        '$baseUrl/api/graphql',
        data: body,
      );

      if (kDebugMode) {
        LogService().info('[API] Response status: ${response.statusCode}');
        LogService().debug('[API] Response data: ${jsonEncode(response.data)}');
      }

      if (response.statusCode == 200) {
        // Check for GraphQL errors
        final errors = response.data?['errors'];
        if (errors != null && errors is List && errors.isNotEmpty) {
          final errorMsg = errors[0]?['message'] ?? 'Unknown GraphQL error';
          if (kDebugMode) {
            LogService().error('[API] GraphQL Error: $errorMsg');
          }
          throw Exception('GraphQL Error: $errorMsg');
        }

        return await _parsePostsForSub(response.data, subName);
      } else {
        throw Exception('Error fetching posts: ${response.statusCode}');
      }
    } catch (e, st) {
      LogService().error('[API] Error: $e', e, st);
      Utils.showException(e.toString(), st);

      rethrow;
    }
  }

  Future<List<Post>> _parsePostsForSub(
    dynamic responseData,
    String subName,
  ) async {
    if (kDebugMode) {
      LogService().debug('[API] Parsing response for sub: $subName');
      LogService().debug('[API] Response structure: ${responseData.runtimeType}');
    }

    // Handle GraphQL response structure
    final data = responseData['data'];
    if (data == null) {
      if (kDebugMode) {
        LogService().error('[API] ERROR: Missing data field. Full response: ${jsonEncode(responseData)}');
      }
      throw Exception('Invalid response: missing data field');
    }

    final itemsData = data['items'];
    if (itemsData == null) {
      if (kDebugMode) {
        LogService().error('[API] ERROR: Missing items field. Data keys: ${data.keys}');
      }
      throw Exception('Invalid response: missing items field');
    }

    if (kDebugMode) {
      LogService().debug('[API] Items data keys: ${itemsData.keys}');
      LogService().debug('[API] Items data: ${jsonEncode(itemsData)}');
    }

    final List items = itemsData['items'] ?? [];

    if (kDebugMode) {
      LogService().info('[API] Extracted ${items.length} items for sub: $subName');
    }

    // Handle pins for home sub
    if (subName == 'home') {
      final List? pins = itemsData['pins'];
      if (pins != null && pins.isNotEmpty) {
        for (final pin in pins) {
          final position = pin['position'] as int?;
          if (position != null && position < items.length) {
            items.insert(position, pin);
          }
        }
      }
    }

    // Save cursor for pagination
    final cursor = itemsData['cursor'];
    if (cursor != null) {
      await SharedPrefsManager.set(
        '$subName-cursor',
        cursor,
      );
    }

    return items.map((item) {
      return Post.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  Future<List<Post>> _fetchHomeTimeline({
    String sort = 'LIT',
    String? type,
    String? by,
    String? when,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final sortVars = _getSortVariables(sort, type: type, by: by, when: when, from: from, to: to);
      final body = jsonDecode(
        jsonEncode(
          GqlBody(
            operationName: 'TopItems',
            variables: {
              ...sortVars,
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
                __typename
              }
              
              query TopItems(\$sort: String, \$cursor: String, \$type: String, \$limit: Limit) {
                items(
                  sort: \$sort
                  cursor: \$cursor
                  type: \$type
                  limit: \$limit
                ) {
                  cursor
                  items {
                    ...ItemFields
                    __typename
                  }
                  pins {
                    ...ItemFields
                    position
                    __typename
                  }
                  __typename
                }
              }
            ''',
          ),
        ),
      );

      if (kDebugMode) {
        LogService().info('[API] POST $baseUrl/api/graphql (home timeline)');
        LogService().debug('[API] Request body: ${jsonEncode(body)}');
      }

      final response = await _dio.post(
        '$baseUrl/api/graphql',
        data: body,
      );

      if (kDebugMode) {
        LogService().info('[API] Response status: ${response.statusCode}');
        LogService().debug('[API] Response data: ${jsonEncode(response.data)}');
      }

      if (response.statusCode == 200) {
        // Check for GraphQL errors
        final errors = response.data?['errors'];
        if (errors != null && errors is List && errors.isNotEmpty) {
          final errorMsg = errors[0]?['message'] ?? 'Unknown GraphQL error';
          if (kDebugMode) {
            LogService().error('[API] GraphQL Error: $errorMsg');
          }
          throw Exception('GraphQL Error: $errorMsg');
        }

        return await _parsePostsForSub(response.data, 'home');
      } else {
        throw Exception('Error fetching home timeline: ${response.statusCode}');
      }
    } catch (e, st) {
      LogService().error('[API] Error fetching home timeline', e, st);
      Utils.showException(e.toString(), st);

      rethrow;
    }
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

  Future<List<Post>> fetchMorePostsBySub(
    String subName, {
    String sort = 'LIT',
    String? type,
    String? by,
    String? when,
    DateTime? from,
    DateTime? to,
  }) async {
    final cursor = await SharedPrefsManager.get('$subName-cursor');

    if (cursor == null) {
      throw Exception('Error fetching more');
    }

    if (subName == 'notifications') {
      return await _fetchNotifications(cursor: cursor);
    }

    try {
      final sortVars = _getSortVariables(sort, type: type, by: by, when: when, from: from, to: to);
      final body = jsonDecode(
        jsonEncode(
          GqlBody(
            operationName: 'SubItems',
            variables: {
              'sub': subName == 'home' ? null : subName,
              'cursor': cursor,
              ...sortVars,
            },
            query: '''
              query SubItems(\$sub: String, \$sort: String, \$cursor: String, \$type: String, \$name: String, \$when: String, \$from: String, \$to: String, \$by: String, \$limit: Limit) {
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
                    id
                    title
                    url
                    user { id name }
                    sub { name }
                    sats
                    ncomments
                    __typename
                  }
                  __typename
                }
              }
            ''',
          ),
        ),
      );

      if (kDebugMode) {
        LogService().info('[API] POST $baseUrl/api/graphql (pagination)');
        LogService().debug('[API] Request body: ${jsonEncode(body)}');
      }

      final response = await _dio.post(
        '$baseUrl/api/graphql',
        data: body,
      );

      if (kDebugMode) {
        LogService().info('[API] Response status: ${response.statusCode}');
        LogService().debug('[API] Response data: ${jsonEncode(response.data)}');
      }

      if (response.statusCode == 200) {
        return await _parsePostsForSub(response.data, subName);
      }
    } catch (e, st) {
      LogService().error('[API] Error: $e', e, st);

      final msg = ((e is DioException) ? e.response?.data.toString() : e.toString()) ?? '';
      Utils.showException(msg, st);

      rethrow;
    }

    throw Exception('Error fetching more posts');
  }

  Future<Post?> fetchPostDetails(String id) async {
    String? currCommit = await _getCurrBuildId();

    final response = await _dio.get('/$currCommit/items/$id.json');
    // print(response);
    if (response.statusCode != 200) {
      if (response.statusCode == 404) {
        await _fetchAndSaveCurrBuildId();

        currCommit = await _getCurrBuildId();

        final retryResponse = await _dio.get('/$currCommit/items/$id.json');

        if (retryResponse.statusCode != 200) {
          throw Exception('Error fetching post details');
        }
      } else {
        throw Exception('Error parsing build id');
      }
    }

    final props = response.data['pageProps'];

    final data = (props['ssrData'] ?? props['data'])['item'];

    Post? post;

    try {
      post = Post.fromJson(data);
    } catch (e, st) {
      LogService().error('Error parsing post details', e, st);

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
      Utils.showError('ERRN01 Error fetching profile', response.data);

      return null;
    }

    // FIX: sometimes the response.data?['data']?['me'] is null. Why?
    final me = response.data?['data']?['me'];

    if (me == null) {
      Utils.showError('ERRN02 Error fetching profile', response.data);

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
    } else if (response.statusCode == 404) {
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
        Utils.showError('Error validating token: No redirect location', callbackResponse.headers);
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
        Utils.showError('Error validating token: Empty session data', sessionResponse.data);
        return null;
      }

      // Save the session
      await SharedPrefsManager.set(
        'session',
        jsonEncode(sessionResponse.data),
      );

      return Session.fromJson(sessionResponse.data);
    } catch (e) {
      Utils.showError('Login failed: ${e.toString()}', e);
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
      Utils.showError('Failed with status: ${response.statusCode}', response.data);
      return false;
    }

    return true;
  }
  // #endregion Auth

  // #region Notifications
  Future<bool> hasNewNotes() async {
    LogService().debug('fetching hasNewNotes');

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

      LogService().debug('hasNewNotes: $ret');

      return ret == true;
    }

    LogService().debug('hasNewNotes: false, statusCode: ${response.statusCode}');

    return false;
  }

  Future<List<Post>> _fetchNotifications({String? cursor}) async {
    String? buildId = await _getCurrBuildId();
    if (buildId == null) {
      await _fetchAndSaveCurrBuildId();
      buildId = await _getCurrBuildId();
    }

    final url = '/$buildId/notifications.json${cursor != null ? '?cursor=$cursor' : ''}';

    if (kDebugMode) {
      LogService().info('[API] GET $url');
    }

    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      return await _parseNotifications(response.data);
    } else if (response.statusCode == 404) {
      await _fetchAndSaveCurrBuildId();
      buildId = await _getCurrBuildId();
      final retryUrl = '/$buildId/notifications.json${cursor != null ? '?cursor=$cursor' : ''}';
      final retryResponse = await _dio.get(retryUrl);

      if (retryResponse.statusCode == 200) {
        return await _parseNotifications(retryResponse.data);
      }
    }

    throw Exception('Error fetching notifications: ${response.statusCode}');
  }

  Future<List<Post>> _parseNotifications(dynamic responseData) async {
    final props = responseData['pageProps'];
    final data = (props['ssrData'] ?? props['data'])['notifications'];

    if (data == null) {
      if (kDebugMode) {
        LogService().error('[API] ERROR: Missing notifications field.');
      }
      throw Exception('Invalid response: missing notifications field');
    }

    final List items = data['notifications'] ?? [];
    final cursor = data['cursor']?.toString();

    if (kDebugMode) {
      LogService().debug('[API] Extracted ${items.length} notifications');
    }

    if (cursor != null) {
      await SharedPrefsManager.set('notifications-cursor', cursor);
    }

    return items.map((item) {
      return Post.fromJson(item as Map<String, dynamic>);
    }).toList();
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
        Utils.showError(error, response.data['errors']);

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
        Utils.showError(error, response.data['errors']);

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
        Utils.showError(error, response.data['errors']);
        throw Exception(error);
      }

      return Post.fromJson(response.data);
    }

    throw Exception('Failed to create comment');
  }

  // #endregion Items & Comments

  // #region Subs
  Future<List<Sub>> fetchActiveSubs() async {
    try {
      final requestBody = GqlBody(
        operationName: 'ActiveSubs',
        variables: {},
        query: '''
          query ActiveSubs {
            activeSubs {
              name
              desc
              nsfw
              meMuteSub
            }
          }
        ''',
      );

      if (kDebugMode) {
        LogService().info('[API] POST $baseUrl/api/graphql (fetchActiveSubs)');
        LogService().debug('[API] Request: ${jsonEncode(requestBody.toJson())}');
      }

      final response = await _dio.post(
        '$baseUrl/api/graphql',
        data: jsonEncode(requestBody),
      );

      if (kDebugMode) {
        LogService().info('[API] Response status: ${response.statusCode}');
        LogService().debug('[API] Response data: ${jsonEncode(response.data)}');
      }

      if (response.statusCode != 200) {
        LogService().error('Error fetching active subs: ${response.statusCode}');
        return [];
      }

      final errors = (response.data['errors'] ?? []) as List;
      if (errors.isNotEmpty) {
        LogService().error('GraphQL error: ${errors[0]?['message']}');
        return [];
      }

      final subsData = response.data['data']?['activeSubs'] as List?;
      if (subsData == null) {
        return [];
      }

      return subsData.map((sub) => Sub.fromJson(sub as Map<String, dynamic>)).toList();
    } catch (e, st) {
      LogService().error('Error fetching active subs', e, st);
      return [];
    }
  }

  // #endregion Subs
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
