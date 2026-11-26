import '../../core/enums/app_enums.dart';

/// Central financial transaction record passing exclusively through TransactionService.
class Transaction {
  const Transaction({
    required this.transactionId,
    required this.idempotencyKey,
    required this.type,
    required this.senderWalletId,
    required this.receiverWalletId,
    required this.senderName,
    required this.receiverName,
    required this.amount,
    required this.currency,
    required this.fee,
    required this.status,
    required this.timestamp,
    required this.reference,
    required this.source,
    required this.deviceId,
    required this.syncStatus,
    this.note,
    this.isSimulated = true,
  });

  final String transactionId;
  final String idempotencyKey;
  final TransactionType type;
  final String senderWalletId;
  final String receiverWalletId;
  final String senderName;
  final String receiverName;
  final double amount;
  final CurrencyCode currency;
  final double fee;
  final TransactionStatus status;
  final DateTime timestamp;
  final String reference;
  final TransactionSource source;
  final String deviceId;
  final SyncStatus syncStatus;
  final String? note;
  final bool isSimulated;

  Transaction copyWith({
    TransactionStatus? status,
    SyncStatus? syncStatus,
    String? note,
  }) {
    return Transaction(
      transactionId: transactionId,
      idempotencyKey: idempotencyKey,
      type: type,
      senderWalletId: senderWalletId,
      receiverWalletId: receiverWalletId,
      senderName: senderName,
      receiverName: receiverName,
      amount: amount,
      currency: currency,
      fee: fee,
      status: status ?? this.status,
      timestamp: timestamp,
      reference: reference,
      source: source,
      deviceId: deviceId,
      syncStatus: syncStatus ?? this.syncStatus,
      note: note ?? this.note,
      isSimulated: isSimulated,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'transactionId': transactionId,
        'idempotencyKey': idempotencyKey,
        'type': type.name,
        'senderWalletId': senderWalletId,
        'receiverWalletId': receiverWalletId,
        'senderName': senderName,
        'receiverName': receiverName,
        'amount': amount,
        'currency': currency.name,
        'fee': fee,
        'status': status.name,
        'timestamp': timestamp.toIso8601String(),
        'reference': reference,
        'source': source.name,
        'deviceId': deviceId,
        'syncStatus': syncStatus.name,
        'note': note,
        'isSimulated': isSimulated,
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        transactionId: json['transactionId'] as String,
        idempotencyKey: json['idempotencyKey'] as String,
        type: TransactionType.values.byName(json['type'] as String),
        senderWalletId: json['senderWalletId'] as String,
        receiverWalletId: json['receiverWalletId'] as String,
        senderName: json['senderName'] as String,
        receiverName: json['receiverName'] as String,
        amount: (json['amount'] as num).toDouble(),
        currency: CurrencyCode.values.byName(json['currency'] as String),
        fee: (json['fee'] as num).toDouble(),
        status: TransactionStatus.values.byName(json['status'] as String),
        timestamp: DateTime.parse(json['timestamp'] as String),
        reference: json['reference'] as String,
        source: TransactionSource.values.byName(json['source'] as String),
        deviceId: json['deviceId'] as String,
        syncStatus: SyncStatus.values.byName(json['syncStatus'] as String),
        note: json['note'] as String?,
        isSimulated: json['isSimulated'] as bool? ?? true,
      );
}

enum LedgerEntryDirection { debit, credit }

/// Double-entry ledger line ensuring every balance change is traceable.
class LedgerEntry {
  const LedgerEntry({
    required this.entryId,
    required this.transactionId,
    required this.walletId,
    required this.direction,
    required this.amount,
    required this.currency,
    required this.balanceAfter,
    required this.createdAt,
  });

  final String entryId;
  final String transactionId;
  final String walletId;
  final LedgerEntryDirection direction;
  final double amount;
  final CurrencyCode currency;
  final double balanceAfter;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'entryId': entryId,
        'transactionId': transactionId,
        'walletId': walletId,
        'direction': direction.name,
        'amount': amount,
        'currency': currency.name,
        'balanceAfter': balanceAfter,
        'createdAt': createdAt.toIso8601String(),
      };

  factory LedgerEntry.fromJson(Map<String, dynamic> json) => LedgerEntry(
        entryId: json['entryId'] as String,
        transactionId: json['transactionId'] as String,
        walletId: json['walletId'] as String,
        direction:
            LedgerEntryDirection.values.byName(json['direction'] as String),
        amount: (json['amount'] as num).toDouble(),
        currency: CurrencyCode.values.byName(json['currency'] as String),
        balanceAfter: (json['balanceAfter'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

enum QrCodeType { personal, receive, transfer, merchant, agent, payment }

/// Structured QR payload validated through QR Parser -> TransactionService.
class QrCodeModel {
  const QrCodeModel({
    required this.qrId,
    required this.type,
    required this.targetWalletId,
    required this.ownerName,
    required this.createdAt,
    this.amount,
    this.currency = CurrencyCode.yer,
    this.expiresAt,
  });

  final String qrId;
  final QrCodeType type;
  final String targetWalletId;
  final String ownerName;
  final DateTime createdAt;
  final double? amount;
  final CurrencyCode currency;
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'qrId': qrId,
        'type': type.name,
        'targetWalletId': targetWalletId,
        'ownerName': ownerName,
        'createdAt': createdAt.toIso8601String(),
        'amount': amount,
        'currency': currency.name,
        'expiresAt': expiresAt?.toIso8601String(),
      };

  factory QrCodeModel.fromJson(Map<String, dynamic> json) => QrCodeModel(
        qrId: json['qrId'] as String,
        type: QrCodeType.values.byName(json['type'] as String),
        targetWalletId: json['targetWalletId'] as String,
        ownerName: json['ownerName'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        amount: (json['amount'] as num?)?.toDouble(),
        currency: CurrencyCode.values
            .byName(json['currency'] as String? ?? 'yer'),
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'] as String)
            : null,
      );
}

/// Simulated remittance entity with security code and payout tracking.
class Remittance {
  const Remittance({
    required this.id,
    required this.remittanceNumber,
    required this.securityCodeHash,
    required this.senderWalletId,
    required this.senderName,
    required this.receiverName,
    required this.receiverPhone,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.paidByAgentId,
  });

  final String id;
  final String remittanceNumber;
  final String securityCodeHash;
  final String senderWalletId;
  final String senderName;
  final String receiverName;
  final String receiverPhone;
  final double amount;
  final CurrencyCode currency;
  final RemittanceStatus status;
  final DateTime createdAt;
  final String? paidByAgentId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'remittanceNumber': remittanceNumber,
        'securityCodeHash': securityCodeHash,
        'senderWalletId': senderWalletId,
        'senderName': senderName,
        'receiverName': receiverName,
        'receiverPhone': receiverPhone,
        'amount': amount,
        'currency': currency.name,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'paidByAgentId': paidByAgentId,
      };

  factory Remittance.fromJson(Map<String, dynamic> json) => Remittance(
        id: json['id'] as String,
        remittanceNumber: json['remittanceNumber'] as String,
        securityCodeHash: json['securityCodeHash'] as String,
        senderWalletId: json['senderWalletId'] as String,
        senderName: json['senderName'] as String,
        receiverName: json['receiverName'] as String,
        receiverPhone: json['receiverPhone'] as String,
        amount: (json['amount'] as num).toDouble(),
        currency: CurrencyCode.values.byName(json['currency'] as String),
        status: RemittanceStatus.values.byName(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        paidByAgentId: json['paidByAgentId'] as String?,
      );
}
