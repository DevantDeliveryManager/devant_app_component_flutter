  import 'package:devant_components/utils/logger.dart';
import 'package:devant_components/utils/task_runner.dart';
import 'package:local_auth/local_auth.dart';



enum DeviceAuthResult {
  /// Fingerprint, face or device PIN/pattern/password matched.
  authenticated,

  /// The user cancelled or failed the prompt.
  failed,

  /// The prompt could not complete for a transient reason (app backgrounded,
  /// lockout, prompt already showing, ...). Offer to try again.
  retry,

  /// The device has no screen lock or biometrics set up, so there is nothing
  /// to check against.
  unavailable,
}

/// Device-level authentication: biometrics (fingerprint or face, whichever
/// is enrolled) with the device PIN, pattern or password as the fallback.

class DeviceAuthService {
  DeviceAuthService._();
  static final DeviceAuthService instance = DeviceAuthService._();

  final LocalAuthentication _auth = LocalAuthentication();

  /// Shows the system prompt with [reason]. Never throws.
  Future<DeviceAuthResult> authenticate({required String reason}) async {
    final result = await runTask(
      () async {
        if (!await _auth.isDeviceSupported()) {
          return DeviceAuthResult.unavailable;
        }

        try {
          final passed = await _auth.authenticate(
            localizedReason: reason,
            // Falls back to PIN / pattern / password.
            biometricOnly: false,
            persistAcrossBackgrounding: true,
          );
          return passed
              ? DeviceAuthResult.authenticated
              : DeviceAuthResult.failed;
        } on LocalAuthException catch (error) {
          return switch (error.code) {
            LocalAuthExceptionCode.noCredentialsSet ||
            LocalAuthExceptionCode.noBiometricHardware ||
            LocalAuthExceptionCode.noBiometricsEnrolled =>
              DeviceAuthResult.unavailable,
            LocalAuthExceptionCode.userCanceled => DeviceAuthResult.failed,
            _ => DeviceAuthResult.retry,
          };
        }
      },
      operation: 'deviceAuth.authenticate',
      category: LogCategory.auth,
    );

    // An unexpected plugin error is not the user failing the check.
    return result.getOrElse((_) => DeviceAuthResult.retry);
  }
}
