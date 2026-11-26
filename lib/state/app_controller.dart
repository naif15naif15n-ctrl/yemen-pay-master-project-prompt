import 'package:flutter/material.dart';
import '../services/storage/local_storage_service.dart';

/// Top-level application state controller (theme, locale, onboarding, demo mode).
class AppController extends ChangeNotifier {
  AppController(this._storage);

  final LocalStorageService _storage;

  bool _isInitialized = false;
  bool _onboardingCompleted = false;
  bool _demoModeEnabled = true;
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('ar');

  bool get isInitialized => _isInitialized;
  bool get onboardingCompleted => _onboardingCompleted;
  bool get demoModeEnabled => _demoModeEnabled;
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  Future<void> initialize() async {
    await _storage.initialize();
    _onboardingCompleted = await _storage.getOnboardingCompleted();
    _demoModeEnabled = await _storage.getDemoModeEnabled();

    final String? savedTheme = await _storage.getThemeMode();
    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedTheme == 'system') {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.light;
    }

    final String? savedLocale = await _storage.getLocaleCode();
    _locale = Locale(savedLocale == 'en' ? 'en' : 'ar');

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingCompleted = true;
    await _storage.setOnboardingCompleted(true);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final String value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
    };
    await _storage.setThemeMode(value);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    await _storage.setLocaleCode(newLocale.languageCode);
    notifyListeners();
  }

  Future<void> setDemoMode(bool enabled) async {
    _demoModeEnabled = enabled;
    await _storage.setDemoModeEnabled(enabled);
    notifyListeners();
  }
}
