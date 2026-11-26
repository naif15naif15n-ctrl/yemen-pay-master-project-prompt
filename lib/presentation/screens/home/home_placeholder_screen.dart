import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/models/models.dart';
import '../../../state/app_scope.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/demo_mode_banner.dart';
import '../../widgets/quick_action_tile.dart';
import '../../widgets/state_views.dart';
import '../../widgets/transaction_list_tile.dart';

/// Phase 1 Home Dashboard shell displaying greeting, simulated wallet card,
/// quick actions, financial summary preview, and recent simulated transactions.
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({
    super.key,
    required this.onOpenTransactions,
    required this.onOpenWallet,
  });

  final VoidCallback onOpenTransactions;
  final VoidCallback onOpenWallet;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final container = AppScope.of(context);
    final controller = container.walletPreviewController;

    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        if (controller.isLoading) {
          return const LoadingStateView();
        }
        if (controller.failure != null) {
          return ErrorStateView(
            message: controller.failure!
                .localizedMessage(l10n.locale.languageCode),
            onRetry: controller.loadPreview,
          );
        }
        final Wallet? wallet = controller.wallet;
        final User? user = controller.user;
        if (wallet == null || user == null) {
          return EmptyStateView(
            icon: Icons.account_balance_wallet_outlined,
            title: 'لا توجد بيانات محفظة بعد',
            subtitle: 'يرجى تفعيل الوضع التجريبي أو إعادة المحاولة.',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadPreview,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: <Widget>[
              if (container.appController.demoModeEnabled) ...<Widget>[
                const DemoModeBanner(),
                const SizedBox(height: 14),
              ],
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          l10n.text('greeting'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          user.fullName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onOpenWallet,
                child: BalanceCard(
                  wallet: wallet,
                  balanceHidden: controller.balanceHidden,
                  onToggleVisibility: controller.toggleBalanceVisibility,
                ),
              ),
              const SizedBox(height: 20),
              SectionHeader(title: l10n.text('quickActions')),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.08,
                children: <Widget>[
                  QuickActionTile(
                    label: l10n.text('actionSend'),
                    icon: Icons.north_east_rounded,
                    onTap: () => _showPhaseNotice(context, 'إرسال الأموال', 'المرحلة 3'),
                  ),
                  QuickActionTile(
                    label: l10n.text('actionReceive'),
                    icon: Icons.south_west_rounded,
                    onTap: () => _showPhaseNotice(context, 'استلام الأموال', 'المرحلة 3'),
                  ),
                  QuickActionTile(
                    label: l10n.text('actionDeposit'),
                    icon: Icons.add_card_rounded,
                    onTap: () => _showPhaseNotice(context, 'الإيداع عبر الوكيل', 'المرحلة 5'),
                  ),
                  QuickActionTile(
                    label: l10n.text('actionWithdraw'),
                    icon: Icons.payments_outlined,
                    onTap: () => _showPhaseNotice(context, 'السحب النقدي', 'المرحلة 5'),
                  ),
                  QuickActionTile(
                    label: l10n.text('actionScanQr'),
                    icon: Icons.qr_code_scanner_rounded,
                    onTap: () => _showPhaseNotice(context, 'مسح رمز QR', 'المرحلة 4'),
                  ),
                  QuickActionTile(
                    label: l10n.text('actionRequest'),
                    icon: Icons.request_quote_outlined,
                    onTap: () => _showPhaseNotice(context, 'طلب أموال', 'المرحلة 3'),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SectionHeader(title: l10n.text('financialSummary')),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _SummaryMetricCard(
                      title: l10n.text('monthlyIncome'),
                      value: AppFormatters.formatAmount(185000),
                      icon: Icons.trending_up_rounded,
                      accentColor: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryMetricCard(
                      title: l10n.text('monthlyExpenses'),
                      value: AppFormatters.formatAmount(64200),
                      icon: Icons.trending_down_rounded,
                      accentColor: AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SectionHeader(
                title: l10n.text('recentTransactions'),
                actionLabel: l10n.text('viewAll'),
                onActionTap: onOpenTransactions,
              ),
              const SizedBox(height: 10),
              for (final Transaction tx in controller.transactions.take(3)) ...<Widget>[
                TransactionListTile(
                  transaction: tx,
                  onTap: () => _showPhaseNotice(
                    context,
                    'تفاصيل العملية والإيصال الرقمي',
                    'المرحلة 3',
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showPhaseNotice(BuildContext context, String feature, String phase) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature — سيتم تفعيل التدفق التفاعلي في $phase.'),
        ),
      );
  }
}

class _SummaryMetricCard extends StatelessWidget {
  const _SummaryMetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 18, color: accentColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
