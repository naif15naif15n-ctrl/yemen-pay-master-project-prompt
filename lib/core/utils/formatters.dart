import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../enums/app_enums.dart';

/// Formatting and validation helpers used across presentation and domain layers.
abstract final class AppFormatters {
  static String formatAmount(
    double amount, {
    String currencyCode = 'YER',
    bool includeSymbol = true,
  }) {
    final NumberFormat formatter = NumberFormat('#,##0.##', 'en_US');
    final String formatted = formatter.format(amount);
    if (!includeSymbol) {
      return formatted;
    }
    return '$formatted ${currencyLabelAr(currencyCode)}';
  }

  static String currencyLabelAr(String code) {
    switch (code.toUpperCase()) {
      case 'USD':
        return 'دولار';
      case 'SAR':
        return 'ر.س';
      case 'YER':
      default:
        return 'ر.ي';
    }
  }

  static String currencyCodeToString(CurrencyCode code) {
    switch (code) {
      case CurrencyCode.yer:
        return 'YER';
      case CurrencyCode.usd:
        return 'USD';
      case CurrencyCode.sar:
        return 'SAR';
    }
  }

  static bool isValidYemenPhone(String phone) {
    return AppConstants.yemenPhoneRegex.hasMatch(phone.trim());
  }

  static String maskBalance(String currencyCode) {
    return '•••••• ${currencyLabelAr(currencyCode)}';
  }

  static String formatShortDate(DateTime dateTime) {
    final String year = dateTime.year.toString();
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String day = dateTime.day.toString().padLeft(2, '0');
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$year/$month/$day • $hour:$minute';
  }
}
