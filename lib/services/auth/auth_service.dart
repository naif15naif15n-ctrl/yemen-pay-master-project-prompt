import '../../domain/models/models.dart';

/// Result wrapper for OTP and authentication operations.
class AuthResult {
  const AuthResult({
    required this.success,
    this.session,
    this.user,
    this.errorMessageAr,
  });

  final bool success;
  final Session? session;
  final User? user;
  final String? errorMessageAr;
}

/// Authentication & OTP abstraction.
/// Allows Firebase Phone Auth or any SMS gateway to be plugged in during Phase 2,
/// clearly separated from Demo/Test authentication mode.
abstract interface class AuthService {
  bool get isDemoMode;

  Future<Session?> getCurrentSession();

  Future<User?> getCurrentUser();

  Future<OtpSession> sendOtp({
    required String phoneNumber,
  });

  Future<OtpSession> resendOtp({
    required String otpSessionId,
  });

  Future<OtpSession> verifyOtp({
    required String otpSessionId,
    required String code,
  });

  Future<AuthResult> loginWithPassword({
    required String phoneNumber,
    required String password,
  });

  Future<bool> verifyPin({
    required String userId,
    required String pin,
  });

  Future<bool> verifyBiometric({
    required String userId,
  });

  Future<void> logout();
}
