import 'package:flutter/material.dart';

/// Color constants matching Web MD3 dark mode palette
class AppColors {
  AppColors._();

  // ─── Background & Surface ─────────────────────────────────
  static const Color background = Color(0xFF0B1326);
  static const Color surface = Color(0xFF0B1326);
  static const Color surfaceContLow = Color(0xFF131B2E);
  static const Color surfaceCont = Color(0xFF171F33);
  static const Color surfaceContHigh = Color(0xFF222A3D);
  static const Color surfaceContHighest = Color(0xFF2D3449);

  // ─── Primary ──────────────────────────────────────────────
  static const Color primary = Color(0xFFADC6FF);
  static const Color primaryContainer = Color(0xFF4D8EFF);
  static const Color onPrimary = Color(0xFF002E6A);
  static const Color onPrimaryContainer = Color(0xFF00285D);

  // ─── Tertiary (Green) ─────────────────────────────────────
  static const Color tertiary = Color(0xFF4AE176);
  static const Color tertiaryContainer = Color(0xFF00A74B);
  static const Color onTertiary = Color(0xFF003915);

  // ─── Secondary ────────────────────────────────────────────
  static const Color secondary = Color(0xFFB9C7DF);
  static const Color secondaryContainer = Color(0xFF3C4A5E);

  // ─── On Surface ───────────────────────────────────────────
  static const Color onSurface = Color(0xFFDAE2FD);
  static const Color onSurfaceVariant = Color(0xFFC2C6D6);

  // ─── Outline ──────────────────────────────────────────────
  static const Color outlineVariant = Color(0xFF424754);
  static const Color outline = Color(0xFF8C909F);

  // ─── Error ────────────────────────────────────────────────
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);

  // ─── Status Colors ────────────────────────────────────────
  static const Color statusPending = Color(0xFFFFC107);
  static const Color statusConfirmed = Color(0xFF4D8EFF);
  static const Color statusInProgress = Color(0xFF4AE176);
  static const Color statusCompleted = Color(0xFF00A74B);
  static const Color statusCancelled = Color(0xFFFFB4AB);
}
