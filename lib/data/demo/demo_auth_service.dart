import '../../core/constants/app_constants.dart';
import '../../core/enums/app_enums.dart';
import '../../core/utils/phone_normalizer.dart';
import '../../core/utils/security_util.dart';
import '../../domain/models/models.dart';
import '../../services/auth/auth_service.dart';
import '../../services/auth/otp_provider.dart';
import '../../services/auth/otp_service.dart';
import '../../services/storage/local_storage_service.dart';
import '../../services/transactions/transaction_service.dart';
import 'demo_seed_data.dart';

/// Full Phase 2 implementation of [AuthService] for Yemen Pay.
/// Enforces phone normalization, password & PIN hashing, session persistence,
/// account status guards, and OTP lifecycle via [OtpService].
class DemoAuthService implements AuthService {
  DemoAuthService({
    required LocalStorageService storage,
    TransactionService? transactionService,
    OtpService? otpService,
  })  : _storage = storage,
        _transactionService = transactionService,
        _otpService = otpService ?? OtpService(provider: DemoOtpProvider()) {
    _initSeedUsers();
  }

  final LocalStorageService _storage;
  final TransactionService? _transactionService;
  final OtpService _otpService;

  Session? _currentSession;
  User? _currentUser;
  bool _initialized = false;

  void _initSeedUsers() {
    _storage.getUser(DemoSeedData.demoUser.id).then((User? existing) {
      if (existing == null) {
        _storage.saveUser(DemoSeedData.demoUser);
        _storage.saveUser(DemoSeedData.demoSuspendedUser);
        _storage.saveUser(DemoSeedData.demoLockedUser);
      }
    });
  }

  Future<void> _ensureLoaded() async {
    if (_initialized) return;
    _initialized = true;

    final User? seed = await _storage.getUser(DemoSeedData.demoUser.id);
    if (seed == null) {
      await _storage.saveUser(DemoSeedData.demoUser);
      await _storage.saveUser(DemoSeedData.demoSuspendedUser);
      await _storage.saveUser(DemoSeedData.demoLockedUser);
    }

    _currentSession = await _storage.getSession();
    if (_currentSession != null && !_currentSession!.isExpired) {
      _currentUser = await _storage.getUser(_currentSession!.userId);
    } else {
      _currentSession = null;
      _currentUser = null;
    }
  }

  @override
  bool get isDemoMode => _otpService.provider.mode == OtpMode.demo;

  @override
  OtpMode get otpMode => _otpService.provider.mode;

  @override
  void setOtpMode(OtpMode mode) {
    if (mode == OtpMode.demo) {
      _otpService.setProvider(DemoOtpProvider());
    } else {
      _otpService.setProvider(FirebasePhoneOtpProvider());
    }
  }

  @override
  Future<Session?> getCurrentSession() async {
    await _ensureLoaded();
    return _currentSession;
  }

  @override
  Future<User?> getCurrentUser() async {
    await _ensureLoaded();
    return _currentUser;
  }

  @override
  Future<OtpSession> sendOtp({
    required String phoneNumber,
    OtpPurpose purpose = OtpPurpose.registration,
  }) async {
    final String? normalized = PhoneNormalizer.normalize(phoneNumber);
    if (normalized == null) {
      throw ArgumentError('رقم الهاتف غير صالح');
    }
    return _otpService.sendOtp(phoneNumber: normalized, purpose: purpose);
  }

  @override
  Future<OtpSession> resendOtp({required String otpSessionId}) async {
    return _otpService.resendOtp(otpSessionId: otpSessionId);
  }

  @override
  Future<OtpSession> verifyOtp({
    required String otpSessionId,
    required String code,
  }) async {
    final OtpVerificationResult res = await _otpService.verifyOtp(
      otpSessionId: otpSessionId,
      code: code,
    );
    if (!res.success || res.session == null) {
      throw StateError(res.errorMessageAr ?? 'فشل التحقق من رمز OTP');
    }
    return res.session!;
  }

