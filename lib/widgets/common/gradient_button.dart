import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';

/// Button with gradient background (primary or tertiary)
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool useTertiaryGradient;
  final double? width;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.useTertiaryGradient = false,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = useTertiaryGradient
        ? AppDecorations.tertiaryGradient
        : AppDecorations.primaryGradient;

    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              gradient: onPressed == null && !isLoading
                  ? null
                  : gradient,
              color: onPressed == null && !isLoading
                  ? AppColors.surfaceContHighest
                  : null,
              borderRadius: BorderRadius.circular(12),
              boxShadow: onPressed != null && !isLoading
                  ? [
                      BoxShadow(
                        color: (useTertiaryGradient
                                ? AppColors.tertiary
                                : AppColors.primaryContainer)
                            .withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
