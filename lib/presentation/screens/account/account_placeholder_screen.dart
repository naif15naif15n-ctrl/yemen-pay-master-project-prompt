import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/enums/app_enums.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/models/models.dart';
import '../../../state/app_scope.dart';
import '../../widgets/state_views.dart';

/// Phase 1 Account & Settings screen featuring Theme switcher (Light/Dark),
/// Localization readiness info, Demo Mode switch, and Connectivity simulator.
class AccountPlaceholderScreen extends StatelessWidget {
  const AccountPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final container = AppScope.of(context);
    final appController = container.appController;
    final connectionController = container.connectionController;
    final User? user = container.walletPreviewController.user;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[
        appController,
        connectionController,
      ]),
      builder: (BuildContext context, _) {
        final bool isDark = appController.themeMode == ThemeMode.dark;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: scheme.outline),
              ),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(
                      Icons.person_rounded,
                      size: 30,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          user?.fullName ?? 'مستخدم تجريبي',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.phoneNumber ?? '+967771234567',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: scheme.outline),
              ),
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    title: Text(l10n.text('darkMode')),
                    subtitle: Text(l10n.text('themeMode')),
                    secondary: const Icon(Icons.dark_mode_outlined),
                    value: isDark,
                    onChanged: appController.toggleDarkMode,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l10n.text('demoModeTitle')),
                    subtitle: const Text('إظهار شارة الوضع التجريبي والتنبيه التعليمي'),
                    secondary: const Icon(Icons.science_outlined),
                    value: appController.demoModeEnabled,
                    onChanged: appController.setDemoMode,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language_rounded),
                    title: Text(l10n.text('languageLabel')),
                    subtitle: Text(
                      '${l10n.text('arabicLanguage')} • ${l10n.text('englishReady')}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: scheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.text('connectionSimulatorTitle'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      _ConnectionChoiceChip(
                        label: l10n.text('statusOnline'),
                        selected: connectionController.status ==
                            ConnectionStatus.internetAvailable,
                        onSelected: () => connectionController.simulateStatus(
                          ConnectionStatus.internetAvailable,
                        ),
                      ),
                      _ConnectionChoiceChip(
                        label: l10n.text('statusLocalServer'),
                        selected: connectionController.status ==
                            ConnectionStatus.localServerAvailable,
                        onSelected: () => connectionController.simulateStatus(
                          ConnectionStatus.localServerAvailable,
                        ),
                      ),
                      _ConnectionChoiceChip(
                        label: l10n.text('statusOffline'),
                        selected: connectionController.status ==
                            ConnectionStatus.fullyOffline,
                        onSelected: () => connectionController.simulateStatus(
                          ConnectionStatus.fullyOffline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PhasePlaceholderCard(
              phaseLabel: 'المرحلة 2 و 10',
              title: l10n.text('academicDisclaimerTitle'),
              description: AppConstants.academicNoticeAr,
              icon: Icons.verified_user_outlined,
            ),
          ],
        );
      },
    );
  }
}

class _ConnectionChoiceChip extends StatelessWidget {
  const _ConnectionChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}
