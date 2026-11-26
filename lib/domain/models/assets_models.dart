import '../../core/enums/app_enums.dart';

/// Experimental simulated digital gold portfolio account.
class GoldAccount {
  const GoldAccount({
    required this.accountId,
    required this.userId,
    required this.gramsBalance,
    required this.averagePurchasePricePerGram,
    required this.updatedAt,
    this.isEducationalSimulation = true,
  });

  final String accountId;
  final String userId;
  final double gramsBalance;
  final double averagePurchasePricePerGram;
  final DateTime updatedAt;
  final bool isEducationalSimulation;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'accountId': accountId,
        'userId': userId,
        'gramsBalance': gramsBalance,
        'averagePurchasePricePerGram': averagePurchasePricePerGram,
        'updatedAt': updatedAt.toIso8601String(),
        'isEducationalSimulation': isEducationalSimulation,
      };

  factory GoldAccount.fromJson(Map<String, dynamic> json) => GoldAccount(
        accountId: json['accountId'] as String,
        userId: json['userId'] as String,
        gramsBalance: (json['gramsBalance'] as num).toDouble(),
        averagePurchasePricePerGram:
            (json['averagePurchasePricePerGram'] as num).toDouble(),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        isEducationalSimulation:
            json['isEducationalSimulation'] as bool? ?? true,
      );
}

/// Experimental simulated gold buy/sell transaction.
class GoldTransaction {
  const GoldTransaction({
    required this.id,
    required this.accountId,
    required this.transactionId,
    required this.type,
    required this.grams,
    required this.pricePerGram,
    required this.totalAmount,
    required this.createdAt,
  });

  final String id;
  final String accountId;
  final String transactionId;
  final TransactionType type;
  final double grams;
  final double pricePerGram;
  final double totalAmount;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'accountId': accountId,
        'transactionId': transactionId,
        'type': type.name,
        'grams': grams,
        'pricePerGram': pricePerGram,
        'totalAmount': totalAmount,
        'createdAt': createdAt.toIso8601String(),
      };

  factory GoldTransaction.fromJson(Map<String, dynamic> json) =>
      GoldTransaction(
        id: json['id'] as String,
        accountId: json['accountId'] as String,
        transactionId: json['transactionId'] as String,
        type: TransactionType.values.byName(json['type'] as String),
        grams: (json['grams'] as num).toDouble(),
        pricePerGram: (json['pricePerGram'] as num).toDouble(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Experimental simulated digital currency holding (BTC, ETH, USDT).
class DigitalAssetAccount {
  const DigitalAssetAccount({
    required this.accountId,
    required this.userId,
    required this.symbol,
    required this.balance,
    required this.averageEntryPriceUsd,
    required this.isEducationalSimulation,
  });

  final String accountId;
  final String userId;
  final String symbol;
  final double balance;
  final double averageEntryPriceUsd;
  final bool isEducationalSimulation;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'accountId': accountId,
        'userId': userId,
        'symbol': symbol,
        'balance': balance,
        'averageEntryPriceUsd': averageEntryPriceUsd,
        'isEducationalSimulation': isEducationalSimulation,
      };

  factory DigitalAssetAccount.fromJson(Map<String, dynamic> json) =>
      DigitalAssetAccount(
        accountId: json['accountId'] as String,
        userId: json['userId'] as String,
        symbol: json['symbol'] as String,
        balance: (json['balance'] as num).toDouble(),
        averageEntryPriceUsd: (json['averageEntryPriceUsd'] as num).toDouble(),
        isEducationalSimulation:
            json['isEducationalSimulation'] as bool? ?? true,
      );
}

/// Experimental simulated digital asset buy/sell/transfer event.
class DigitalAssetTransaction {
  const DigitalAssetTransaction({
    required this.id,
    required this.accountId,
    required this.transactionId,
    required this.symbol,
    required this.type,
    required this.quantity,
    required this.unitPriceUsd,
    required this.createdAt,
  });

  final String id;
  final String accountId;
  final String transactionId;
  final String symbol;
  final TransactionType type;
  final double quantity;
  final double unitPriceUsd;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'accountId': accountId,
        'transactionId': transactionId,
        'symbol': symbol,
        'type': type.name,
        'quantity': quantity,
        'unitPriceUsd': unitPriceUsd,
        'createdAt': createdAt.toIso8601String(),
      };

  factory DigitalAssetTransaction.fromJson(Map<String, dynamic> json) =>
      DigitalAssetTransaction(
        id: json['id'] as String,
        accountId: json['accountId'] as String,
        transactionId: json['transactionId'] as String,
        symbol: json['symbol'] as String,
        type: TransactionType.values.byName(json['type'] as String),
        quantity: (json['quantity'] as num).toDouble(),
        unitPriceUsd: (json['unitPriceUsd'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
