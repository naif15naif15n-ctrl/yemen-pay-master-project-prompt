import 'dart:async';
import '../../core/enums/app_enums.dart';
import '../../services/connectivity/connection_monitor_service.dart';

/// Simulated connectivity monitor for Phase 1.
/// Allows evaluators to toggle between Internet, Local Server (TP-Link LAN), and Offline states.
class DemoConnectionMonitorService implements ConnectionMonitorService {
  DemoConnectionMonitorService({
    ConnectionStatus initialStatus = ConnectionStatus.internetAvailable,
  }) : _currentStatus = initialStatus;

  ConnectionStatus _currentStatus;
  final StreamController<ConnectionStatus> _controller =
      StreamController<ConnectionStatus>.broadcast();

  @override
  ConnectionStatus get currentStatus => _currentStatus;

  @override
  Stream<ConnectionStatus> get statusStream => _controller.stream;

  @override
  Future<ConnectionStatus> checkConnectivity() async => _currentStatus;

  @override
  Future<void> setSimulatedStatus(ConnectionStatus status) async {
    _currentStatus = status;
    if (!_controller.isClosed) {
      _controller.add(status);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
