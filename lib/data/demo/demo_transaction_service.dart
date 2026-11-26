import '../../core/enums/app_enums.dart';
import '../../domain/models/models.dart';
import '../../services/transactions/transaction_service.dart';
import 'demo_seed_data.dart';

/// Simulated Phase 1 implementation of [TransactionService].
/// Interactive transfer, deposit, withdrawal, and double-entry ledger mutations
/// will be activated in Phase 3.
class DemoTransactionService implements TransactionService {
  final Wallet _wallet = DemoSeedData.demoWallet;
  final List<Transaction> _transactions =
      List<Transaction>.from(DemoSeedData.demoTransactions);
  final List<LedgerEntry> _ledgerEntries = <LedgerEntry>[];

  @override
  Future<Wallet> getWallet(String userId) async => _wallet;

  @override
  Future<List<Transaction>> getTransactions(
    String walletId, {
    TransactionType? filterType,
  }) async {
    if (filterType == null) {
      return List<Transaction>.unmodifiable(_transactions);
    }
    return List<Transaction>.unmodifiable(
      _transactions.where((Transaction tx) => tx.type == filterType),
    );
  }

  @override
  Future<List<LedgerEntry>> getLedgerEntries(String walletId) async {
    return List<LedgerEntry>.unmodifiable(_ledgerEntries);
  }

  @override
  Future<Transaction> executeTransaction(TransactionRequest request) async {
    // Idempotency check prevents duplicate execution.
    for (final Transaction existing in _transactions) {
      if (existing.idempotencyKey == request.idempotencyKey) {
        return existing;
      }
    }

    final DateTime now = DateTime.now();
    final Transaction tx = Transaction(
      transactionId: 'TX-SIM-${now.millisecondsSinceEpoch}',
      idempotencyKey: request.idempotencyKey,
      type: request.type,
      senderWalletId: request.senderWalletId,
      receiverWalletId: request.receiverWalletId,
      senderName: DemoSeedData.demoUser.fullName,
      receiverName: request.receiverWalletId,
      amount: request.amount,
      currency: request.currency,
      fee: 0,
      status: TransactionStatus.completed,
      timestamp: now,
      reference: 'REF-${now.millisecondsSinceEpoch}',
      source: request.source,
      deviceId: request.deviceId,
      syncStatus: request.source == TransactionSource.offlineQueue
          ? SyncStatus.pending
          : SyncStatus.synced,
      note: request.note,
      isSimulated: true,
    );
    _transactions.insert(0, tx);
    return tx;
  }
}
