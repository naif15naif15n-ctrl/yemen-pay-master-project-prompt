import '../../core/enums/app_enums.dart';

/// Detailed balance breakdown per wallet currency.
class WalletBalance {
  const WalletBalance({
    required this.walletId,
    required this.currency,
    required this.totalBalance,
    required this.availableBalance,
    required this.pendingBalance,
    required this.updatedAt,
  });

  final String walletId;
  final CurrencyCode currency;
  final double totalBalance;
  final double availableBalance;
  final double pendingBalance;
  final DateTime updatedAt;

  WalletBalance copyWith({
    double? totalBalance,
    double? availableBalance,
    double? pendingBalance,
    DateTime? updatedAt,
  }) {
    return WalletBalance(
      walletId: walletId,
      currency: currency,
      totalBalance: totalBalance ?? this.totalBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      pendingBalance: pendingBalance ?? this.pendingBalance,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'walletId': walletId,
        'currency': currency.name,
        'totalBalance': totalBalance,
        'availableBalance': availableBalance,
        'pendingBalance': pendingBalance,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory WalletBalance.fromJson(Map<String, dynamic> json) => WalletBalance(
        walletId: json['walletId'] as String,
        currency: CurrencyCode.values.byName(json['currency'] as String),
        totalBalance: (json['totalBalance'] as num).toDouble(),
        availableBalance: (json['availableBalance'] as num).toDouble(),
        pendingBalance: (json['pendingBalance'] as num).toDouble(),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

/// Primary electronic wallet linked to a user.
class Wallet {
  const Wallet({
    required this.walletId,
    required this.userId,
    required this.primaryCurrency,
    required this.balance,
    required this.availableBalance,
    required this.pendingBalance,
    required this.status,
    required this.createdAt,
    this.isSimulated = true,
  });

  final String walletId;
  final String userId;
  final CurrencyCode primaryCurrency;
  final double balance;
  final double availableBalance;
  final double pendingBalance;
  final WalletStatus status;
  final DateTime createdAt;
  final bool isSimulated;

  Wallet copyWith({
    CurrencyCode? primaryCurrency,
    double? balance,
    double? availableBalance,
    double? pendingBalance,
    WalletStatus? status,
  }) {
    return Wallet(
      walletId: walletId,
      userId: userId,
      primaryCurrency: primaryCurrency ?? this.primaryCurrency,
      balance: balance ?? this.balance,
      availableBalance: availableBalance ?? this.availableBalance,
      pendingBalance: pendingBalance ?? this.pendingBalance,
      status: status ?? this.status,
      createdAt: createdAt,
      isSimulated: isSimulated,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'walletId': walletId,
        'userId': userId,
        'primaryCurrency': primaryCurrency.name,
        'balance': balance,
        'availableBalance': availableBalance,
        'pendingBalance': pendingBalance,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'isSimulated': isSimulated,
      };

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        walletId: json['walletId'] as String,
        userId: json['userId'] as String,
        primaryCurrency:
            CurrencyCode.values.byName(json['primaryCurrency'] as String),
        balance: (json['balance'] as num).toDouble(),
        availableBalance: (json['availableBalance'] as num).toDouble(),
        pendingBalance: (json['pendingBalance'] as num).toDouble(),
        status: WalletStatus.values.byName(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        isSimulated: json['isSimulated'] as bool? ?? true,
      );
}

/// Saved transfer recipient for quick send operations.
class Beneficiary {
  const Beneficiary({
    required this.id,
    required this.ownerUserId,
    required this.name,
    required this.phoneNumber,
    required this.walletId,
    this.alias,
    this.isFavorite = false,
  });

  final String id;
  final String ownerUserId;
  final String name;
  final String phoneNumber;
  final String walletId;
  final String? alias;
  final bool isFavorite;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'ownerUserId': ownerUserId,
        'name': name,
        'phoneNumber': phoneNumber,
        'walletId': walletId,
        'alias': alias,
        'isFavorite': isFavorite,
      };

  factory Beneficiary.fromJson(Map<String, dynamic> json) => Beneficiary(
        id: json['id'] as String,
        ownerUserId: json['ownerUserId'] as String,
        name: json['name'] as String,
        phoneNumber: json['phoneNumber'] as String,
        walletId: json['walletId'] as String,
        alias: json['alias'] as String?,
        isFavorite: json['isFavorite'] as bool? ?? false,
      );
}
