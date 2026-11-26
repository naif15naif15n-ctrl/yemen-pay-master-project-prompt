/// Utility for normalizing, validating, and formatting Yemeni phone numbers.
abstract final class PhoneNormalizer {
  /// Converts Eastern Arabic numerals (٠-٩) to Western Arabic digits (0-9).
  static String toAsciiDigits(String input) {
    const String eastern = '٠١٢٣٤٥٦٧٨٩';
    const String western = '0123456789';
    String result = input;
    for (int i = 0; i < eastern.length; i++) {
      result = result.replaceAll(eastern[i], western[i]);
    }
    return result;
  }

  /// Normalizes any Yemeni phone number format into canonical `+967XXXXXXXXX`.
  /// Handles inputs like:
  /// - `771234567`
  /// - `0771234567`
  /// - `+967771234567`
  /// - `00967771234567`
  /// - `967771234567`
  static String? normalize(String rawInput) {
    String cleaned = toAsciiDigits(rawInput.trim())
        .replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (cleaned.isEmpty) {
      return null;
    }

    if (cleaned.startsWith('00967')) {
      cleaned = '+967${cleaned.substring(5)}';
    } else if (cleaned.startsWith('967')) {
      cleaned = '+$cleaned';
    } else if (cleaned.startsWith('07')) {
      cleaned = '+967${cleaned.substring(1)}';
    } else if (cleaned.startsWith('7') && cleaned.length == 9) {
      cleaned = '+967$cleaned';
    }

    if (isValid(cleaned)) {
      return cleaned;
    }
    return null;
  }

  /// Checks if the normalized string matches valid Yemeni mobile numbers:
  /// `+967` followed by `7` and 8 digits (total 9 local digits).
  static bool isValid(String normalizedPhone) {
    final RegExp yemenRegex = RegExp(r'^\+9677[01378]\d{7}$');
    return yemenRegex.hasMatch(normalizedPhone);
  }

  /// Validates raw user input and returns a clear Arabic error message if invalid.
  static String? validateInput(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    final String? normalized = normalize(input);
    if (normalized == null || !isValid(normalized)) {
      return 'رقم الهاتف اليمني غير صالح (يجب أن يبدأ بـ 7 ويتكون من 9 أرقام)';
    }
    return null;
  }

  /// Masks phone number for secure display in OTP screens, e.g.:
  /// `+967 77*****84`
  static String maskPhone(String phone) {
    final String? normalized = normalize(phone);
    if (normalized == null || normalized.length < 13) {
      return phone;
    }
    // +967 77 ***** 84
    final String country = normalized.substring(0, 5); // +9677
    final String prefix = normalized.substring(5, 7);  // second digit
    final String suffix = normalized.substring(normalized.length - 2);
    return '$country$prefix*****$suffix';
  }
}
