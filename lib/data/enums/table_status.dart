import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Table status enum matching backend
enum TableStatus {
  available('available', 'TERSEDIA', AppColors.statusCompleted),
  booked('booked', 'DIPESAN', AppColors.statusConfirmed),
  inUse('in_use', 'DIGUNAKAN', AppColors.statusPending),
  inactive('inactive', 'NONAKTIF', AppColors.onSurfaceVariant);

  final String value;
  final String label;
  final Color color;

  const TableStatus(this.value, this.label, this.color);

  static TableStatus fromString(String value) {
    return TableStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TableStatus.available,
    );
  }

  bool get isSelectable => this == TableStatus.available;
}
