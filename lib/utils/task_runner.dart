import 'package:devant_components/enums/snack_bar_type.dart';
import 'package:devant_components/helpers/show_toast.dart';
import 'package:devant_components/utils/typedefs.dart';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';



import 'package:devant_components/utils/failure.dart';
import 'package:devant_components/utils/logger.dart';

import '../services/internet_connection_service.dart';


/// Service / backend middleware: wraps async work with structured logging and

FutureEither<T> runTask<T>(
  Future<T> Function() action, {
  required String operation,
  String category = LogCategory.app,
  Map<String, Object?> context = const {},
  bool requiresNetwork = false,
  BuildContext? rootContext,
}) async {
  final startedAt = DateTime.now();
  AppLogger.info('$operation started', category: category, context: context);

  if (requiresNetwork) {
    final hasNetwork = await InternetConnectionService().hasConnection();

    if (!hasNetwork) {
      AppLogger.warning(
        '$operation skipped: network unavailable',
        category: category,
        context: context,
      );
      final message = "No internet connection";
      
      // ignore: use_build_context_synchronously
      showGlobalToast(message: message, type: SnackBarType.warning, rootContext: rootContext,);
      return left(NetworkFailure(message));
    }
  }

  try {
    final result = await action();
    AppLogger.success(
      '$operation succeeded',
      category: category,
      context: {
        ...context,
        'durationMs': DateTime.now().difference(startedAt).inMilliseconds,
      },
    );
    return right(result);
  } catch (error, stackTrace) {
    AppLogger.error(
      '$operation failed',
      error: error,
      stackTrace: stackTrace,
      category: category,
      context: {
        ...context,
        'requiresNetwork': requiresNetwork,
        'durationMs': DateTime.now().difference(startedAt).inMilliseconds,
      },
    );
    return left(Failure.fromException(error, stackTrace));
  }
}

/// Auth-stream middleware: logs signed-in / signed-out transitions once at the edge.
Stream<T?> logAuthStateChanges<T>(
  Stream<T?> source, {
  String Function(T value)? userIdOf,
}) {
  return source.map((value) {
    if (value == null) {
      AppLogger.auth('auth.state changed', context: {'state': 'signed_out'});
      return null;
    }
    AppLogger.auth(
      'auth.state changed',
      context: {
        'state': 'signed_in',
        if (userIdOf != null) 'userId': userIdOf(value),
      },
    );
    return value;
  });
}
