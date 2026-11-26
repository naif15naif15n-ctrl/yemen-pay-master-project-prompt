import '../../core/enums/app_enums.dart';

/// Role definition for role-based authorization (RBAC).
class Role {
  const Role({
    required this.id,
    required this.type,
    required this.nameAr,
    required this.nameEn,
    this.permissions = const <String>[],
  });

  final String id;
  final UserRole type;
  final String nameAr;
  final String nameEn;
  final List<String> permissions;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type.name,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'permissions': permissions,
      };

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'] as String,
        type: UserRole.values.byName(json['type'] as String),
        nameAr: json['nameAr'] as String,
        nameEn: json['nameEn'] as String,
        permissions: (json['permissions'] as List<dynamic>? ?? <dynamic>[])
            .cast<String>(),
      );
}

/// Core user entity. Passwords and PIN hashes are never stored in plain text.
class User {
  const User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    required this.status,
    required this.createdAt,
    this.email,
    this.passwordHash,
    this.pinHash,
    this.isPhoneVerified = true,
    this.updatedAt,
    this.lastLoginAt,
    this.avatarUrl,
    this.hasPin = false,
    this.biometricEnabled = false,
    this.isDemoUser = false,
  });

  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? passwordHash;
  final String? pinHash;
  final bool isPhoneVerified;
  final UserRole role;
  final AccountStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final String? avatarUrl;
  final bool hasPin;
  final bool biometricEnabled;
  final bool isDemoUser;

  User copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? passwordHash,
    String? pinHash,
    bool? isPhoneVerified,
    UserRole? role,
    AccountStatus? status,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    String? avatarUrl,
    bool? hasPin,
    bool? biometricEnabled,
    bool? isDemoUser,
  }) {
    return User(
      id: id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      pinHash: pinHash ?? this.pinHash,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      hasPin: hasPin ?? this.hasPin,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      isDemoUser: isDemoUser ?? this.isDemoUser,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
        'passwordHash': passwordHash,
        'pinHash': pinHash,
        'isPhoneVerified': isPhoneVerified,
        'role': role.name,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'lastLoginAt': lastLoginAt?.toIso8601String(),
        'avatarUrl': avatarUrl,
        'hasPin': hasPin,
        'biometricEnabled': biometricEnabled,
        'isDemoUser': isDemoUser,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        phoneNumber: json['phoneNumber'] as String,
        email: json['email'] as String?,
        passwordHash: json['passwordHash'] as String?,
        pinHash: json['pinHash'] as String?,
        isPhoneVerified: json['isPhoneVerified'] as bool? ?? true,
        role: UserRole.values.byName(json['role'] as String),
        status: AccountStatus.values.byName(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        lastLoginAt: json['lastLoginAt'] != null
            ? DateTime.parse(json['lastLoginAt'] as String)
            : null,
        avatarUrl: json['avatarUrl'] as String?,
        hasPin: json['hasPin'] as bool? ?? false,
        biometricEnabled: json['biometricEnabled'] as bool? ?? false,
        isDemoUser: json['isDemoUser'] as bool? ?? false,
      );
}

/// Registered device metadata for security, offline tracing, and device management.
class Device {
  const Device({
    required this.id,
    required this.userId,
    required this.deviceName,
    required this.platform,
    required this.lastActiveAt,
    this.isTrusted = false,
  });

  final String id;
  final String userId;
  final String deviceName;
  final String platform;
  final DateTime lastActiveAt;
  final bool isTrusted;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'deviceName': deviceName,
        'platform': platform,
        'lastActiveAt': lastActiveAt.toIso8601String(),
        'isTrusted': isTrusted,
      };

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json['id'] as String,
        userId: json['userId'] as String,
        deviceName: json['deviceName'] as String,
        platform: json['platform'] as String,
        lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
        isTrusted: json['isTrusted'] as bool? ?? false,
      );
}

/// Authenticated user session snapshot with token and revocation tracking.
class Session {
  const Session({
    required this.sessionId,
    required this.userId,
    required this.deviceId,
    required this.issuedAt,
    required this.expiresAt,
    required this.isDemoMode,
    this.sessionToken,
    this.lastActivityAt,
    this.revokedAt,
    this.isPinVerified = false,
  });

  final String sessionId;
  final String userId;
  final String deviceId;
  final String? sessionToken;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final DateTime? lastActivityAt;
  final DateTime? revokedAt;
  final bool isDemoMode;
  final bool isPinVerified;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isRevoked => revokedAt != null;
  bool get isValid => !isExpired && !isRevoked;

