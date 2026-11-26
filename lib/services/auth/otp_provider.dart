import '../../core/enums/app_enums.dart';

/// Abstract SMS OTP Provider contract.
/// Allows swapping between Academic Demo mode, Firebase Phone Auth,
/// and local Yemeni SMS gateways without touching presentation logic.
abstract interface class OtpProvider {
  String get name;
  OtpMode get mode;

  /// Delivers or simulates sending the OTP to the specified phone number.
  Future<bool> sendOtp({
    required String phoneNumber,
    required String rawOtpCode,
    required OtpPurpose purpose,
  });
}

/// Academic demonstration OTP provider.
/// Does not invoke real paid telecom SMS APIs; records test OTP for academic evaluation.
class DemoOtpProvider implements OtpProvider {
  DemoOtpProvider({this.defaultTestCode = '123456'});

  final String defaultTestCode;
  String? lastDeliveredCode;
  String? lastPhoneNumber;
  OtpPurpose? lastPurpose;

  @override
  String get name => 'Demo / Academic SMS Provider';

  @override
  OtpMode get mode => OtpMode.demo;

  @override
  Future<bool> sendOtp({
    required String phoneNumber,
    required String rawOtpCode,
    required OtpPurpose purpose,
  }) async {
    lastDeliveredCode = rawOtpCode;
    lastPhoneNumber = phoneNumber;
    lastPurpose = purpose;
    return true;
  }
}

/// Firebase Phone Auth integration hook.
/// Configurable for production Android environments with Google Services.
class FirebasePhoneOtpProvider implements OtpProvider {
  @override
  String get name => 'Firebase Phone Authentication';

  @override
  OtpMode get mode => OtpMode.real;

  @override
  Future<bool> sendOtp({
    required String phoneNumber,
    required String rawOtpCode,
    required OtpPurpose purpose,
  }) async {
    // In production, delegate to FirebaseAuth.instance.verifyPhoneNumber(...)
    return true;
  }
}

/// Yemeni SMS Gateway Provider hook.
/// Connects to telecom aggregators (e.g. Yemen Mobile / Sabafon / YOU HTTP SMS API).
class YemenSmsGatewayProvider implements OtpProvider {
  YemenSmsGatewayProvider({this.apiBaseUrl = 'https://sms-api.yemenpay.local'});

  final String apiBaseUrl;

  @override
  String get name => 'Yemeni SMS Gateway';

  @override
  OtpMode get mode => OtpMode.real;

  @override
  Future<bool> sendOtp({
    required String phoneNumber,
    required String rawOtpCode,
    required OtpPurpose purpose,
  }) async {
    // In production, execute POST $apiBaseUrl/send-sms with signed payload
    return true;
  }
}
