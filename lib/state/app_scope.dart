import 'package:flutter/widgets.dart';
import '../core/di/service_locator.dart';
import 'app_controller.dart';
import 'auth_controller.dart';
import 'connection_controller.dart';
import 'wallet_preview_controller.dart';

/// Holds global controllers and service locator cleanly for the widget tree.
class AppStateContainer {
  AppStateContainer({required this.services})
      : appController = AppController(services.localStorageService),
        authController = AuthController(services.authService),
        connectionController = ConnectionController(
          services.connectionMonitorService,
          services.localStorageService,
        ),
        walletPreviewController = WalletPreviewController(
          services.authService,
          services.transactionService,
        );

  final ServiceLocator services;
  final AppController appController;
  final AuthController authController;
  final ConnectionController connectionController;
  final WalletPreviewController walletPreviewController;

  void dispose() {
    appController.dispose();
    authController.dispose();
    connectionController.dispose();
    walletPreviewController.dispose();
    services.connectionMonitorService.dispose();
  }
}

/// InheritedWidget providing clean read access to [AppStateContainer].
class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.container,
    required super.child,
  });

  final AppStateContainer container;

  static AppStateContainer of(BuildContext context) {
    final AppScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree.');
    return scope!.container;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      container != oldWidget.container;
}
