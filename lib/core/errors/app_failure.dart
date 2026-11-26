/// Typed failure hierarchy ensuring raw technical exceptions never reach UI.
sealed class AppFailure {
  const AppFailure({
    required this.code,
    required this.messageAr,
    required this.messageEn,
  });

  final String code;
  final String messageAr;
  final String messageEn;

  String localizedMessage(String languageCode) =>
      languageCode == 'en' ? messageEn : messageAr;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure({
    super.code = 'NETWORK_ERROR',
    super.messageAr = 'تعذر الاتصال بالشبكة. يرجى التحقق من اتصالك والمحاولة مجددًا.',
    super.messageEn = 'Unable to connect to the network. Please try again.',
  });
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure({
    required super.messageAr,
    required super.messageEn,
    super.code = 'VALIDATION_ERROR',
  });
}

final class AuthFailure extends AppFailure {
  const AuthFailure({
    required super.messageAr,
    required super.messageEn,
    super.code = 'AUTH_ERROR',
  });
}

final class InsufficientBalanceFailure extends AppFailure {
  const InsufficientBalanceFailure({
    super.code = 'INSUFFICIENT_BALANCE',
    super.messageAr = 'الرصيد المتاح غير كافٍ لإتمام هذه العملية.',
    super.messageEn = 'Available balance is insufficient for this operation.',
  });
}

final class SyncConflictFailure extends AppFailure {
  const SyncConflictFailure({
    required super.messageAr,
    required super.messageEn,
    super.code = 'SYNC_CONFLICT',
  });
}

final class StorageFailure extends AppFailure {
  const StorageFailure({
    super.code = 'STORAGE_ERROR',
    super.messageAr = 'تعذر حفظ البيانات محليًا. يرجى المحاولة مرة أخرى.',
    super.messageEn = 'Failed to persist local data. Please try again.',
  });
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({
    super.code = 'UNEXPECTED_ERROR',
    super.messageAr = 'حدث خطأ غير متوقع أثناء تنفيذ العملية.',
    super.messageEn = 'An unexpected error occurred while processing.',
  });
}
