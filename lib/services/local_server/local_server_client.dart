/// Endpoint constants and abstraction for the Local Wi-Fi Server architecture.
/// Designed so the local server can be swapped cleanly with a central backend later.
abstract final class LocalServerEndpoints {
  static const String health = '/local/health';
  static const String auth = '/local/auth';
  static const String users = '/local/users';
  static const String wallets = '/local/wallets';
  static const String transactions = '/local/transactions';
  static const String transfers = '/local/transfers';
  static const String deposits = '/local/deposits';
  static const String withdrawals = '/local/withdrawals';
  static const String qr = '/local/qr';
  static const String sync = '/local/sync';
}

abstract interface class LocalServerClient {
  Future<bool> checkHealth();

  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
  });

  Future<Map<String, dynamic>> get(String endpoint);
}
