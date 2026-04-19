import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

/// Shimmer loading skeleton placeholder
class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerPlaceholder({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceContHigh,
      highlightColor: AppColors.surfaceContHighest,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceContHigh,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Card-shaped shimmer
  static Widget card({double height = 120}) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceContHigh,
      highlightColor: AppColors.surfaceContHighest,
      child: Container(
        height: height,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContHigh,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// List of shimmer cards
  static Widget list({int count = 3, double cardHeight = 100}) {
    return Column(
      children: List.generate(
        count,
        (_) => card(height: cardHeight),
      ),
    );
  }
}
