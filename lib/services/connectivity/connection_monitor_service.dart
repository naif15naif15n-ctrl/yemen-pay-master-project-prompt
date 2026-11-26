import '../../core/enums/app_enums.dart';

/// Monitors Internet, local Wi-Fi router connectivity, and Local Server reachability.
abstract interface class ConnectionMonitorService {
  ConnectionStatus get currentStatus;

  Stream<ConnectionStatus> get statusStream;

  Future<ConnectionStatus> checkConnectivity();

  /// Used in Demo / Academic evaluation mode to simulate connectivity transitions.
  Future<void> setSimulatedStatus(ConnectionStatus status);

  void dispose();
}
