import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Light and Dark Material 3 theme definitions for Yemen Pay.
abstract final class AppTheme {
  static ThemeData light() {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.emeraldPrimary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.emeraldSoft,
      onPrimaryContainer: AppColors.emeraldDeep,
      secondary: AppColors.navyPrimary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.lightSurfaceVariant,
      onSecondaryContainer: AppColors.navyPrimary,
      tertiary: AppColors.goldAccent,
      onTertiary: AppColors.navyPrimary,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: AppColors.lightBorder,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightSurface,
      dividerColor: AppColors.lightBorder,
      textTheme: AppTypography.buildTextTheme(
        primaryTextColor: AppColors.lightTextPrimary,
        secondaryTextColor: AppColors.lightTextSecondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.emeraldSoft,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        labelTextStyle: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          final bool selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected
                ? AppColors.emeraldPrimary
                : AppColors.lightTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          final bool selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? AppColors.emeraldPrimary
                : AppColors.lightTextSecondary,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.emeraldPrimary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emeraldPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.emeraldPrimary,
          side: const BorderSide(color: AppColors.emeraldPrimary),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  static ThemeData dark() {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.emeraldLight,
      onPrimary: AppColors.navyPrimary,
      primaryContainer: AppColors.emeraldDeep,
      onPrimaryContainer: AppColors.emeraldSoft,
      secondary: AppColors.navySecondary,
      onSecondary: AppColors.darkTextPrimary,
      secondaryContainer: AppColors.darkSurfaceVariant,
      onSecondaryContainer: AppColors.darkTextPrimary,
      tertiary: AppColors.goldAccent,
      onTertiary: AppColors.navyPrimary,
      error: Color(0xFFF87171),
      onError: AppColors.navyPrimary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorder,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkBorder,
      textTheme: AppTypography.buildTextTheme(
        primaryTextColor: AppColors.darkTextPrimary,
        secondaryTextColor: AppColors.darkTextSecondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.emeraldDeep,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        labelTextStyle: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          final bool selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected
                ? AppColors.emeraldLight
                : AppColors.darkTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          final bool selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? AppColors.emeraldLight
                : AppColors.darkTextSecondary,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.emeraldLight, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emeraldLight,
          foregroundColor: AppColors.navyPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.emeraldLight,
          side: const BorderSide(color: AppColors.emeraldLight),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
