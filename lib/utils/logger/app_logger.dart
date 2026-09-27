import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// App-wide logger with a small leveled API (`d`, `i`, `w`, `e`).
///
/// Logs only in debug builds. Each entry shows a level emoji, time, caller
/// location, the message (prefixed with `[tag]` when given), and any error
/// and stack trace. Output goes through `dart:developer`, so it appears in
/// DevTools and the IDE debug console.
///
/// ```dart
/// AppLogger.i('Settings loaded', tag: 'Settings');
/// AppLogger.e('Save failed', tag: 'Progress', error: e, stackTrace: st);
/// ```
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: _AppLogPrinter(),
    filter: _AppLogFilter(),
    output: _AppLogOutput(),
  );

  /// Development debugging.
  static void d(dynamic message, {String? tag}) =>
      _logger.d(_formatMessage(message, tag));

  /// Notable app events.
  static void i(dynamic message, {String? tag}) =>
      _logger.i(_formatMessage(message, tag));

  /// Recoverable problems.
  static void w(dynamic message, {String? tag}) =>
      _logger.w(_formatMessage(message, tag));

  /// Failures that need attention.
  static void e(
    dynamic message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) => _logger.e(
    _formatMessage(message, tag),
    error: error,
    stackTrace: stackTrace,
  );

  static String _formatMessage(dynamic message, String? tag) =>
      tag == null || tag.isEmpty ? '$message' : '[$tag] $message';
}

class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // Only log in debug mode
    return kDebugMode;
  }
}

/// Custom log printer with better formatting
class _AppLogPrinter extends LogPrinter {
  static final Map<Level, String> _levelEmojis = {
    Level.debug: '🐛',
    Level.info: 'ℹ️',
    Level.warning: '⚠️',
    Level.error: '❌',
  };

  @override
  List<String> log(LogEvent event) {
    final emoji = _levelEmojis[event.level] ?? '';
    final time = _getTime();
    final level = event.level.name.toUpperCase();
    final location = _getCallerLocation();

    final List<String> lines = [];

    // Header line
    lines.add('$emoji [$time] [$level] $location');

    // Message
    final message = event.message;
    lines.add('$message');

    // Error
    if (event.error != null) {
      lines.add('🔴 Error: ${event.error}');
    }

    // Stack trace
    if (event.stackTrace != null) {
      lines.add('📚 Stack Trace:');
      final stackLines = event.stackTrace.toString().split('\n').take(10);
      for (final line in stackLines) {
        if (line.trim().isNotEmpty) {
          lines.add('   $line');
        }
      }
    }

    // Divider
    lines.add('─' * 60);

    return lines;
  }

  String _getTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';
  }

  static final _locationRegex = RegExp(r'\((.*?)\)');

  String _getCallerLocation() {
    final stackTrace = StackTrace.current.toString().split('\n');
    String callerLine = '';

    for (final line in stackTrace) {
      // Skip lines from the logger package and this file
      if (line.contains('package:logger') ||
          line.contains('AppLogger') ||
          line.contains('_AppLogPrinter')) {
        continue;
      }

      // The first line that doesn't match the above is likely our caller
      if (line.trim().isNotEmpty) {
        callerLine = line;
        break;
      }
    }

    if (callerLine.isEmpty) return '';

    // A frame looks like `#4  main (package:app/main.dart:15:3)`; keep the
    // part in parentheses.
    final locationMatch = _locationRegex.firstMatch(callerLine);

    if (locationMatch != null) {
      return locationMatch.group(1) ?? '';
    }

    return '';
  }
}

/// Custom log output
class _AppLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      // ignore: avoid_print
      log(line);
    }
  }
}
