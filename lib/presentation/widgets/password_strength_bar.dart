import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/security_util.dart';

/// Visual password strength meter tailored for Arabic RTL layout.
class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({
    super.key,
    required this.password,
  });

  final String password;

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    final PasswordStrength strength =
        SecurityUtil.evaluatePasswordStrength(password);

    final _StrengthVisual visual = switch (strength) {
      PasswordStrength.weak => const _StrengthVisual(
          label: 'ضعيفة',
          color: AppColors.error,
          progress: 0.33,
        ),
      PasswordStrength.medium => const _StrengthVisual(
          label: 'متوسطة',
          color: AppColors.warning,
          progress: 0.66,
        ),
      PasswordStrength.strong => const _StrengthVisual(
          label: 'قوية وممتازة',
          color: AppColors.success,
          progress: 1.0,
        ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 6),
        Row(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: visual.progress,
                  minHeight: 5,
                  backgroundColor: Theme.of(context).colorScheme.outline,
                  valueColor: AlwaysStoppedAnimation<Color>(visual.color),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              visual.label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: visual.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'يجب أن تتكون من 8 خانات على الأقل (يفضل خليط من أحرف وأرقام ورموز)',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10.5),
        ),
      ],
    );
  }
}

class _StrengthVisual {
  const _StrengthVisual({
    required this.label,
    required this.color,
    required this.progress,
  });

  final String label;
  final Color color;
  final double progress;
}
