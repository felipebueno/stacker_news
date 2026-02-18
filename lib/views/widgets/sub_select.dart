import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/sub.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/views/widgets/markdown_item.dart';

typedef SubSelectCallback = void Function(String? selectedSub);

const _homeSub = Sub(name: 'home');

class SubSelect extends StatefulWidget {
  final String? initialSub;
  final SubSelectCallback? onChanged;
  final SNApiClient apiClient;
  final List<String> prependSubs;
  final List<String> appendSubs;
  final bool Function(Sub)? filterSubs;

  const SubSelect({
    super.key,
    this.initialSub,
    this.onChanged,
    required this.apiClient,
    this.prependSubs = const [],
    this.appendSubs = const [],
    this.filterSubs,
  });

  @override
  State<SubSelect> createState() => _SubSelectState();
}

class _SubSelectState extends State<SubSelect> {
  late List<Sub> _allSubs = [];
  late List<Sub> _filteredSubs = [];
  final TextEditingController _filterController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubs();
    _filterController.addListener(_filterSubs);
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  Future<void> _loadSubs() async {
    setState(() => _isLoading = true);
    try {
      final subs = await widget.apiClient.fetchActiveSubs();

      // Apply filter function if provided
      List<Sub> filtered = subs;
      if (widget.filterSubs != null) {
        filtered = subs.where(widget.filterSubs!).toList();
      }

      // Build the final list with prepend, home (guaranteed), filtered, and append
      final allSubs = <Sub>[];

      // Add prepended subs
      for (final subName in widget.prependSubs) {
        if (subName == 'home') {
          allSubs.add(_homeSub);
        } else {
          final existing = filtered.firstWhere((s) => s.name == subName, orElse: () => Sub(name: subName));
          allSubs.add(existing);
        }
      }

      // Add 'home' if not already included
      if (!allSubs.any((s) => s.name == 'home')) {
        allSubs.add(_homeSub);
      }

      // Add filtered subs that aren't already in the list
      for (final sub in filtered) {
        if (!allSubs.any((s) => s.name == sub.name)) {
          allSubs.add(sub);
        }
      }

      // Add appended subs
      for (final subName in widget.appendSubs) {
        if (!allSubs.any((s) => s.name == subName)) {
          final existing = filtered.firstWhere((s) => s.name == subName, orElse: () => Sub(name: subName));
          allSubs.add(existing);
        }
      }

      setState(() {
        _allSubs = allSubs;
        _filteredSubs = allSubs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading subs: $e');

      // Even if API fails, ensure 'home' is always available
      final allSubs = <Sub>[];
      for (final subName in widget.prependSubs) {
        allSubs.add(subName == 'home' ? _homeSub : Sub(name: subName));
      }
      if (!allSubs.any((s) => s.name == 'home')) {
        allSubs.add(_homeSub);
      }
      for (final subName in widget.appendSubs) {
        if (!allSubs.any((s) => s.name == subName)) {
          allSubs.add(Sub(name: subName));
        }
      }

      setState(() {
        _allSubs = allSubs;
        _filteredSubs = allSubs;
        _isLoading = false;
      });
    }
  }

  void _filterSubs() {
    final query = _filterController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSubs = _allSubs;
      } else {
        _filteredSubs = _allSubs.where((sub) => sub.name.toLowerCase().contains(query)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (BuildContext context) {
            return SubSelectionSheet(
              subs: _filteredSubs,
              allSubs: _allSubs,
              filterController: _filterController,
              isLoading: _isLoading,
              onSubSelected: (selected) {
                Navigator.pop(context);
                widget.onChanged?.call(selected);
              },
              onFilterChanged: _filterSubs,
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.initialSub ?? 'Select territory',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Icon(Icons.expand_more),
          ],
        ),
      ),
    );
  }
}

class SubSelectionSheet extends StatefulWidget {
  final List<Sub> subs;
  final List<Sub> allSubs;
  final TextEditingController filterController;
  final bool isLoading;
  final Function(String?) onSubSelected;
  final VoidCallback onFilterChanged;

  const SubSelectionSheet({
    super.key,
    required this.subs,
    required this.allSubs,
    required this.filterController,
    required this.isLoading,
    required this.onSubSelected,
    required this.onFilterChanged,
  });

  @override
  State<SubSelectionSheet> createState() => _SubSelectionSheetState();
}

class _SubSelectionSheetState extends State<SubSelectionSheet> {
  final Set<String> _expandedSubs = {};

  @override
  void initState() {
    super.initState();
    widget.filterController.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    widget.filterController.removeListener(_onFilterChanged);
    super.dispose();
  }

  void _onFilterChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildSubTile(Sub sub) {
    final isExpanded = _expandedSubs.contains(sub.name);

    return ListTile(
      dense: false,
      title: Text(sub.name),
      subtitle: (sub.desc != null && isExpanded) ? MarkdownItem(sub.desc) : null,
      trailing: sub.desc != null
          ? IconButton(
              icon: Icon(isExpanded ? Icons.info : Icons.info_outline),
              onPressed: () {
                setState(() {
                  if (isExpanded) {
                    _expandedSubs.remove(sub.name);
                  } else {
                    _expandedSubs.add(sub.name);
                  }
                });
              },
            )
          : null,
      onTap: () => widget.onSubSelected(sub.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.filterController.text.toLowerCase();
    final filteredSubs = query.isEmpty
        ? widget.allSubs
        : widget.allSubs.where((sub) => sub.name.toLowerCase().contains(query)).toList();

    final joinedSubs = filteredSubs.where((s) => s.meMuteSub != true).toList();
    final mutedSubs = filteredSubs.where((s) => s.meMuteSub == true).toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Territory',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Filter field
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: widget.filterController,
              decoration: InputDecoration(
                hintText: 'Filter territories',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: widget.filterController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          widget.filterController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          // List of subs
          Expanded(
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredSubs.isEmpty
                ? Center(
                    child: Text(
                      'No territories found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView(
                    children: [
                      if (joinedSubs.isNotEmpty) ...[
                        ...joinedSubs.map((sub) => _buildSubTile(sub)),
                      ],
                      if (mutedSubs.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            'Muted',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        ...mutedSubs.map((sub) => _buildSubTile(sub)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
