import '../../core/enums/app_enums.dart';
import '../../domain/models/models.dart';

/// Request payload passed into central TransactionService.
class TransactionRequest {
  const TransactionRequest({
    required this.idempotencyKey,
    required this.type,
    required this.senderWalletId,
    required this.receiverWalletId,
    required this.amount,
    required this.currency,
    required this.source,
    required this.deviceId,
    this.note,
  });

  final String idempotencyKey;
  final TransactionType type;
  final String senderWalletId;
  final String receiverWalletId;
  final double amount;
  final CurrencyCode currency;
  final TransactionSource source;
  final String deviceId;
  final String? note;
}

/// Central Transaction Engine abstraction.
/// Every financial operation MUST pass through this service;
/// UI widgets never modify wallet balances directly.
abstract interface class TransactionService {
  Future<Wallet> getWallet(String userId);

  Future<List<Transaction>> getTransactions(
    String walletId, {
    TransactionType? filterType,
  });

  Future<List<LedgerEntry>> getLedgerEntries(String walletId);

  Future<Transaction> executeTransaction(TransactionRequest request);
}
