import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/enums/app_enums.dart';
import '../services/connectivity/connection_monitor_service.dart';
import '../services/storage/local_storage_service.dart';

/// Exposes the 5 connection states required by Yemen Pay's Offline-First architecture.
class ConnectionController extends ChangeNotifier {
  ConnectionController(this._monitor, this._storage) {
    _status = _monitor.currentStatus;
    _subscription = _monitor.statusStream.listen((ConnectionStatus next) {
      _status = next;
      _storage.saveLastConnectionState(next);
      notifyListeners();
    });
  }

  final ConnectionMonitorService _monitor;
  final LocalStorageService _storage;
  late ConnectionStatus _status;
  StreamSubscription<ConnectionStatus>? _subscription;

  ConnectionStatus get status => _status;

  bool get canRunOfflineSupportedOps =>
      _status == ConnectionStatus.internetAvailable ||
      _status == ConnectionStatus.localServerAvailable;

  Future<void> refresh() async {
    _status = await _monitor.checkConnectivity();
    notifyListeners();
  }

  Future<void> simulateStatus(ConnectionStatus next) async {
    await _monitor.setSimulatedStatus(next);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
