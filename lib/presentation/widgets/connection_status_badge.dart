import 'package:flutter/material.dart';
import '../../core/enums/app_enums.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';

/// Displays the live connectivity state (Internet, Local Wi-Fi Server, or Offline).
class ConnectionStatusBadge extends StatelessWidget {
  const ConnectionStatusBadge({
    super.key,
    required this.status,
    this.onTap,
  });

  final ConnectionStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final _StatusVisual visual = _resolveVisual(status, l10n);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: visual.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: visual.foreground.withAlpha(70)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(visual.icon, size: 14, color: visual.foreground),
            const SizedBox(width: 5),
            Text(
              visual.label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: visual.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _StatusVisual _resolveVisual(
    ConnectionStatus status,
    AppLocalizations l10n,
  ) {
    switch (status) {
      case ConnectionStatus.internetAvailable:
        return _StatusVisual(
          label: l10n.text('statusOnline'),
          icon: Icons.wifi_rounded,
          foreground: AppColors.success,
          background: AppColors.successSoft,
        );
      case ConnectionStatus.localServerAvailable:
        return _StatusVisual(
          label: l10n.text('statusLocalServer'),
          icon: Icons.router_rounded,
          foreground: AppColors.info,
          background: AppColors.infoSoft,
        );
      case ConnectionStatus.localWifiConnected:
        return _StatusVisual(
          label: l10n.text('statusLocalWifi'),
          icon: Icons.lan_outlined,
          foreground: AppColors.warning,
          background: AppColors.warningSoft,
        );
      case ConnectionStatus.internetUnavailable:
        return _StatusVisual(
          label: l10n.text('statusInternetUnavailable'),
          icon: Icons.signal_wifi_bad_rounded,
          foreground: AppColors.warning,
          background: AppColors.warningSoft,
        );
      case ConnectionStatus.fullyOffline:
        return _StatusVisual(
          label: l10n.text('statusOffline'),
          icon: Icons.cloud_off_rounded,
          foreground: AppColors.error,
          background: AppColors.errorSoft,
        );
    }
  }
}

class _StatusVisual {
  const _StatusVisual({
    required this.label,
    required this.icon,
    required this.foreground,
    required this.background,
  });

  final String label;
  final IconData icon;
  final Color foreground;
  final Color background;
}
