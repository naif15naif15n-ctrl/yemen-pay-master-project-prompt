import '../../core/enums/app_enums.dart';

/// Simulated Yemen Pay Agent profile.
class Agent {
  const Agent({
    required this.agentId,
    required this.userId,
    required this.walletId,
    required this.businessName,
    required this.city,
    required this.agentCode,
    required this.isActive,
  });

  final String agentId;
  final String userId;
  final String walletId;
  final String businessName;
  final String city;
  final String agentCode;
  final bool isActive;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'agentId': agentId,
        'userId': userId,
        'walletId': walletId,
        'businessName': businessName,
        'city': city,
        'agentCode': agentCode,
        'isActive': isActive,
      };

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        agentId: json['agentId'] as String,
        userId: json['userId'] as String,
        walletId: json['walletId'] as String,
        businessName: json['businessName'] as String,
        city: json['city'] as String,
        agentCode: json['agentCode'] as String,
        isActive: json['isActive'] as bool? ?? true,
      );
}

/// Simulated Merchant account profile.
class Merchant {
  const Merchant({
    required this.merchantId,
    required this.userId,
    required this.walletId,
    required this.storeName,
    required this.category,
    required this.merchantQrId,
    required this.isActive,
  });

  final String merchantId;
  final String userId;
  final String walletId;
  final String storeName;
  final String category;
  final String merchantQrId;
  final bool isActive;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'merchantId': merchantId,
        'userId': userId,
        'walletId': walletId,
        'storeName': storeName,
        'category': category,
        'merchantQrId': merchantQrId,
        'isActive': isActive,
      };

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        merchantId: json['merchantId'] as String,
        userId: json['userId'] as String,
        walletId: json['walletId'] as String,
        storeName: json['storeName'] as String,
        category: json['category'] as String,
        merchantQrId: json['merchantQrId'] as String,
        isActive: json['isActive'] as bool? ?? true,
      );
}

/// Simulated mobile telecom recharge transaction (Yemen Mobile, YOU, Sabafon, Y).
class RechargeTransaction {
  const RechargeTransaction({
    required this.id,
    required this.transactionId,
    required this.provider,
    required this.targetPhone,
    required this.serviceType,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String transactionId;
  final String provider;
  final String targetPhone;
  final String serviceType;
  final double amount;
  final TransactionStatus status;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'transactionId': transactionId,
        'provider': provider,
        'targetPhone': targetPhone,
        'serviceType': serviceType,
        'amount': amount,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory RechargeTransaction.fromJson(Map<String, dynamic> json) =>
      RechargeTransaction(
        id: json['id'] as String,
        transactionId: json['transactionId'] as String,
        provider: json['provider'] as String,
        targetPhone: json['targetPhone'] as String,
        serviceType: json['serviceType'] as String,
        amount: (json['amount'] as num).toDouble(),
        status: TransactionStatus.values.byName(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Simulated bill entity (Electricity, Water, Internet, etc.).
class Bill {
  const Bill({
    required this.billId,
    required this.category,
    required this.providerName,
    required this.accountNumber,
    required this.subscriberName,
    required this.amountDue,
    required this.currency,
    required this.dueDate,
    this.isPaid = false,
  });

  final String billId;
  final BillCategory category;
  final String providerName;
  final String accountNumber;
  final String subscriberName;
  final double amountDue;
  final CurrencyCode currency;
  final DateTime dueDate;
  final bool isPaid;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'billId': billId,
        'category': category.name,
        'providerName': providerName,
        'accountNumber': accountNumber,
        'subscriberName': subscriberName,
        'amountDue': amountDue,
        'currency': currency.name,
        'dueDate': dueDate.toIso8601String(),
        'isPaid': isPaid,
      };

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        billId: json['billId'] as String,
        category: BillCategory.values.byName(json['category'] as String),
        providerName: json['providerName'] as String,
        accountNumber: json['accountNumber'] as String,
        subscriberName: json['subscriberName'] as String,
        amountDue: (json['amountDue'] as num).toDouble(),
        currency: CurrencyCode.values.byName(json['currency'] as String),
        dueDate: DateTime.parse(json['dueDate'] as String),
        isPaid: json['isPaid'] as bool? ?? false,
      );
}

/// Simulated bill payment record.
class BillTransaction {
  const BillTransaction({
    required this.id,
    required this.billId,
    required this.transactionId,
    required this.amountPaid,
    required this.status,
    required this.paidAt,
  });

  final String id;
  final String billId;
  final String transactionId;
  final double amountPaid;
  final TransactionStatus status;
  final DateTime paidAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'billId': billId,
        'transactionId': transactionId,
        'amountPaid': amountPaid,
        'status': status.name,
        'paidAt': paidAt.toIso8601String(),
      };

  factory BillTransaction.fromJson(Map<String, dynamic> json) =>
      BillTransaction(
        id: json['id'] as String,
        billId: json['billId'] as String,
        transactionId: json['transactionId'] as String,
        amountPaid: (json['amountPaid'] as num).toDouble(),
        status: TransactionStatus.values.byName(json['status'] as String),
        paidAt: DateTime.parse(json['paidAt'] as String),
      );
}
