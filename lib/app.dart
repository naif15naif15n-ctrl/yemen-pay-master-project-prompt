import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/constants/app_constants.dart';
import 'core/di/service_locator.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/navigation/main_navigation_shell.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'state/app_scope.dart';

enum _StartupStage { splash, onboarding, main }

/// Root Yemen Pay application widget wiring Arabic RTL localization,
/// Light/Dark Material 3 themes, and Phase 1 startup flow.
class YemenPayApp extends StatefulWidget {
  const YemenPayApp({
    super.key,
    this.serviceLocator,
    this.splashDelay = const Duration(milliseconds: 1200),
  });

  final ServiceLocator? serviceLocator;
  final Duration splashDelay;

  @override
  State<YemenPayApp> createState() => _YemenPayAppState();
}

class _YemenPayAppState extends State<YemenPayApp> {
  late final AppStateContainer _container;
  _StartupStage _stage = _StartupStage.splash;

  @override
  void initState() {
    super.initState();
    _container = AppStateContainer(
      services: widget.serviceLocator ?? ServiceLocator(),
    );
  }

  @override
  void dispose() {
    _container.dispose();
    super.dispose();
  }

  void _handleSplashComplete() {
    final bool done = _container.appController.onboardingCompleted;
    setState(() {
      _stage = done ? _StartupStage.main : _StartupStage.onboarding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      container: _container,
      child: ListenableBuilder(
        listenable: _container.appController,
        builder: (BuildContext context, _) {
          final appController = _container.appController;

          return MaterialApp(
            title: AppConstants.fullBrandTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: appController.themeMode,
            locale: appController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (BuildContext context, Widget? child) {
              final AppLocalizations l10n = AppLocalizations.of(context);
              return Directionality(
                textDirection: l10n.textDirection,
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: switch (_stage) {
              _StartupStage.splash => SplashScreen(
                  splashDelay: widget.splashDelay,
                  onReady: _handleSplashComplete,
                ),
              _StartupStage.onboarding => OnboardingScreen(
                  onFinished: () {
                    setState(() => _stage = _StartupStage.main);
                  },
                ),
              _StartupStage.main => const MainNavigationShell(),
            },
          );
        },
      ),
    );
  }
}
