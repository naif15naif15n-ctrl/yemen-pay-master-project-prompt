/// Core enumerations shared across Yemen Pay domain, services, and UI.
enum ConnectionStatus {
  internetAvailable,
  internetUnavailable,
  localWifiConnected,
  localServerAvailable,
  fullyOffline,
}

enum UserRole {
  customer,
  merchant,
  agent,
  admin,
}

enum AccountStatus {
  active,
  pendingVerification,
  suspended,
  locked,
}

enum WalletStatus {
  active,
  frozen,
  closed,
}

enum CurrencyCode {
  yer,
  usd,
  sar,
}

enum TransactionType {
  transfer,
  receive,
  deposit,
  withdrawal,
  qrPayment,
  merchantPayment,
  remittance,
  recharge,
  billPayment,
  exchange,
  goldBuy,
  goldSell,
  digitalAssetBuy,
  digitalAssetSell,
  savingsContribution,
  refund,
}

enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  conflict,
  synced,
}

enum TransactionSource {
  online,
  localServer,
  offlineQueue,
  demo,
}

enum SyncStatus {
  pending,
  processing,
  synced,
  failed,
  conflict,
}

enum SyncConflictReason {
  duplicateTransaction,
  insufficientBalance,
  staleWalletState,
  conflictingTransaction,
  serverRejection,
}

enum SyncOperationType {
  transfer,
  deposit,
  withdrawal,
  qrPayment,
  merchantPayment,
}

enum RemittanceStatus {
  created,
  pending,
  paid,
  cancelled,
  expired,
}

enum RequestStatus {
  pending,
  accepted,
  rejected,
  expired,
}

enum BillCategory {
  electricity,
  water,
  internet,
  landline,
  government,
  traffic,
  education,
  university,
  other,
}

enum ComplaintStatus {
  open,
  inProgress,
  resolved,
  closed,
}

enum NotificationType {
  transferReceived,
  transferSent,
  deposit,
  withdrawal,
  billPaid,
  recharge,
  securityAlert,
  otp,
  syncCompleted,
  syncFailed,
  savingsReminder,
}

enum ExpenseCategoryType {
  food,
  transport,
  shopping,
  bills,
  communication,
  education,
  entertainment,
  other,
}

enum OtpVerificationStatus {
  idle,
  sent,
  verified,
  expired,
  failed,
  maxAttemptsExceeded,
}
