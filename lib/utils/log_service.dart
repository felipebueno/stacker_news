import 'package:flutter/foundation.dart';

enum LogLevel { info, warning, error, debug }

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? error;
  final String? stackTrace;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
  });

  @override
  String toString() {
    return '[${timestamp.toIso8601String()}] [${level.name.toUpperCase()}] $message${error != null ? '\nError: $error' : ''}';
  }
}

class LogService {
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;
  LogService._internal();

  final ValueNotifier<List<LogEntry>> logsNotifier = ValueNotifier<List<LogEntry>>([]);
  final int _maxLogs = 500;

  void log(LogLevel level, String message, {Object? error, StackTrace? stackTrace}) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      error: error?.toString(),
      stackTrace: stackTrace?.toString(),
    );

    final currentLogs = List<LogEntry>.from(logsNotifier.value);
    currentLogs.add(entry);

    if (currentLogs.length > _maxLogs) {
      currentLogs.removeAt(0);
    }

    // Update the notifier.
    // We use Future.microtask or addPostFrameCallback to avoid "setState() or markNeedsBuild() called during build"
    Future.microtask(() {
      logsNotifier.value = currentLogs;
    });

    if (kDebugMode) {
      debugPrint(entry.toString());
    }
  }

  void info(String message) => log(LogLevel.info, message);
  void warning(String message) => log(LogLevel.warning, message);
  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  void debug(String message) => log(LogLevel.debug, message);

  void clear() {
    Future.microtask(() {
      logsNotifier.value = [];
    });
  }
}
