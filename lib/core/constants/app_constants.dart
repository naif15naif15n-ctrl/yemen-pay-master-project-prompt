/// Application-wide constants and academic simulation metadata for Yemen Pay.
abstract final class AppConstants {
  static const String appNameEn = 'Yemen Pay';
  static const String appNameAr = 'يمن باي';
  static const String fullBrandTitle = 'Yemen Pay — يمن باي';
  static const String taglineAr = 'محفظتك الذكية، حتى بدون إنترنت';
  static const String taglineEn = 'Your Smart Wallet, Even Without Internet';
  static const String academicNoticeAr =
      'مشروع تخرج جامعي ونموذج محاكاة تعليمي — جميع العمليات المالية والأرصدة والخدمات داخل التطبيق تجريبية وليست حقيقية.';
  static const String academicNoticeEn =
      'Academic graduation project prototype — all financial operations, balances, and services are simulated and not real.';

  static const String defaultCountryCode = '+967';
  static const String defaultCurrencyCode = 'YER';
  static const List<String> supportedCurrencies = <String>['YER', 'USD', 'SAR'];

  /// Yemen phone number format: +967 followed by 9 digits (typically starting with 7).
  static final RegExp yemenPhoneRegex = RegExp(r'^\+9677\d{8}$');

  static const int otpLength = 6;
  static const int otpExpirationSeconds = 180;
  static const int otpRetrySeconds = 60;
  static const int maxOtpAttempts = 5;
  static const int pinLength = 4;

  /// Explicitly supported operations in Local Server Offline-First mode.
  static const List<String> offlineSupportedOperations = <String>[
    'transfer',
    'receive',
    'deposit',
    'withdrawal',
    'qrPayment',
    'merchantPayment',
  ];
}
