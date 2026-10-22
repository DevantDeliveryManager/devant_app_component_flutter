import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionService {
  InternetConnectionService();

  static Future<bool> Function()? connectionCheckOverride;

  final InternetConnection internetConnection = InternetConnection();

  Future<bool> hasConnection() async =>
      await (connectionCheckOverride?.call() ??
          internetConnection.hasInternetAccess);
}
