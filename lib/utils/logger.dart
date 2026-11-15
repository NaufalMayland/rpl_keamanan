import 'package:flutter/foundation.dart';

/// Level log, dari yang paling detail sampai yang paling serius.
enum LogLevel { debug, info, warning, error }

/// Logger terstruktur untuk aplikasi.
///
/// - Log hanya ditampilkan di mode debug ([kDebugMode]).
/// - Data sensitif (password, token, API key, dan sejenisnya)
///   otomatis disamarkan menjadi `[REDACTED]`.
///
/// Contoh:
/// ```dart
/// Logger.info('Login berhasil', tag: 'Auth');
/// Logger.error('Gagal memuat data', tag: 'ApiService', error: e);
/// ```
class Logger {
  Logger._();

  /// Pola `kata_kunci: nilai` atau `kata_kunci=nilai` untuk data sensitif.
  static final RegExp _sensitivePattern = RegExp(
    r'(password|passwd|token|secret|api[_-]?key|authorization|pin)'
    r'(\s*[:=]\s*)((?:bearer\s+)?\S+)',
    caseSensitive: false,
  );

  /// Menyamarkan nilai data sensitif pada [message].
  static String _redact(String message) {
    return message.replaceAllMapped(
      _sensitivePattern,
      (m) => '${m[1]}${m[2]}[REDACTED]',
    );
  }

  static void _log(
    LogLevel level,
    String message, {
    String tag = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Tidak ada output sama sekali di mode profile/release.
    if (!kDebugMode) return;

    final time = DateTime.now().toIso8601String();
    final label = level.name.toUpperCase();
    final buffer = StringBuffer('[$time] [$label] [$tag] ${_redact(message)}');
    if (error != null) {
      buffer.write(' | error: ${_redact(error.toString())}');
    }
    debugPrint(buffer.toString());
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }

  /// Informasi detail untuk proses debugging.
  static void debug(String message, {String tag = 'App'}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  /// Informasi umum tentang jalannya aplikasi.
  static void info(String message, {String tag = 'App'}) {
    _log(LogLevel.info, message, tag: tag);
  }

  /// Kondisi tidak normal yang belum menyebabkan kegagalan.
  static void warning(String message, {String tag = 'App'}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  /// Kegagalan atau exception.
  static void error(
    String message, {
    String tag = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
