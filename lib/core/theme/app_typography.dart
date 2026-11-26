import 'package:flutter/material.dart';

/// Typography scale tailored for Arabic RTL readability and modern fintech hierarchy.
abstract final class AppTypography {
  static TextTheme buildTextTheme({
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        height: 1.25,
        color: primaryTextColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: primaryTextColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.35,
        color: primaryTextColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: primaryTextColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: primaryTextColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondaryTextColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: primaryTextColor,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: secondaryTextColor,
      ),
    );
  }
}
