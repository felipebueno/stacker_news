import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/sub.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/maybe_new_post_button.dart';
import 'package:stacker_news/views/widgets/maybe_notifications_button.dart';
import 'package:stacker_news/views/widgets/sn_logo.dart';
import 'package:stacker_news/views/widgets/sub_select.dart';
import 'package:stacker_news/views/widgets/post/post_list.dart';
import 'package:stacker_news/views/widgets/post/post_list_error.dart';
import 'package:stacker_news/data/models/post.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Sub _homeSub = const Sub(name: 'home');
  late Sub _selectedSub = _homeSub;
  late String _sortType = 'LIT';
  late String _topType = 'posts';
  late String _topBy = 'sats';
  late String _topWhen = 'day';
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  final SNApiClient _api = locator<SNApiClient>();

  Future<List<Post>> _fetchPostsForSub() async {
    return await _api.fetchInitialPosts(
      _selectedSub.name,
      sort: _sortType,
      type: _topType,
      by: _topBy,
      when: _topWhen,
      from: _customStartDate,
      to: _customEndDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const SNLogo(),
        actions: const [
          MaybeNotificationsButton(),
        ],
      ),
      mainBody: FutureBuilder<List<Post>>(
        future: _fetchPostsForSub(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final err = snapshot.error.toString();
            return PostListError(err);
          }

          final posts = snapshot.data as List<Post>;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: posts.isEmpty
                ? const Center(child: Text('No posts found'))
                : PostList(
                    posts,
                    sub: _selectedSub,
                    sort: _sortType,
                    type: _topType,
                    by: _topBy,
                    when: _topWhen,
                    from: _customStartDate,
                    to: _customEndDate,
                  ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sort toggle buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                  ButtonSegment<String>(
                    value: 'LIT',
                    label: Text('LIT'),
                  ),
                  ButtonSegment<String>(
                    value: 'NEW',
                    label: Text('NEW'),
                  ),
                  ButtonSegment<String>(
                    value: 'TOP',
                    label: Text('TOP'),
                  ),
                ],
                selected: <String>{_sortType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _sortType = newSelection.first;
                  });
                },
              ),
            ),
            // TOP filters (only shown when TOP is selected)
            if (_sortType == 'TOP')
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Type dropdown
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: DropdownButton<String>(
                          value: _topType,
                          isExpanded: true,
                          items: ['posts', 'comments'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _topType = val);
                            }
                          },
                        ),
                      ),
                    ),
                    // By dropdown
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: DropdownButton<String>(
                          value: _topBy,
                          isExpanded: true,
                          items: ['sats', 'comments'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _topBy = val);
                            }
                          },
                        ),
                      ),
                    ),
                    // When dropdown
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: DropdownButton<String>(
                          value: _topWhen,
                          isExpanded: true,
                          items: [
                            'day',
                            'week',
                            'month',
                            'year',
                            'forever',
                            'custom',
                          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _topWhen = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Custom date range picker (only shown when custom is selected)
            if (_sortType == 'TOP' && _topWhen == 'custom')
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Start date picker
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _customStartDate ?? DateTime.now().subtract(const Duration(days: 1)),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => _customStartDate = picked);
                            }
                          },
                          child: Text(
                            _customStartDate == null
                                ? 'From: ${DateTime.now().subtract(const Duration(days: 1)).toLocal().toString().split(' ')[0]}'
                                : 'From: ${_customStartDate!.toLocal().toString().split(' ')[0]}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    // End date picker
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _customEndDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => _customEndDate = picked);
                            }
                          },
                          child: Text(
                            _customEndDate == null
                                ? 'To: ${DateTime.now().toLocal().toString().split(' ')[0]}'
                                : 'To: ${_customEndDate!.toLocal().toString().split(' ')[0]}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Sub select
            SizedBox(
              height: 48,
              child: SubSelect(
                apiClient: locator<SNApiClient>(),
                initialSub: _selectedSub.name,
                onChanged: (selectedSubName) {
                  setState(() {
                    _selectedSub = Sub(
                      name: selectedSubName ?? 'home',
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
      fab: const MaybeNewPostFab(),
    );
  }
}
