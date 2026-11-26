import '../../services/local_server/local_server_client.dart';

/// Phase 1 stub client for the Local Wi-Fi Server architecture.
class DemoLocalServerClient implements LocalServerClient {
  @override
  Future<bool> checkHealth() async => true;

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    return <String, dynamic>{
      'simulated': true,
      'endpoint': endpoint,
      'status': 'ok',
    };
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    return <String, dynamic>{
      'simulated': true,
      'endpoint': endpoint,
      'received': body,
      'status': 'accepted',
    };
  }
}
