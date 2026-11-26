import '../../core/constants/app_constants.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/security_util.dart';
import '../../domain/models/models.dart';
import 'otp_provider.dart';

/// Result returned from OTP verification.
class OtpVerificationResult {
  const OtpVerificationResult({
    required this.success,
    this.session,
    this.errorMessageAr,
  });

  final bool success;
  final OtpSession? session;
  final String? errorMessageAr;
}

/// Central OTP management service enforcing expiration, cooldown, rate limits, and hashing.
class OtpService {
  OtpService({
    OtpProvider? provider,
    this.expirationSeconds = AppConstants.otpExpirationSeconds,
    this.resendCooldownSeconds = AppConstants.otpRetrySeconds,
    this.maxAttempts = AppConstants.maxOtpAttempts,
  }) : _provider = provider ?? DemoOtpProvider();

  OtpProvider _provider;
  final int expirationSeconds;
  final int resendCooldownSeconds;
  final int maxAttempts;

  final Map<String, OtpSession> _sessions = <String, OtpSession>{};
  final Map<String, String> _plainCodeCacheForDemo = <String, String>{};

  OtpProvider get provider => _provider;
  void setProvider(OtpProvider provider) {
    _provider = provider;
  }

  /// Sends a new OTP code to [phoneNumber] for [purpose].
  Future<OtpSession> sendOtp({
    required String phoneNumber,
    required OtpPurpose purpose,
  }) async {
    final DateTime now = DateTime.now();

    // Check existing active sessions for this phone to enforce cooldown
    for (final OtpSession s in _sessions.values) {
      if (s.phoneNumber == phoneNumber && s.purpose == purpose && !s.canResend) {
        final int remainingSec = s.resendAvailableAt.difference(now).inSeconds;
        throw StateError('يمكنك طلب رمز جديد بعد $remainingSec ثانية');
      }
    }

    final String rawCode = _provider.mode == OtpMode.demo
        ? AppConstants.demoOtpCode
        : SecurityUtil.generateDemoOtp();

    final String otpHash = SecurityUtil.hashWithSalt(rawCode);
    final String sessionId = 'otp_${now.millisecondsSinceEpoch}_${phoneNumber.hashCode}';

    final OtpSession session = OtpSession(
      otpSessionId: sessionId,
      phoneNumber: phoneNumber,
      status: OtpVerificationStatus.sent,
      purpose: purpose,
      otpHash: otpHash,
      createdAt: now,
      expiresAt: now.add(Duration(seconds: expirationSeconds)),
      resendAvailableAt: now.add(Duration(seconds: resendCooldownSeconds)),
      attempts: 0,
      maxAttempts: maxAttempts,
      isDemoMode: _provider.mode == OtpMode.demo,
    );

    _sessions[sessionId] = session;
    _plainCodeCacheForDemo[sessionId] = rawCode;

    await _provider.sendOtp(
      phoneNumber: phoneNumber,
      rawOtpCode: rawCode,
      purpose: purpose,
    );

    return session;
  }

  /// Resends an OTP after cooldown has expired.
  Future<OtpSession> resendOtp({required String otpSessionId}) async {
    final OtpSession? existing = _sessions[otpSessionId];
    if (existing == null) {
      throw StateError('جلسة التحقق غير موجودة');
    }

    final DateTime now = DateTime.now();
    if (!existing.canResend) {
      final int remainingSec = existing.resendAvailableAt.difference(now).inSeconds;
      throw StateError('يمكنك طلب رمز جديد بعد $remainingSec ثانية');
    }

    final String rawCode = _provider.mode == OtpMode.demo
        ? AppConstants.demoOtpCode
        : SecurityUtil.generateDemoOtp();

    final String otpHash = SecurityUtil.hashWithSalt(rawCode);

    final OtpSession updated = existing.copyWith(
      status: OtpVerificationStatus.sent,
      otpHash: otpHash,
      createdAt: now,
      expiresAt: now.add(Duration(seconds: expirationSeconds)),
      resendAvailableAt: now.add(Duration(seconds: resendCooldownSeconds)),
      attempts: 0,
    );

    _sessions[otpSessionId] = updated;
    _plainCodeCacheForDemo[otpSessionId] = rawCode;

    await _provider.sendOtp(
      phoneNumber: existing.phoneNumber,
      rawOtpCode: rawCode,
      purpose: existing.purpose,
    );

    return updated;
  }

  /// Verifies the entered OTP code against the hashed record.
  Future<OtpVerificationResult> verifyOtp({
    required String otpSessionId,
    required String code,
  }) async {
    final OtpSession? existing = _sessions[otpSessionId];
    if (existing == null) {
      return const OtpVerificationResult(
        success: false,
        errorMessageAr: 'جلسة التحقق غير موجودة أو منتهية',
      );
    }

    if (existing.isExpired) {
      final OtpSession expired = existing.copyWith(
        status: OtpVerificationStatus.expired,
      );
      _sessions[otpSessionId] = expired;
      return OtpVerificationResult(
        success: false,
        session: expired,
        errorMessageAr: 'انتهت صلاحية رمز التحقق، يرجى طلب رمز جديد',
      );
    }

    if (existing.hasReachedMaxAttempts) {
      final OtpSession locked = existing.copyWith(
        status: OtpVerificationStatus.maxAttemptsExceeded,
      );
      _sessions[otpSessionId] = locked;
      return OtpVerificationResult(
        success: false,
        session: locked,
        errorMessageAr: 'تم تجاوز عدد المحاولات المسموح بها (5 محاولات)',
      );
    }

    // Verify hash
    final String enteredHash = SecurityUtil.hashWithSalt(code.trim());
    final bool matches = (enteredHash == existing.otpHash) ||
        (_provider.mode == OtpMode.demo && code.trim() == AppConstants.demoOtpCode);

    final int newAttempts = existing.attempts + 1;

    if (matches) {
      final OtpSession verified = existing.copyWith(
        status: OtpVerificationStatus.verified,
        verifiedAt: DateTime.now(),
        attempts: newAttempts,
      );
      _sessions[otpSessionId] = verified;
      return OtpVerificationResult(
        success: true,
        session: verified,
      );
    } else {
      final bool nowLocked = newAttempts >= maxAttempts;
      final OtpSession failed = existing.copyWith(
        status: nowLocked
            ? OtpVerificationStatus.maxAttemptsExceeded
            : OtpVerificationStatus.failed,
        attempts: newAttempts,
      );
      _sessions[otpSessionId] = failed;
      return OtpVerificationResult(
        success: false,
        session: failed,
        errorMessageAr: nowLocked
            ? 'تم تجاوز عدد المحاولات المسموح بها'
            : 'رمز التحقق غير صحيح، متبقي ${maxAttempts - newAttempts} محاولات',
      );
    }
  }

  /// Returns the plain code for educational evaluation in Demo Mode only.
  String? getPlainCodeForDemo(String otpSessionId) {
    if (_provider.mode == OtpMode.demo) {
      return _plainCodeCacheForDemo[otpSessionId] ?? AppConstants.demoOtpCode;
    }
    return null;
  }
}
