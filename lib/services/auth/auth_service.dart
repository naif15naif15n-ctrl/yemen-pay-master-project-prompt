import '../../core/enums/app_enums.dart';
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
/// Completely decoupled from UI, allowing Firebase Phone Auth,
/// Yemeni SMS aggregators, or Academic Demo Mode to be plugged in.
abstract interface class AuthService {
  bool get isDemoMode;
  OtpMode get otpMode;
  void setOtpMode(OtpMode mode);

  Future<Session?> getCurrentSession();
  Future<User?> getCurrentUser();

  Future<OtpSession> sendOtp({
    required String phoneNumber,
    required OtpPurpose purpose,
  });

  Future<OtpSession> resendOtp({
    required String otpSessionId,
  });

  Future<OtpSession> verifyOtp({
    required String otpSessionId,
    required String code,
  });

  Future<AuthResult> registerUser({
    required String phoneNumber,
    required String fullName,
    required String password,
    required String pin,
    String? email,
  });

  Future<AuthResult> loginWithPassword({
    required String phoneNumber,
    required String password,
  });

  Future<AuthResult> loginWithPin({
    required String phoneNumber,
    required String pin,
  });

  Future<AuthResult> resetPassword({
    required String phoneNumber,
    required String newPassword,
  });

  Future<AuthResult> resetPin({
    required String phoneNumber,
    required String newPin,
  });

  Future<AuthResult> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });

  Future<AuthResult> changePin({
    required String userId,
    required String oldPin,
    required String newPin,
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
