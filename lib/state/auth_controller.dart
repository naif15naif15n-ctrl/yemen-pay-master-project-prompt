import 'package:flutter/foundation.dart';
import '../core/enums/app_enums.dart';
import '../core/utils/phone_normalizer.dart';
import '../domain/models/models.dart';
import '../services/auth/auth_service.dart';

/// Central authentication state controller.
/// Manages user registration, phone OTP verification, login,
/// session lifecycle, password/PIN reset, and route protection.
class AuthController extends ChangeNotifier {
  AuthController(this._authService);

  final AuthService _authService;

  AuthState _state = AuthState.initial;
  User? _user;
  Session? _session;
  String? _errorMessage;
  bool _isLoading = false;

  OtpSession? _activeOtpSession;
  String? _pendingPhone;
  String? _pendingResetPhone;

  AuthState get state => _state;
  User? get user => _user;
  Session? get session => _session;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _state == AuthState.authenticated && _user != null;
  OtpSession? get activeOtpSession => _activeOtpSession;
  String? get pendingPhone => _pendingPhone;
  bool get isDemoMode => _authService.isDemoMode;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Checks whether an active, valid session exists on app startup.
  Future<void> checkInitialSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final Session? currentSession = await _authService.getCurrentSession();
      if (currentSession != null && !currentSession.isExpired) {
        final User? currentUser = await _authService.getCurrentUser();
        if (currentUser != null && currentUser.status == AccountStatus.active) {
          _session = currentSession;
          _user = currentUser;
          _state = AuthState.authenticated;
        } else {
          _session = null;
          _user = null;
          _state = AuthState.unauthenticated;
        }
      } else {
        _session = null;
        _user = null;
        _state = AuthState.unauthenticated;
      }
    } catch (_) {
      _state = AuthState.unauthenticated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sends OTP for new account registration.
  Future<bool> sendRegistrationOtp(String rawPhone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final String? normalized = PhoneNormalizer.normalize(rawPhone);
    if (normalized == null) {
      _isLoading = false;
      _errorMessage = 'رقم الهاتف اليمني غير صالح';
      notifyListeners();
      return false;
    }

    try {
      final OtpSession otp = await _authService.sendOtp(
        phoneNumber: normalized,
        purpose: OtpPurpose.registration,
      );
      _activeOtpSession = otp;
      _pendingPhone = normalized;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '').replaceFirst('StateError: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Resends active OTP.
  Future<bool> resendActiveOtp() async {
    if (_activeOtpSession == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final OtpSession refreshed = await _authService.resendOtp(
        otpSessionId: _activeOtpSession!.otpSessionId,
      );
      _activeOtpSession = refreshed;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '').replaceFirst('StateError: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Verifies OTP for the active session.
  Future<bool> verifyOtp(String code) async {
    if (_activeOtpSession == null) {
      _errorMessage = 'لا توجد جلسة تحقق نشطة';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final OtpSession verified = await _authService.verifyOtp(
        otpSessionId: _activeOtpSession!.otpSessionId,
        code: code,
      );
      _activeOtpSession = verified;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '').replaceFirst('StateError: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Completes registration after phone OTP verification.
  Future<bool> completeRegistration({
    required String fullName,
    required String password,
    required String pin,
    String? email,
  }) async {
    if (_pendingPhone == null) {
      _errorMessage = 'رقم الهاتف غير محدد';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final AuthResult res = await _authService.registerUser(
      phoneNumber: _pendingPhone!,
      fullName: fullName,
      password: password,
      pin: pin,
      email: email,
    );

    _isLoading = false;
    if (res.success && res.user != null) {
      _user = res.user;
      _session = res.session;
      _state = AuthState.authenticated;
      _pendingPhone = null;
      _activeOtpSession = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = res.errorMessageAr ?? 'فشل إنشاء الحساب';
      notifyListeners();
      return false;
    }
  }

  /// Logs in with phone number and password.
  Future<bool> login({
    required String phoneNumber,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final AuthResult res = await _authService.loginWithPassword(
      phoneNumber: phoneNumber,
      password: password,
    );

    _isLoading = false;
    if (res.success && res.user != null) {
      _user = res.user;
      _session = res.session;
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } else {
      _errorMessage = res.errorMessageAr ?? 'فشل تسجيل الدخول';
      notifyListeners();
      return false;
    }
  }

  /// Logs in with phone number and 6-digit PIN.
  Future<bool> loginWithPin({
    required String phoneNumber,
    required String pin,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final AuthResult res = await _authService.loginWithPin(
      phoneNumber: phoneNumber,
      pin: pin,
    );

    _isLoading = false;
    if (res.success && res.user != null) {
      _user = res.user;
      _session = res.session;
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } else {
      _errorMessage = res.errorMessageAr ?? 'فشل تسجيل الدخول بالرقم السري';
      notifyListeners();
      return false;
    }
  }

  /// Initiates password reset by sending an OTP to the registered phone.
  Future<bool> sendPasswordResetOtp(String rawPhone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final String? normalized = PhoneNormalizer.normalize(rawPhone);
    if (normalized == null) {
      _isLoading = false;
      _errorMessage = 'رقم الهاتف غير صالح';
      notifyListeners();
      return false;
    }

    try {
      final OtpSession otp = await _authService.sendOtp(
        phoneNumber: normalized,
        purpose: OtpPurpose.resetPassword,
      );
      _activeOtpSession = otp;
      _pendingResetPhone = normalized;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '').replaceFirst('StateError: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Confirms password reset with new password after OTP verification.
  Future<bool> resetPassword(String newPassword) async {
    if (_pendingResetPhone == null) {
      _errorMessage = 'رقم الهاتف غير محدد';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final AuthResult res = await _authService.resetPassword(
      phoneNumber: _pendingResetPhone!,
      newPassword: newPassword,
    );

    _isLoading = false;
    if (res.success) {
      _pendingResetPhone = null;
      _activeOtpSession = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = res.errorMessageAr ?? 'فشل تغيير كلمة المرور';
      notifyListeners();
      return false;
    }
  }

  /// Initiates PIN reset by sending an OTP.
  Future<bool> sendPinResetOtp(String rawPhone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final String? normalized = PhoneNormalizer.normalize(rawPhone);
    if (normalized == null) {
      _isLoading = false;
      _errorMessage = 'رقم الهاتف غير صالح';
      notifyListeners();
      return false;
    }

    try {
      final OtpSession otp = await _authService.sendOtp(
        phoneNumber: normalized,
        purpose: OtpPurpose.resetPin,
      );
      _activeOtpSession = otp;
      _pendingResetPhone = normalized;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '').replaceFirst('StateError: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Confirms PIN reset with new 6-digit PIN after OTP verification.
  Future<bool> resetPin(String newPin) async {
    if (_pendingResetPhone == null) {
      _errorMessage = 'رقم الهاتف غير محدد';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final AuthResult res = await _authService.resetPin(
      phoneNumber: _pendingResetPhone!,
      newPin: newPin,
    );

    _isLoading = false;
    if (res.success) {
      _pendingResetPhone = null;
      _activeOtpSession = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = res.errorMessageAr ?? 'فشل تغيير الرقم السري';
      notifyListeners();
      return false;
    }
  }

  /// Logs out user, clears session and cached tokens.
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();

    _user = null;
    _session = null;
    _activeOtpSession = null;
    _state = AuthState.unauthenticated;
    _isLoading = false;
    notifyListeners();
  }
}
