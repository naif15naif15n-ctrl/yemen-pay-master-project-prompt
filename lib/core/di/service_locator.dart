import '../../data/demo/demo_auth_service.dart';
import '../../data/demo/demo_connection_monitor_service.dart';
import '../../data/demo/demo_local_server_client.dart';
import '../../data/demo/demo_sync_service.dart';
import '../../data/demo/demo_transaction_service.dart';
import '../../data/local/in_memory_local_storage_service.dart';
import '../../services/auth/auth_service.dart';
import '../../services/connectivity/connection_monitor_service.dart';
import '../../services/local_server/local_server_client.dart';
import '../../services/storage/local_storage_service.dart';
import '../../services/sync/sync_service.dart';
import '../../services/transactions/transaction_service.dart';

/// Lightweight dependency container wiring abstractions to Demo implementations
/// for Phase 1. Future phases swap individual implementations here cleanly.
class ServiceLocator {
  ServiceLocator({
    LocalStorageService? localStorageService,
    AuthService? authService,
    TransactionService? transactionService,
    SyncService? syncService,
    ConnectionMonitorService? connectionMonitorService,
    LocalServerClient? localServerClient,
  }) {
    this.localStorageService =
        localStorageService ?? InMemoryLocalStorageService();
    this.authService = authService ?? DemoAuthService();
    this.transactionService = transactionService ?? DemoTransactionService();
    this.syncService = syncService ?? DemoSyncService(this.localStorageService);
    this.connectionMonitorService =
        connectionMonitorService ?? DemoConnectionMonitorService();
    this.localServerClient = localServerClient ?? DemoLocalServerClient();
  }

  late final LocalStorageService localStorageService;
  late final AuthService authService;
  late final TransactionService transactionService;
  late final SyncService syncService;
  late final ConnectionMonitorService connectionMonitorService;
  late final LocalServerClient localServerClient;
}
