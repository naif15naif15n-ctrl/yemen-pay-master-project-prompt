import 'package:flutter/material.dart';
import '../../core/enums/app_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/models.dart';

/// Clean transaction list item with directional icon, sync status chip, and amount.
class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  final Transaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool isCredit = transaction.type == TransactionType.receive ||
        transaction.type == TransactionType.deposit ||
        transaction.type == TransactionType.refund;

    final Color amountColor = isCredit ? AppColors.success : scheme.onSurface;
    final String sign = isCredit ? '+' : '-';
    final String currency =
        AppFormatters.currencyCodeToString(transaction.currency);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outline),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isCredit
                    ? AppColors.successSoft
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _resolveIcon(transaction.type),
                color: isCredit ? AppColors.success : scheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    isCredit
                        ? transaction.senderName
                        : transaction.receiverName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: <Widget>[
                      Text(
                        _typeLabelAr(transaction.type),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(width: 8),
                      _SyncChip(status: transaction.syncStatus),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '$sign${AppFormatters.formatAmount(transaction.amount, currencyCode: currency)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  AppFormatters.formatShortDate(transaction.timestamp),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _resolveIcon(TransactionType type) {
    switch (type) {
      case TransactionType.receive:
        return Icons.south_west_rounded;
      case TransactionType.transfer:
        return Icons.north_east_rounded;
      case TransactionType.merchantPayment:
      case TransactionType.qrPayment:
        return Icons.qr_code_2_rounded;
      case TransactionType.recharge:
        return Icons.phone_android_rounded;
      case TransactionType.billPayment:
        return Icons.receipt_long_rounded;
      case TransactionType.deposit:
        return Icons.add_circle_outline_rounded;
      case TransactionType.withdrawal:
        return Icons.remove_circle_outline_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }

  String _typeLabelAr(TransactionType type) {
    switch (type) {
      case TransactionType.receive:
        return 'استلام';
      case TransactionType.transfer:
        return 'تحويل';
      case TransactionType.merchantPayment:
        return 'دفع لتاجر';
      case TransactionType.qrPayment:
        return 'دفع QR';
      case TransactionType.recharge:
        return 'شحن رصيد';
      case TransactionType.billPayment:
        return 'سداد فاتورة';
      case TransactionType.deposit:
        return 'إيداع';
      case TransactionType.withdrawal:
        return 'سحب';
      default:
        return 'عملية مالية';
    }
  }
}

class _SyncChip extends StatelessWidget {
  const _SyncChip({required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final bool pending = status == SyncStatus.pending;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: pending ? AppColors.warningSoft : AppColors.emeraldSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        pending ? 'بانتظار المزامنة' : 'متزامنة',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: pending ? AppColors.warning : AppColors.emeraldDeep,
        ),
      ),
    );
  }
}
