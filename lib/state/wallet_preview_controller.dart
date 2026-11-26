import 'package:flutter/foundation.dart';
import '../core/enums/app_enums.dart';
import '../core/errors/app_failure.dart';
import '../data/demo/demo_seed_data.dart';
import '../domain/models/models.dart';
import '../services/auth/auth_service.dart';
import '../services/transactions/transaction_service.dart';

/// Read-only Phase 1 dashboard/wallet/transactions preview controller.
/// Delegates all financial data access to [TransactionService] and [AuthService].
class WalletPreviewController extends ChangeNotifier {
  WalletPreviewController(this._authService, this._transactionService);

  final AuthService _authService;
  final TransactionService _transactionService;

  bool _isLoading = false;
  bool _balanceHidden = false;
  AppFailure? _failure;
  User? _user;
  Wallet? _wallet;
  List<Transaction> _transactions = <Transaction>[];
  List<AppNotification> _notifications = <AppNotification>[];

  bool get isLoading => _isLoading;
  bool get balanceHidden => _balanceHidden;
  AppFailure? get failure => _failure;
  User? get user => _user;
  Wallet? get wallet => _wallet;
  List<Transaction> get transactions => _transactions;
  List<AppNotification> get notifications => _notifications;

  int get unreadNotificationCount =>
      _notifications.where((AppNotification n) => !n.isRead).length;

  Future<void> loadPreview() async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    try {
      final User? currentUser = await _authService.getCurrentUser();
      _user = currentUser ?? DemoSeedData.demoUser;
      final String userId = _user!.id;
      _wallet = await _transactionService.getWallet(userId);
      _transactions =
          await _transactionService.getTransactions(_wallet!.walletId);
      _notifications =
          List<AppNotification>.from(DemoSeedData.demoNotifications);
    } catch (_) {
      _failure = const UnexpectedFailure();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleBalanceVisibility() {
    _balanceHidden = !_balanceHidden;
    notifyListeners();
  }

  List<Transaction> filterTransactions(TransactionType? type) {
    if (type == null) {
      return _transactions;
    }
    return _transactions.where((Transaction tx) => tx.type == type).toList();
  }
}
