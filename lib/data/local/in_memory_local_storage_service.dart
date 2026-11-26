import '../../core/enums/app_enums.dart';
import '../../domain/models/models.dart';
import '../../services/storage/local_storage_service.dart';

/// In-memory implementation of [LocalStorageService] for Phase 1 & 2 & unit testing.
/// Can be replaced in later phases with SQLite/FlutterSecureStorage without touching any UI.
class InMemoryLocalStorageService implements LocalStorageService {
  bool _onboardingCompleted = false;
  String? _themeMode = 'light';
  String? _localeCode = 'ar';
  bool _demoModeEnabled = true;
  Session? _session;
  String? _authToken;

  final Map<String, User> _users = <String, User>{};
  final Map<String, Wallet> _wallets = <String, Wallet>{};
  final Map<String, List<Transaction>> _transactions =
      <String, List<Transaction>>{};
  final List<SyncQueueItem> _syncQueue = <SyncQueueItem>[];
  ConnectionStatus _lastConnectionState = ConnectionStatus.internetAvailable;
  final Map<String, Map<String, dynamic>> _cache =
      <String, Map<String, dynamic>>{};

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> getOnboardingCompleted() async => _onboardingCompleted;

  @override
  Future<void> setOnboardingCompleted(bool completed) async {
    _onboardingCompleted = completed;
  }

  @override
  Future<String?> getThemeMode() async => _themeMode;

  @override
  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
  }

  @override
  Future<String?> getLocaleCode() async => _localeCode;

  @override
  Future<void> setLocaleCode(String code) async {
    _localeCode = code;
  }

  @override
  Future<bool> getDemoModeEnabled() async => _demoModeEnabled;

  @override
  Future<void> setDemoModeEnabled(bool enabled) async {
    _demoModeEnabled = enabled;
  }

  @override
  Future<void> saveUser(User user) async {
    _users[user.id] = user;
  }

  @override
  Future<User?> getUser(String userId) async => _users[userId];

  @override
  Future<User?> getUserByPhone(String normalizedPhone) async {
    for (final User u in _users.values) {
      if (u.phoneNumber == normalizedPhone) {
        return u;
      }
    }
    return null;
  }

  @override
  Future<List<User>> getAllUsers() async =>
      List<User>.unmodifiable(_users.values);

  @override
  Future<Session?> getSession() async => _session;

  @override
  Future<void> saveSession(Session session) async {
    _session = session;
  }

  @override
  Future<void> clearSession() async {
    _session = null;
  }

  @override
  Future<String?> getAuthToken() async => _authToken;

  @override
  Future<void> saveAuthToken(String token) async {
    _authToken = token;
  }

  @override
  Future<void> clearAuthToken() async {
    _authToken = null;
  }

  @override
  Future<Wallet?> getWalletSnapshot(String userId) async => _wallets[userId];

  @override
  Future<void> saveWalletSnapshot(Wallet wallet) async {
    _wallets[wallet.userId] = wallet;
  }

  @override
  Future<List<Transaction>> getCachedTransactions(String walletId) async {
    return List<Transaction>.unmodifiable(
      _transactions[walletId] ?? <Transaction>[],
    );
  }

  @override
  Future<void> saveTransactions(List<Transaction> transactions) async {
    for (final Transaction tx in transactions) {
      final List<Transaction> list =
          _transactions.putIfAbsent(tx.senderWalletId, () => <Transaction>[]);
      final int existingIndex = list
          .indexWhere((Transaction e) => e.transactionId == tx.transactionId);
      if (existingIndex >= 0) {
        list[existingIndex] = tx;
      } else {
        list.add(tx);
      }
    }
  }

  @override
  Future<List<SyncQueueItem>> getSyncQueue() async =>
      List<SyncQueueItem>.unmodifiable(_syncQueue);

  @override
  Future<void> upsertSyncQueueItem(SyncQueueItem item) async {
    final int idx = _syncQueue
        .indexWhere((SyncQueueItem e) => e.transactionId == item.transactionId);
    if (idx >= 0) {
      _syncQueue[idx] = item;
    } else {
      _syncQueue.add(item);
    }
  }

  @override
  Future<void> removeSyncQueueItem(String transactionId) async {
    _syncQueue.removeWhere(
      (SyncQueueItem item) => item.transactionId == transactionId,
    );
  }

  @override
  Future<ConnectionStatus> getLastConnectionState() async =>
      _lastConnectionState;

  @override
  Future<void> saveLastConnectionState(ConnectionStatus status) async {
    _lastConnectionState = status;
  }

  @override
  Future<void> writeCache(String key, Map<String, dynamic> data) async {
    _cache[key] = Map<String, dynamic>.from(data);
  }

  @override
  Future<Map<String, dynamic>?> readCache(String key) async {
    final Map<String, dynamic>? entry = _cache[key];
    return entry == null ? null : Map<String, dynamic>.from(entry);
  }
}
