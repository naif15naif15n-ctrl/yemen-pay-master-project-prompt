import 'package:flutter/material.dart';
import '../../../core/enums/app_enums.dart';
import '../../../domain/models/models.dart';
import '../../../state/app_scope.dart';
import '../../widgets/state_views.dart';
import '../../widgets/transaction_list_tile.dart';

/// Phase 1 Transactions placeholder screen with category filter chips and simulated ledger preview.
class TransactionsPlaceholderScreen extends StatefulWidget {
  const TransactionsPlaceholderScreen({super.key});

  @override
  State<TransactionsPlaceholderScreen> createState() =>
      _TransactionsPlaceholderScreenState();
}

class _TransactionsPlaceholderScreenState
    extends State<TransactionsPlaceholderScreen> {
  TransactionType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context).walletPreviewController;

    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        final List<Transaction> items =
            controller.filterTransactions(_selectedType);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  _buildFilterChip('الكل', null),
                  const SizedBox(width: 8),
                  _buildFilterChip('تحويل', TransactionType.transfer),
                  const SizedBox(width: 8),
                  _buildFilterChip('استلام', TransactionType.receive),
                  const SizedBox(width: 8),
                  _buildFilterChip('دفع لتاجر', TransactionType.merchantPayment),
                  const SizedBox(width: 8),
                  _buildFilterChip('شحن', TransactionType.recharge),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (items.isEmpty)
              const EmptyStateView(
                icon: Icons.receipt_long_outlined,
                title: 'لا توجد عمليات مطابقة',
                subtitle: 'اختر تصنيفًا آخر لعرض السجل التجريبي.',
              )
            else
              for (final Transaction tx in items) ...<Widget>[
                TransactionListTile(transaction: tx),
                const SizedBox(height: 10),
              ],
            const SizedBox(height: 6),
            const PhasePlaceholderCard(
              phaseLabel: 'المرحلة 3 و 7',
              title: 'الإيصالات الرقمية وطابور المزامنة',
              description:
                  'تم تجهيز نماذج Transaction و LedgerEntry و SyncQueueItem لضمان تتبع كل عملية ومنع التكرار عند المزامنة.',
              icon: Icons.sync_rounded,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, TransactionType? type) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedType == type,
      onSelected: (_) => setState(() => _selectedType = type),
    );
  }
}
