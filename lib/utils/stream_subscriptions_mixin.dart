import 'dart:async';

/// Reusable subscription bookkeeping without forcing a base class hierarchy.

mixin StreamSubscriptionsMixin {
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  void addSubscription(StreamSubscription<dynamic> subscription) {
    _subscriptions.add(subscription);
  }

  Future<void> cancelSubscriptions() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }
}
