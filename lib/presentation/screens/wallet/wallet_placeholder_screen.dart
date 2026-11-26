import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/models/models.dart';
import '../../../state/app_scope.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/state_views.dart';

/// Phase 1 Wallet placeholder screen exposing wallet metadata, QR preview card,
/// and Phase 3 architectural readiness.
class WalletPlaceholderScreen extends StatelessWidget {
  const WalletPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final controller = AppScope.of(context).walletPreviewController;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        final Wallet? wallet = controller.wallet;
        if (wallet == null) {
          return const LoadingStateView();
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            BalanceCard(
              wallet: wallet,
              balanceHidden: controller.balanceHidden,
              onToggleVisibility: controller.toggleBalanceVisibility,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: scheme.outline),
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    l10n.text('personalQr'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: scheme.outline),
                    ),
                    child: Icon(
                      Icons.qr_code_2_rounded,
                      size: 96,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${l10n.text('walletIdLabel')}: ${wallet.walletId}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const PhasePlaceholderCard(
              phaseLabel: 'المرحلة 3 و 4',
              title: 'عمليات المحفظة والدفتر المزدوج (Ledger)',
              description:
                  'سيتم تفعيل إرسال الأموال، استلامها، طلبات الدفع، ومسح QR عبر محرك TransactionService الموحد في المراحل القادمة.',
              icon: Icons.account_balance_wallet_outlined,
            ),
          ],
        );
      },
    );
  }
}
