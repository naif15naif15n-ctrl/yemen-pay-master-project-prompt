import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/models.dart';

/// Fintech wallet balance card with gradient surface, visibility toggle,
/// available vs. pending balances, and explicit simulated indicator.
class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.wallet,
    required this.balanceHidden,
    required this.onToggleVisibility,
  });

  final Wallet wallet;
  final bool balanceHidden;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String currency =
        AppFormatters.currencyCodeToString(wallet.primaryCurrency);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.walletCardGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x330B192C),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                l10n.text('totalBalance'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'رصيد محاكاة',
                      style: TextStyle(
                        color: AppColors.goldAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: onToggleVisibility,
                    tooltip: balanceHidden ? 'إظهار الرصيد' : 'إخفاء الرصيد',
                    icon: Icon(
                      balanceHidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            balanceHidden
                ? AppFormatters.maskBalance(currency)
                : AppFormatters.formatAmount(
                    wallet.balance,
                    currencyCode: currency,
                  ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(22),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _BalanceSubMetric(
                    label: l10n.text('availableBalance'),
                    value: balanceHidden
                        ? '••••••'
                        : AppFormatters.formatAmount(
                            wallet.availableBalance,
                            currencyCode: currency,
                          ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BalanceSubMetric(
                    label: l10n.text('pendingBalance'),
                    value: balanceHidden
                        ? '••••••'
                        : AppFormatters.formatAmount(
                            wallet.pendingBalance,
                            currencyCode: currency,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${l10n.text('walletIdLabel')}: ${wallet.walletId}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                currency,
                style: const TextStyle(
                  color: AppColors.goldAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceSubMetric extends StatelessWidget {
  const _BalanceSubMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
