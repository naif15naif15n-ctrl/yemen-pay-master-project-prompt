import 'package:flutter/material.dart';
import '../../../core/enums/app_enums.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../state/app_scope.dart';
import '../../widgets/connection_status_badge.dart';
import '../../widgets/demo_mode_banner.dart';
import '../../widgets/yemen_pay_logo.dart';
import '../account/account_placeholder_screen.dart';
import '../home/home_placeholder_screen.dart';
import '../notifications/notifications_placeholder_screen.dart';
import '../services/services_placeholder_screen.dart';
import '../transactions/transactions_placeholder_screen.dart';
import '../wallet/wallet_placeholder_screen.dart';

/// Primary 5-tab navigation shell (`الرئيسية`, `المحفظة`, `العمليات`, `الخدمات`, `الحساب`)
/// with global notifications bell, connection status badge, and Demo badge.
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final container = AppScope.of(context);

    final List<Widget> pages = <Widget>[
      HomePlaceholderScreen(
        onOpenTransactions: () => setState(() => _selectedIndex = 2),
        onOpenWallet: () => setState(() => _selectedIndex = 1),
      ),
      const WalletPlaceholderScreen(),
      const TransactionsPlaceholderScreen(),
      const ServicesPlaceholderScreen(),
      const AccountPlaceholderScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const YemenPayLogo(size: 36, showText: true),
        actions: <Widget>[
          ListenableBuilder(
            listenable: container.appController,
            builder: (BuildContext context, _) {
              if (!container.appController.demoModeEnabled) {
                return const SizedBox.shrink();
              }
              return const Padding(
                padding: EdgeInsetsDirectional.only(end: 6),
                child: DemoModeBanner(compact: true),
              );
            },
          ),
          ListenableBuilder(
            listenable: container.connectionController,
            builder: (BuildContext context, _) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 4),
                child: ConnectionStatusBadge(
                  status: container.connectionController.status,
                  onTap: () => _showConnectionSimulatorSheet(context),
                ),
              );
            },
          ),
          ListenableBuilder(
            listenable: container.walletPreviewController,
            builder: (BuildContext context, _) {
              final int unread =
                  container.walletPreviewController.unreadNotificationCount;
              return IconButton(
                tooltip: l10n.text('notificationsTitle'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const NotificationsPlaceholderScreen(),
                    ),
                  );
                },
                icon: Badge(
                  isLabelVisible: unread > 0,
                  label: Text('$unread'),
                  child: const Icon(Icons.notifications_none_rounded),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int idx) {
          setState(() => _selectedIndex = idx);
        },
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: l10n.text('navHome'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet_rounded),
            label: l10n.text('navWallet'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long_rounded),
            label: l10n.text('navTransactions'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(Icons.grid_view_rounded),
            label: l10n.text('navServices'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.text('navAccount'),
          ),
        ],
      ),
    );
  }

  void _showConnectionSimulatorSheet(BuildContext context) {
    final connectionController = AppScope.of(context).connectionController;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'محاكاة حالة الاتصال (المرحلة 1)',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'تتيح لك هذه الأداة معاينة سلوك شارة الاتصال وبنية Offline-First قبل ربط خادم الشبكة المحلية في المرحلة 7.',
                style: Theme.of(ctx).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              for (final ConnectionStatus s in ConnectionStatus.values)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_connectionLabel(s)),
                  trailing: connectionController.status == s
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: Theme.of(ctx).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    connectionController.simulateStatus(s);
                    Navigator.of(ctx).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  String _connectionLabel(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.internetAvailable:
        return 'متصل بالإنترنت (الوضع السحابي)';
      case ConnectionStatus.localServerAvailable:
        return 'وضع الشبكة المحلية (خادم محلي عبر TP-Link)';
      case ConnectionStatus.localWifiConnected:
        return 'متصل بشبكة Wi-Fi محلية (جاري فحص الخادم)';
      case ConnectionStatus.internetUnavailable:
        return 'الإنترنت غير متاح';
      case ConnectionStatus.fullyOffline:
        return 'غير متصل بالكامل';
    }
  }
}