  @override
  Future<AuthResult> registerUser({
    required String phoneNumber,
    required String fullName,
    required String password,
    required String pin,
    String? email,
  }) async {
    await _ensureLoaded();
    final String? normalized = PhoneNormalizer.normalize(phoneNumber);
    if (normalized == null) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'رقم الهاتف اليمني غير صالح',
      );
    }

    final User? existing = await _storage.getUserByPhone(normalized);
    if (existing != null) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'رقم الهاتف مسجل مسبقاً، يرجى تسجيل الدخول',
      );
    }

    if (password.length < AppConstants.minPasswordLength) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'كلمة المرور يجب أن لا تقل عن 8 خانات',
      );
    }

    if (pin.length != AppConstants.pinLength) {
      return AuthResult(
        success: false,
        errorMessageAr: 'الرقم السري يجب أن يتكون من ${AppConstants.pinLength} أرقام',
      );
    }

    final DateTime now = DateTime.now();
    final String userId = 'user_${now.millisecondsSinceEpoch}';

    final User newUser = User(
      id: userId,
      fullName: fullName.trim(),
      phoneNumber: normalized,
      email: email?.trim(),
      passwordHash: SecurityUtil.hashWithSalt(password),
      pinHash: SecurityUtil.hashWithSalt(pin),
      role: UserRole.customer,
      status: AccountStatus.active,
      isPhoneVerified: true,
      hasPin: true,
      createdAt: now,
      updatedAt: now,
      lastLoginAt: now,
      isDemoUser: isDemoMode,
    );

    await _storage.saveUser(newUser);

    // Create initial simulated wallet for the new user
    final Wallet newWallet = Wallet(
      walletId: 'YP-YE-${now.millisecondsSinceEpoch.toString().substring(7)}',
      userId: userId,
      primaryCurrency: CurrencyCode.yer,
      balance: 50000,
      availableBalance: 50000,
      pendingBalance: 0,
      status: WalletStatus.active,
      createdAt: now,
      isSimulated: true,
    );
    await _storage.saveWalletSnapshot(newWallet);

    // Create active session
    final Session session = Session(
      sessionId: 'sess_${now.millisecondsSinceEpoch}',
      userId: userId,
      deviceId: 'device_${now.millisecondsSinceEpoch}',
      sessionToken: SecurityUtil.hashWithSalt('token_$userId'),
      issuedAt: now,
      expiresAt: now.add(const Duration(days: 30)),
      isDemoMode: isDemoMode,
      isPinVerified: true,
    );

    await _storage.saveSession(session);
    await _storage.saveAuthToken(session.sessionToken!);

    _currentUser = newUser;
    _currentSession = session;

    return AuthResult(
      success: true,
      user: newUser,
      session: session,
    );
  }

  @override
  Future<AuthResult> loginWithPassword({
    required String phoneNumber,
    required String password,
  }) async {
    await _ensureLoaded();
    final String? normalized = PhoneNormalizer.normalize(phoneNumber);
    if (normalized == null) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'رقم الهاتف غير صالح',
      );
    }

    final User? user = await _storage.getUserByPhone(normalized);
    if (user == null) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'رقم الهاتف غير مسجل في يمن باي',
      );
    }

    // Check Account Status
    final String? statusError = _checkAccountStatus(user.status);
    if (statusError != null) {
      return AuthResult(success: false, errorMessageAr: statusError);
    }

    // Check Password Hash
    final String hashedInput = SecurityUtil.hashWithSalt(password);
    if (user.passwordHash != hashedInput) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'كلمة المرور غير صحيحة',
      );
    }

    return _createAndPersistSession(user);
  }

  @override
  Future<AuthResult> loginWithPin({
    required String phoneNumber,
    required String pin,
  }) async {
    await _ensureLoaded();
    final String? normalized = PhoneNormalizer.normalize(phoneNumber);
    if (normalized == null) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'رقم الهاتف غير صالح',
      );
    }

    final User? user = await _storage.getUserByPhone(normalized);
    if (user == null) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'رقم الهاتف غير مسجل في يمن باي',
      );
    }

    final String? statusError = _checkAccountStatus(user.status);
    if (statusError != null) {
      return AuthResult(success: false, errorMessageAr: statusError);
    }

    final String hashedPin = SecurityUtil.hashWithSalt(pin);
    if (user.pinHash != hashedPin) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'الرقم السري (PIN) غير صحيح',
      );
    }

    return _createAndPersistSession(user);
  }

  @override
  Future<AuthResult> resetPassword({
    required String phoneNumber,
    required String newPassword,
  }) async {
    await _ensureLoaded();
    final String? normalized = PhoneNormalizer.normalize(phoneNumber);
    if (normalized == null) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'رقم الهاتف غير صالح',
      );
    }

    final User? user = await _storage.getUserByPhone(normalized);
    if (user == null) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'المستخدم غير موجود',
      );
    }

    if (newPassword.length < AppConstants.minPasswordLength) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'كلمة المرور يجب أن لا تقل عن 8 خانات',
      );
    }

    final User updated = user.copyWith(
      passwordHash: SecurityUtil.hashWithSalt(newPassword),
      updatedAt: DateTime.now(),
    );
    await _storage.saveUser(updated);

    return AuthResult(success: true, user: updated);
  }

  @override
  Future<AuthResult> resetPin({
    required String phoneNumber,
    required String newPin,
  }) async {
    await _ensureLoaded();
    final String? normalized = PhoneNormalizer.normalize(phoneNumber);
    if (normalized == null) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'رقم الهاتف غير صالح',
      );
    }

    final User? user = await _storage.getUserByPhone(normalized);
    if (user == null) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'المستخدم غير موجود',
      );
    }

    if (newPin.length != AppConstants.pinLength) {
      return AuthResult(
        success: false,
        errorMessageAr: 'الرقم السري يجب أن يتكون من ${AppConstants.pinLength} أرقام',
      );
    }

    final User updated = user.copyWith(
      pinHash: SecurityUtil.hashWithSalt(newPin),
      hasPin: true,
      updatedAt: DateTime.now(),
    );
    await _storage.saveUser(updated);

    return AuthResult(success: true, user: updated);
  }

  @override
  Future<AuthResult> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    await _ensureLoaded();
    final User? user = await _storage.getUser(userId);
    if (user == null) {
      return const AuthResult(success: false, errorMessageAr: 'المستخدم غير موجود');
    }

    if (user.passwordHash != SecurityUtil.hashWithSalt(oldPassword)) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'كلمة المرور الحالية غير صحيحة',
      );
    }

    return resetPassword(
      phoneNumber: user.phoneNumber,
      newPassword: newPassword,
    );
  }

  @override
  Future<AuthResult> changePin({
    required String userId,
    required String oldPin,
    required String newPin,
  }) async {
    await _ensureLoaded();
    final User? user = await _storage.getUser(userId);
    if (user == null) {
      return const AuthResult(success: false, errorMessageAr: 'المستخدم غير موجود');
    }

    if (user.pinHash != SecurityUtil.hashWithSalt(oldPin)) {
      return const AuthResult(
        success: false,
        errorMessageAr: 'الرقم السري الحالي غير صحيح',
      );
    }

    return resetPin(
      phoneNumber: user.phoneNumber,
      newPin: newPin,
    );
  }

  @override
  Future<bool> verifyPin({
    required String userId,
    required String pin,
  }) async {
    await _ensureLoaded();
    final User? user = await _storage.getUser(userId);
    if (user == null) return false;
    return user.pinHash == SecurityUtil.hashWithSalt(pin);
  }

  @override
  Future<bool> verifyBiometric({required String userId}) async => true;

  @override
  Future<void> logout() async {
    await _storage.clearSession();
    await _storage.clearAuthToken();
    _currentSession = null;
    _currentUser = null;
  }

  String? _checkAccountStatus(AccountStatus status) {
    switch (status) {
      case AccountStatus.active:
        return null;
      case AccountStatus.pendingVerification:
        return 'يرجى تأكيد رقم الهاتف أولاً';
      case AccountStatus.suspended:
        return 'حسابك موقوف مؤقتاً، يرجى التواصل مع الدعم.';
      case AccountStatus.locked:
        return 'تم قفل الحساب لأسباب أمنية.';
      case AccountStatus.disabled:
        return 'هذا الحساب غير مفعل.';
    }
  }

  Future<AuthResult> _createAndPersistSession(User user) async {
    final DateTime now = DateTime.now();
    final Session session = Session(
      sessionId: 'sess_${now.millisecondsSinceEpoch}',
      userId: user.id,
      deviceId: 'device_${now.millisecondsSinceEpoch}',
      sessionToken: SecurityUtil.hashWithSalt('token_${user.id}_$now'),
      issuedAt: now,
      expiresAt: now.add(const Duration(days: 30)),
      isDemoMode: isDemoMode,
      isPinVerified: true,
    );

    await _storage.saveSession(session);
    await _storage.saveAuthToken(session.sessionToken!);

    final User updatedUser = user.copyWith(lastLoginAt: now);
    await _storage.saveUser(updatedUser);

    _currentUser = updatedUser;
    _currentSession = session;

    return AuthResult(
      success: true,
      user: updatedUser,
      session: session,
    );
  }
}
