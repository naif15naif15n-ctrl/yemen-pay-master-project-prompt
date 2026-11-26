import 'package:flutter/material.dart';

/// Fintech color palette for Yemen Pay (Deep Emerald Green, Dark Navy, Soft Neutrals).
abstract final class AppColors {
  // Brand Primaries
  static const Color emeraldPrimary = Color(0xFF0A6847);
  static const Color emeraldDeep = Color(0xFF064E3B);
  static const Color emeraldLight = Color(0xFF10B981);
  static const Color emeraldSoft = Color(0xFFE6F4EF);

  // Dark Navy Surfaces & Accents
  static const Color navyPrimary = Color(0xFF0B192C);
  static const Color navySecondary = Color(0xFF13294B);
  static const Color navySurface = Color(0xFF10213A);
  static const Color navyBorder = Color(0xFF1E3A5F);

  // Accent Gold (for subtle financial/demo highlights)
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color goldSoft = Color(0xFFFDF6E2);

  // Light Mode Neutrals
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEEF2F6);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Mode Neutrals
  static const Color darkBackground = Color(0xFF07111F);
  static const Color darkSurface = Color(0xFF0E1D33);
  static const Color darkSurfaceVariant = Color(0xFF152844);
  static const Color darkBorder = Color(0xFF1F3859);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Semantic Status Colors
  static const Color success = Color(0xFF16A34A);
  static const Color successSoft = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorSoft = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoSoft = Color(0xFFE0F2FE);

  // Gradients
  static const LinearGradient walletCardGradient = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: <Color>[
      emeraldDeep,
      emeraldPrimary,
      navySecondary,
    ],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      navyPrimary,
      emeraldDeep,
    ],
  );
}
