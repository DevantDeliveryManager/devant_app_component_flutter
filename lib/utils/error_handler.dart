

import 'package:devant_components/utils/failure.dart';

abstract final class ErrorHandler {
  /// Maps any thrown object into a typed [Failure].
  static Failure handle(Object error, [StackTrace? stackTrace]) {
    return Failure.fromException(error, stackTrace);
  }
}

class AppErrorHandler {
  static String format(Object? error) {
    if (error == null) return 'An unexpected error occurred';
    if (error is String) return error;

    try {
      final dynamic dynamicError = error;
      if (dynamicError.message is String) {
        return dynamicError.message as String;
      }
    } catch (_) {}

    return error.toString();
  }
}
