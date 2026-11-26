import 'dart:convert';

/// Password strength levels.
enum PasswordStrength {
  weak,
  medium,
  strong,
}

/// Client-side security and hashing helper for Yemen Pay.
/// In production, sensitive password verification occurs on the backend using bcrypt/argon2.
abstract final class SecurityUtil {
  /// Evaluates password strength based on length, digits, letters, and symbols.
  static PasswordStrength evaluatePasswordStrength(String password) {
    if (password.length < 8) {
      return PasswordStrength.weak;
    }

    bool hasLetters = RegExp(r'[a-zA-Z\u0621-\u064A]').hasMatch(password);
    bool hasNumbers = RegExp(r'\d').hasMatch(password);
    bool hasSymbols = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);
    bool hasUpper = RegExp(r'[A-Z]').hasMatch(password);

    int score = 0;
    if (hasLetters) score++;
    if (hasNumbers) score++;
    if (hasSymbols) score++;
    if (hasUpper) score++;

    if (password.length >= 10 && score >= 3) {
      return PasswordStrength.strong;
    } else if (password.length >= 8 && score >= 2) {
      return PasswordStrength.medium;
    }
    return PasswordStrength.weak;
  }

  /// Computes a salted cryptographic-style digest for demo persistence and verification.
  /// Never stores raw plaintext credentials in the local database.
  static String hashWithSalt(String input, {String salt = 'yp_salt_2026'}) {
    final List<int> bytes = utf8.encode('$salt:$input:$salt');
    int h1 = 0x811c9dc5;
    int h2 = 0x55555555;
    for (final int b in bytes) {
      h1 = ((h1 ^ b) * 0x01000193) & 0xFFFFFFFF;
      h2 = ((h2 ^ b) * 0x01000193) & 0xFFFFFFFF;
    }
    final String part1 = h1.toRadixString(16).padLeft(8, '0');
    final String part2 = h2.toRadixString(16).padLeft(8, '0');
    final String combined = '$part1$part2$salt';
    return base64UrlEncode(utf8.encode(combined));
  }

  /// Generates a random or pseudo-random 6-digit OTP code for test/demo purposes.
  static String generateDemoOtp() {
    final int now = DateTime.now().microsecondsSinceEpoch;
    final int code = 100000 + (now % 900000);
    return code.toString();
  }
}
