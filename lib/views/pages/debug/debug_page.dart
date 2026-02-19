import 'package:flutter/material.dart';
import 'package:stacker_news/utils/log_service.dart';

class DebugPage extends StatefulWidget {
  static const String id = 'debug';

  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  LogLevel? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => LogService().clear(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: ValueListenableBuilder<List<LogEntry>>(
              valueListenable: LogService().logsNotifier,
              builder: (context, logs, child) {
                final filteredLogs = _selectedLevel == null
                    ? logs
                    : logs.where((l) => l.level == _selectedLevel).toList();

                if (filteredLogs.isEmpty) {
                  return const Center(
                    child: Text('Nenhum log disponível.'),
                  );
                }

                return ListView.separated(
                  itemCount: filteredLogs.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final log = filteredLogs[filteredLogs.length - 1 - index]; // Show latest first
                    return ListTile(
                      leading: _buildLevelIndicator(log.level),
                      title: Text(
                        log.message,
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.timestamp.toString(),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          if (log.error != null)
                            Text(
                              'Error: ${log.error}',
                              style: const TextStyle(fontSize: 12, color: Colors.red),
                            ),
                        ],
                      ),
                      onTap: () => _showLogDetails(context, log),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _selectedLevel == null,
            onSelected: (selected) {
              setState(() {
                _selectedLevel = null;
              });
            },
          ),
          const SizedBox(width: 8),
          ...LogLevel.values.map((level) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(level.name.toUpperCase()),
                selected: _selectedLevel == level,
                selectedColor: _getLevelColor(level).withValues(alpha: 0.3),
                onSelected: (selected) {
                  setState(() {
                    _selectedLevel = selected ? level : null;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return Colors.blue;
      case LogLevel.warning:
        return Colors.orange;
      case LogLevel.error:
        return Colors.red;
      case LogLevel.debug:
        return Colors.grey;
    }
  }

  Widget _buildLevelIndicator(LogLevel level) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _getLevelColor(level),
        shape: BoxShape.circle,
      ),
    );
  }

  void _showLogDetails(BuildContext context, LogEntry log) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(log.level.name.toUpperCase()),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Message: ${log.message}'),
                const SizedBox(height: 8),
                Text('Time: ${log.timestamp}'),
                if (log.error != null) ...[
                  const SizedBox(height: 8),
                  const Text('Error:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(log.error!),
                ],
                if (log.stackTrace != null) ...[
                  const SizedBox(height: 8),
                  const Text('Stack Trace:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(log.stackTrace!),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