  Session copyWith({
    DateTime? expiresAt,
    DateTime? lastActivityAt,
    DateTime? revokedAt,
    bool? isPinVerified,
    String? sessionToken,
  }) {
    return Session(
      sessionId: sessionId,
      userId: userId,
      deviceId: deviceId,
      sessionToken: sessionToken ?? this.sessionToken,
      issuedAt: issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      revokedAt: revokedAt ?? this.revokedAt,
      isDemoMode: isDemoMode,
      isPinVerified: isPinVerified ?? this.isPinVerified,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sessionId': sessionId,
        'userId': userId,
        'deviceId': deviceId,
        'sessionToken': sessionToken,
        'issuedAt': issuedAt.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
        'lastActivityAt': lastActivityAt?.toIso8601String(),
        'revokedAt': revokedAt?.toIso8601String(),
        'isDemoMode': isDemoMode,
        'isPinVerified': isPinVerified,
      };

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        sessionId: json['sessionId'] as String,
        userId: json['userId'] as String,
        deviceId: json['deviceId'] as String,
        sessionToken: json['sessionToken'] as String?,
        issuedAt: DateTime.parse(json['issuedAt'] as String),
        expiresAt: DateTime.parse(json['expiresAt'] as String),
        lastActivityAt: json['lastActivityAt'] != null
            ? DateTime.parse(json['lastActivityAt'] as String)
            : null,
        revokedAt: json['revokedAt'] != null
            ? DateTime.parse(json['revokedAt'] as String)
            : null,
        isDemoMode: json['isDemoMode'] as bool? ?? true,
        isPinVerified: json['isPinVerified'] as bool? ?? false,
      );
}

/// OTP verification session supporting expiration, retry timer, hash, and purpose.
class OtpSession {
  const OtpSession({
    required this.otpSessionId,
    required this.phoneNumber,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    required this.resendAvailableAt,
    this.purpose = OtpPurpose.registration,
    this.otpHash = '',
    this.verifiedAt,
    this.attempts = 0,
    this.maxAttempts = 5,
    this.isDemoMode = false,
  });

  final String otpSessionId;
  final String phoneNumber;
  final OtpVerificationStatus status;
  final OtpPurpose purpose;
  final String otpHash;
  final DateTime? verifiedAt;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime resendAvailableAt;
  final int attempts;
  final int maxAttempts;
  final bool isDemoMode;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get canResend => DateTime.now().isAfter(resendAvailableAt);
  bool get hasReachedMaxAttempts => attempts >= maxAttempts;

  OtpSession copyWith({
    OtpVerificationStatus? status,
    OtpPurpose? purpose,
    String? otpHash,
    DateTime? verifiedAt,
    DateTime? expiresAt,
    DateTime? resendAvailableAt,
    int? attempts,
  }) {
    return OtpSession(
      otpSessionId: otpSessionId,
      phoneNumber: phoneNumber,
      status: status ?? this.status,
      purpose: purpose ?? this.purpose,
      otpHash: otpHash ?? this.otpHash,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      createdAt: createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      resendAvailableAt: resendAvailableAt ?? this.resendAvailableAt,
      attempts: attempts ?? this.attempts,
      maxAttempts: maxAttempts,
      isDemoMode: isDemoMode,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'otpSessionId': otpSessionId,
        'phoneNumber': phoneNumber,
        'status': status.name,
        'purpose': purpose.name,
        'otpHash': otpHash,
        'verifiedAt': verifiedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
        'resendAvailableAt': resendAvailableAt.toIso8601String(),
        'attempts': attempts,
        'maxAttempts': maxAttempts,
        'isDemoMode': isDemoMode,
      };

  factory OtpSession.fromJson(Map<String, dynamic> json) => OtpSession(
        otpSessionId: json['otpSessionId'] as String,
        phoneNumber: json['phoneNumber'] as String,
        status: OtpVerificationStatus.values.byName(json['status'] as String),
        purpose: json['purpose'] != null
            ? OtpPurpose.values.byName(json['purpose'] as String)
            : OtpPurpose.registration,
        otpHash: json['otpHash'] as String? ?? '',
        verifiedAt: json['verifiedAt'] != null
            ? DateTime.parse(json['verifiedAt'] as String)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
        expiresAt: DateTime.parse(json['expiresAt'] as String),
        resendAvailableAt: DateTime.parse(json['resendAvailableAt'] as String),
        attempts: json['attempts'] as int? ?? 0,
        maxAttempts: json['maxAttempts'] as int? ?? 5,
        isDemoMode: json['isDemoMode'] as bool? ?? false,
      );
}
