import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// BoxDecoration presets for consistent design patterns
class AppDecorations {
  AppDecorations._();

  // ─── Card Elevated ────────────────────────────────────────
  static BoxDecoration get cardElevated => BoxDecoration(
        color: AppColors.surfaceContHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.1),
        ),
      );

  // ─── Glass Morphism ───────────────────────────────────────
  static BoxDecoration get glass => BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      );

  // ─── Glow Effects ─────────────────────────────────────────
  static BoxDecoration get primaryGlow => BoxDecoration(
        color: AppColors.surfaceContHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      );

  static BoxDecoration get tertiaryGlow => BoxDecoration(
        color: AppColors.surfaceContHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.tertiary.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiary.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      );

  // ─── Selected State ───────────────────────────────────────
  static BoxDecoration get selectedCard => BoxDecoration(
        color: AppColors.surfaceContHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryContainer,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 16,
            spreadRadius: -4,
          ),
        ],
      );

  // ─── Surface Container ────────────────────────────────────
  static BoxDecoration get surfaceContainer => BoxDecoration(
        color: AppColors.surfaceCont,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.1),
        ),
      );

  // ─── Bottom Navigation Shadow ─────────────────────────────
  static BoxDecoration get bottomNav => BoxDecoration(
        color: AppColors.surfaceContLow,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withOpacity(0.15),
          ),
        ),
      );

  // ─── Gradients ────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tertiaryGradient = LinearGradient(
    colors: [AppColors.tertiary, AppColors.tertiaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [AppColors.background, AppColors.surfaceContLow],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ─── Image Filter for Glass ───────────────────────────────
  static ImageFilter get blurFilter => ImageFilter.blur(sigmaX: 10, sigmaY: 10);
}
