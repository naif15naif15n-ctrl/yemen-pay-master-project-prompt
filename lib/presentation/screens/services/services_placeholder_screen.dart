import 'package:flutter/material.dart';
import '../../widgets/demo_mode_banner.dart';
import '../../widgets/state_views.dart';

/// Phase 1 Services catalog placeholder grouping all upcoming simulated modules.
class ServicesPlaceholderScreen extends StatelessWidget {
  const ServicesPlaceholderScreen({super.key});

  static const List<_ServiceGroup> _groups = <_ServiceGroup>[
    _ServiceGroup(
      title: 'الوكلاء والتجار والحوالات',
      phase: 'المرحلة 5',
      icon: Icons.storefront_rounded,
      subtitle: 'الإيداع والسحب عبر الوكلاء، بوابة التاجر، والحوالات برقم الأمان.',
    ),
    _ServiceGroup(
      title: 'شحن الرصيد والفواتير والخدمات الرقمية',
      phase: 'المرحلة 6',
      icon: Icons.bolt_rounded,
      subtitle: 'يمن موبايل، يو، سبأفون، واي، كهرباء، مياه، إنترنت، وبطاقات رقمية (محاكاة).',
    ),
    _ServiceGroup(
      title: 'الوضع دون إنترنت والخادم المحلي',
      phase: 'المرحلة 7',
      icon: Icons.router_rounded,
      subtitle: 'العمليات المحددة عبر شبكة Wi-Fi المحلية مع المزامنة التلقائية ومعالجة التعارضات.',
    ),
    _ServiceGroup(
      title: 'التحليل المالي والادخار الذكي',
      phase: 'المرحلة 8',
      icon: Icons.savings_rounded,
      subtitle: 'مؤشر الصحة المالية 0–100، أهداف الادخار، والأسئلة المالية المبنية على القواعد.',
    ),
    _ServiceGroup(
      title: 'الصرافة والذهب الرقمي والأصول الرقمية (تجريبي)',
      phase: 'المرحلة 9',
      icon: Icons.currency_exchange_rounded,
      subtitle: 'محاكاة تعليمية للعملات (YER/USD/SAR) والذهب بالجرام و BTC/ETH/USDT.',
    ),
    _ServiceGroup(
      title: 'لوحة الإدارة والتقارير والشكاوى',
      phase: 'المرحلة 10',
      icon: Icons.admin_panel_settings_outlined,
      subtitle: 'إدارة المستخدمين، سجل التدقيق AuditLog، والشكاوى والأمان.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const DemoModeBanner(),
        const SizedBox(height: 14),
        for (final _ServiceGroup group in _groups) ...<Widget>[
          PhasePlaceholderCard(
            phaseLabel: group.phase,
            title: group.title,
            description: group.subtitle,
            icon: group.icon,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ServiceGroup {
  const _ServiceGroup({
    required this.title,
    required this.phase,
    required this.icon,
    required this.subtitle,
  });

  final String title;
  final String phase;
  final IconData icon;
  final String subtitle;
}
