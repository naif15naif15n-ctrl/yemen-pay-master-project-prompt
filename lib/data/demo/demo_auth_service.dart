import '../../core/constants/app_constants.dart';
import '../../core/enums/app_enums.dart';
import '../../domain/models/models.dart';
import '../../services/auth/auth_service.dart';
import 'demo_seed_data.dart';

/// Clearly separated Demo/Test implementation of [AuthService].
/// Full OTP / Registration / Login UI flows will be implemented in Phase 2.
class DemoAuthService implements AuthService {
  Session? _currentSession = Session(
    sessionId: 'demo-session-001',
    userId: DemoSeedData.demoUser.id,
    deviceId: 'demo-device-01',
    issuedAt: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(days: 7)),
    isDemoMode: true,
    isPinVerified: true,
  );

  final Map<String, OtpSession> _otpSessions = <String, OtpSession>{};

  @override
  bool get isDemoMode => true;

  @override
  Future<Session?> getCurrentSession() async => _currentSession;

  @override
  Future<User?> getCurrentUser() async =>
      _currentSession == null ? null : DemoSeedData.demoUser;

  @override
  Future<OtpSession> sendOtp({required String phoneNumber}) async {
    final DateTime now = DateTime.now();
    final OtpSession session = OtpSession(
      otpSessionId: 'demo-otp-${now.millisecondsSinceEpoch}',
      phoneNumber: phoneNumber,
      status: OtpVerificationStatus.sent,
      createdAt: now,
      expiresAt: now.add(
        const Duration(seconds: AppConstants.otpExpirationSeconds),
      ),
      resendAvailableAt: now.add(
        const Duration(seconds: AppConstants.otpRetrySeconds),
      ),
      maxAttempts: AppConstants.maxOtpAttempts,
      isDemoMode: true,
    );
    _otpSessions[session.otpSessionId] = session;
    return session;
  }

  @override
  Future<OtpSession> resendOtp({required String otpSessionId}) async {
    final OtpSession? existing = _otpSessions[otpSessionId];
    if (existing == null) {
      throw StateError('Demo OTP session not found');
    }
    final DateTime now = DateTime.now();
    final OtpSession updated = existing.copyWith(
      status: OtpVerificationStatus.sent,
      expiresAt: now.add(
        const Duration(seconds: AppConstants.otpExpirationSeconds),
      ),
      resendAvailableAt: now.add(
        const Duration(seconds: AppConstants.otpRetrySeconds),
      ),
    );
    _otpSessions[otpSessionId] = updated;
    return updated;
  }

  @override
  Future<OtpSession> verifyOtp({
    required String otpSessionId,
    required String code,
  }) async {
    final OtpSession? existing = _otpSessions[otpSessionId];
    if (existing == null) {
      throw StateError('Demo OTP session not found');
    }
    if (existing.isExpired) {
      final OtpSession expired =
          existing.copyWith(status: OtpVerificationStatus.expired);
      _otpSessions[otpSessionId] = expired;
      return expired;
    }
    if (existing.hasReachedMaxAttempts) {
      final OtpSession locked =
          existing.copyWith(status: OtpVerificationStatus.maxAttemptsExceeded);
      _otpSessions[otpSessionId] = locked;
      return locked;
    }
    // Demo mode accepts any 6-digit code matching length for testing purposes.
    final bool validFormat = code.trim().length == AppConstants.otpLength;
    final OtpSession result = existing.copyWith(
      attempts: existing.attempts + 1,
      status: validFormat
          ? OtpVerificationStatus.verified
          : OtpVerificationStatus.failed,
    );
    _otpSessions[otpSessionId] = result;
    return result;
  }

  @override
  Future<AuthResult> loginWithPassword({
    required String phoneNumber,
    required String password,
  }) async {
    final DateTime now = DateTime.now();
    _currentSession = Session(
      sessionId: 'demo-session-${now.millisecondsSinceEpoch}',
      userId: DemoSeedData.demoUser.id,
      deviceId: 'demo-device-01',
      issuedAt: now,
      expiresAt: now.add(const Duration(days: 7)),
      isDemoMode: true,
    );
    return AuthResult(
      success: true,
      session: _currentSession,
      user: DemoSeedData.demoUser,
    );
  }

  @override
  Future<bool> verifyPin({
    required String userId,
    required String pin,
  }) async {
    return pin.trim().length == AppConstants.pinLength;
  }

  @override
  Future<bool> verifyBiometric({required String userId}) async => true;

  @override
  Future<void> logout() async {
    _currentSession = null;
  }
}
