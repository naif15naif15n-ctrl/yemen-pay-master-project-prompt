import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Custom Yemen Pay fintech emblem and bilingual wordmark.
class YemenPayLogo extends StatelessWidget {
  const YemenPayLogo({
    super.key,
    this.size = 56,
    this.showText = true,
    this.lightText = false,
  });

  final double size;
  final bool showText;
  final bool lightText;

  @override
  Widget build(BuildContext context) {
    final Color titleColor = lightText
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;
    final Color subtitleColor = lightText
        ? Colors.white70
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppColors.walletCardGradient,
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x33064E3B),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: size * 0.5,
              ),
              Positioned(
                bottom: size * 0.14,
                right: size * 0.14,
                child: Container(
                  width: size * 0.22,
                  height: size * 0.22,
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showText) ...<Widget>[
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'يمن باي',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(
                'Yemen Pay',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: subtitleColor,
                      letterSpacing: 0.6,
                    ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
