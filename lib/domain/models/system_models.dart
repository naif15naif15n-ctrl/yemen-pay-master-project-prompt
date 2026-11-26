import '../../core/enums/app_enums.dart';

/// User notification record.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.titleAr,
    required this.bodyAr,
    required this.createdAt,
    this.isRead = false,
    this.relatedTransactionId,
  });

  final String id;
  final String userId;
  final NotificationType type;
  final String titleAr;
  final String bodyAr;
  final DateTime createdAt;
  final bool isRead;
  final String? relatedTransactionId;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      userId: userId,
      type: type,
      titleAr: titleAr,
      bodyAr: bodyAr,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      relatedTransactionId: relatedTransactionId,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'type': type.name,
        'titleAr': titleAr,
        'bodyAr': bodyAr,
        'createdAt': createdAt.toIso8601String(),
        'isRead': isRead,
        'relatedTransactionId': relatedTransactionId,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] as String,
        userId: json['userId'] as String,
        type: NotificationType.values.byName(json['type'] as String),
        titleAr: json['titleAr'] as String,
        bodyAr: json['bodyAr'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isRead: json['isRead'] as bool? ?? false,
        relatedTransactionId: json['relatedTransactionId'] as String?,
      );
}

/// Persistent offline sync queue entry with idempotency and retry tracking.
class SyncQueueItem {
  const SyncQueueItem({
    required this.transactionId,
    required this.deviceId,
    required this.userId,
    required this.operationType,
    required this.amount,
    required this.currency,
    required this.timestamp,
    required this.payload,
    required this.status,
    this.retryCount = 0,
    this.syncTimestamp,
    this.conflictReason,
  });

  final String transactionId;
  final String deviceId;
  final String userId;
  final SyncOperationType operationType;
  final double amount;
  final CurrencyCode currency;
  final DateTime timestamp;
  final Map<String, dynamic> payload;
  final SyncStatus status;
  final int retryCount;
  final DateTime? syncTimestamp;
  final SyncConflictReason? conflictReason;

  SyncQueueItem copyWith({
    SyncStatus? status,
    int? retryCount,
    DateTime? syncTimestamp,
    SyncConflictReason? conflictReason,
  }) {
    return SyncQueueItem(
      transactionId: transactionId,
      deviceId: deviceId,
      userId: userId,
      operationType: operationType,
      amount: amount,
      currency: currency,
      timestamp: timestamp,
      payload: payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      syncTimestamp: syncTimestamp ?? this.syncTimestamp,
      conflictReason: conflictReason ?? this.conflictReason,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'transactionId': transactionId,
        'deviceId': deviceId,
        'userId': userId,
        'operationType': operationType.name,
        'amount': amount,
        'currency': currency.name,
        'timestamp': timestamp.toIso8601String(),
        'payload': payload,
        'status': status.name,
        'retryCount': retryCount,
        'syncTimestamp': syncTimestamp?.toIso8601String(),
        'conflictReason': conflictReason?.name,
      };

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) => SyncQueueItem(
        transactionId: json['transactionId'] as String,
        deviceId: json['deviceId'] as String,
        userId: json['userId'] as String,
        operationType:
            SyncOperationType.values.byName(json['operationType'] as String),
        amount: (json['amount'] as num).toDouble(),
        currency: CurrencyCode.values.byName(json['currency'] as String),
        timestamp: DateTime.parse(json['timestamp'] as String),
        payload: Map<String, dynamic>.from(
          json['payload'] as Map<dynamic, dynamic>,
        ),
        status: SyncStatus.values.byName(json['status'] as String),
        retryCount: json['retryCount'] as int? ?? 0,
        syncTimestamp: json['syncTimestamp'] != null
            ? DateTime.parse(json['syncTimestamp'] as String)
            : null,
        conflictReason: json['conflictReason'] != null
            ? SyncConflictReason.values.byName(json['conflictReason'] as String)
            : null,
      );
}

/// Security and financial audit log entry.
class AuditLog {
  const AuditLog({
    required this.id,
    required this.actorUserId,
    required this.action,
    required this.targetId,
    required this.deviceId,
    required this.createdAt,
    this.metadata = const <String, dynamic>{},
  });

  final String id;
  final String actorUserId;
  final String action;
  final String targetId;
  final String deviceId;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'actorUserId': actorUserId,
        'action': action,
        'targetId': targetId,
        'deviceId': deviceId,
        'createdAt': createdAt.toIso8601String(),
        'metadata': metadata,
      };

  factory AuditLog.fromJson(Map<String, dynamic> json) => AuditLog(
        id: json['id'] as String,
        actorUserId: json['actorUserId'] as String,
        action: json['action'] as String,
        targetId: json['targetId'] as String,
        deviceId: json['deviceId'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        metadata: Map<String, dynamic>.from(
          json['metadata'] as Map<dynamic, dynamic>? ?? <dynamic, dynamic>{},
        ),
      );
}

/// User complaint ticket.
class Complaint {
  const Complaint({
    required this.id,
    required this.userId,
    required this.complaintType,
    required this.description,
    required this.status,
    required this.createdAt,
    this.transactionId,
    this.attachmentPaths = const <String>[],
  });

  final String id;
  final String userId;
  final String complaintType;
  final String description;
  final ComplaintStatus status;
  final DateTime createdAt;
  final String? transactionId;
  final List<String> attachmentPaths;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'complaintType': complaintType,
        'description': description,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'transactionId': transactionId,
        'attachmentPaths': attachmentPaths,
      };

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
        id: json['id'] as String,
        userId: json['userId'] as String,
        complaintType: json['complaintType'] as String,
        description: json['description'] as String,
        status: ComplaintStatus.values.byName(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        transactionId: json['transactionId'] as String?,
        attachmentPaths:
            (json['attachmentPaths'] as List<dynamic>? ?? <dynamic>[])
                .cast<String>(),
      );
}
