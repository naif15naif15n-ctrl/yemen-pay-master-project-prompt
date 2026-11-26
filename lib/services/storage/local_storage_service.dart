import '../../core/enums/app_enums.dart';
import '../../domain/models/models.dart';

/// Persistent local storage abstraction.
/// Designed to swap in SQLite/Hive/FlutterSecureStorage in later phases
/// while keeping persistence details decoupled from domain and UI layers.
abstract interface class LocalStorageService {
  Future<void> initialize();

  // App Preferences
  Future<bool> getOnboardingCompleted();
  Future<void> setOnboardingCompleted(bool completed);

  Future<String?> getThemeMode();
  Future<void> setThemeMode(String mode);

  Future<String?> getLocaleCode();
  Future<void> setLocaleCode(String code);

  Future<bool> getDemoModeEnabled();
  Future<void> setDemoModeEnabled(bool enabled);

  // User Session & Wallet Snapshot
  Future<Session?> getSession();
  Future<void> saveSession(Session session);
  Future<void> clearSession();

  Future<Wallet?> getWalletSnapshot(String userId);
  Future<void> saveWalletSnapshot(Wallet wallet);

  // Transactions & Persistent Sync Queue
  Future<List<Transaction>> getCachedTransactions(String walletId);
  Future<void> saveTransactions(List<Transaction> transactions);

  Future<List<SyncQueueItem>> getSyncQueue();
  Future<void> upsertSyncQueueItem(SyncQueueItem item);
  Future<void> removeSyncQueueItem(String transactionId);

  // Connection State Cache
  Future<ConnectionStatus> getLastConnectionState();
  Future<void> saveLastConnectionState(ConnectionStatus status);

  // Generic Cache
  Future<void> writeCache(String key, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> readCache(String key);
}
