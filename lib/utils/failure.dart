import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'error_handler.dart';

/// Domain-level failure hierarchy.

sealed class Failure extends Equatable {
  const Failure(
    this.message, {
    this.error,
    this.statusCode,
  });

  final String message;

  /// Original exception for debugging/logging.
  final Object? error;

  /// HTTP status code when this failure originated from an API response.
  final int? statusCode;

  /// Maps any raw exception into a domain-level [Failure].
  factory Failure.fromException(
    Object error, [
    StackTrace? stackTrace,
  ]) {
    if (error is Failure) {
      return error;
    }

    if (error is DioException) {
      return _fromDioException(error);
    }

    if (error is SocketException) {
      return NetworkFailure(
        AppErrorHandler.format(error),
        error: error,
      );
    }

    return UnknownFailure(
      AppErrorHandler.format(error),
      error: error,
    );
  }

  static Failure _fromDioException(DioException error) {
    // The backend repeats the status in its error body; prefer that one.
    final body = error.response?.data;
    final bodyStatus = body is Map ? body['statusCode'] : null;
    final statusCode =
        bodyStatus is int ? bodyStatus : error.response?.statusCode;

    final message =
        _messageFromResponse(error) ?? AppErrorHandler.format(error);

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout =>
        TimeoutFailure(
          message,
          error: error,
          statusCode: statusCode,
        ),
      DioExceptionType.connectionError => NetworkFailure(
          message,
          error: error,
          statusCode: statusCode,
        ),
      DioExceptionType.cancel => UnknownFailure(
          message,
          error: error,
          statusCode: statusCode,
        ),
      DioExceptionType.badCertificate => NetworkFailure(
          message,
          error: error,
          statusCode: statusCode,
        ),
      DioExceptionType.badResponse => _fromStatusCode(
          statusCode,
          message,
          error,
        ),
      DioExceptionType.unknown => _isNetworkError(error)
          ? NetworkFailure(
              message,
              error: error,
              statusCode: statusCode,
            )
          : UnknownFailure(
              message,
              error: error,
              statusCode: statusCode,
            ),
    };
  }

  static Failure _fromStatusCode(
    int? statusCode,
    String message,
    DioException error,
  ) {
    return switch (statusCode) {
      400 || 422 => ValidationFailure(
          message,
          error: error,
          statusCode: statusCode,
        ),
      401 || 403 => UnauthorizedFailure(
          message,
          error: error,
          statusCode: statusCode,
        ),
      404 => NotFoundFailure(
          message,
          error: error,
          statusCode: statusCode,
        ),
      _ => ServerFailure(
          message,
          error: error,
          statusCode: statusCode,
        ),
    };
  }

  static String? _messageFromResponse(DioException error) {
    final data = error.response?.data;

    if (data is! Map) {
      return null;
    }

    final candidates = [
      data['message'],
      data['error'],
      data['detail'],
      data['error_message'],
    ];

    for (final value in candidates) {
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      // A 400 lists every invalid field: one per line.
      if (value is List) {
        final lines = [
          for (final item in value)
            if (item?.toString().trim() case final line? when line.isNotEmpty)
              line,
        ];
        if (lines.isNotEmpty) return lines.join('\n');
      }
    }

    return null;
  }

  static bool _isNetworkError(DioException error) {
    return error.error is SocketException ||
        (error.message?.contains('SocketException') ?? false);
  }

  @override
  List<Object?> get props => [
        message,
        error,
        statusCode,
      ];

  @override
  String toString() => message;
}

final class ServerFailure extends Failure {
  const ServerFailure(
    super.message, {
    super.error,
    super.statusCode,
  });
}

final class CacheFailure extends Failure {
  const CacheFailure(
    super.message, {
    super.error,
    super.statusCode,
  });
}

final class NetworkFailure extends Failure {
  const NetworkFailure(
    super.message, {
    super.error,
    super.statusCode,
  });
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure(
    super.message, {
    super.error,
    super.statusCode,
  });
}

/// 401 / 403.
///
/// Authentication/session handling can still be performed by
/// [AuthGuardInterceptor] at the network boundary.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(
    super.message, {
    super.error,
    super.statusCode,
  });
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(
    super.message, {
    super.error,
    super.statusCode,
  });
}

/// 400 / 422 — invalid request/server-side validation errors.
final class ValidationFailure extends Failure {
  const ValidationFailure(
    super.message, {
    super.error,
    super.statusCode,
  });
}

final class UnknownFailure extends Failure {
  const UnknownFailure(
    super.message, {
    super.error,
    super.statusCode,
  });
}

final class CancelledFailure extends Failure {
  const CancelledFailure(
    super.message, {
    super.error,
    super.statusCode,
  });
}
