import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Error/Empty state view widget
class ErrorView extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ErrorView({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = LucideIcons.alertCircle,
    this.actionLabel,
    this.onAction,
  });

  /// Empty state variant
  factory ErrorView.empty({
    String title = 'Belum ada data',
    String? subtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return ErrorView(
      title: title,
      subtitle: subtitle,
      icon: LucideIcons.inbox,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Network error variant
  factory ErrorView.network({VoidCallback? onRetry}) {
    return ErrorView(
      title: 'Tidak ada koneksi',
      subtitle: 'Periksa koneksi internet dan coba lagi',
      icon: LucideIcons.wifiOff,
      actionLabel: 'Coba Lagi',
      onAction: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContHigh,
                shape: BoxShape.circle,
              ), // non-const BoxDecoration
              child: Icon(icon, size: 48, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(LucideIcons.refreshCw, size: 16),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
