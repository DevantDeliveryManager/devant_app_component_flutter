/// Type of snackbar to show — drives colour and icon selection.
library;

enum SnackBarType {
  /// Neutral informational message.
  info,

  /// Operation succeeded.
  success,

  /// Non-blocking warning the user should notice.
  warning,

  /// Something went wrong.
  error,
}
