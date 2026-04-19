import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Payment status enum matching backend
enum PaymentStatus {
  unpaid('unpaid', 'BELUM BAYAR', AppColors.statusPending),
  paid('paid', 'LUNAS', AppColors.statusCompleted),
  refunded('refunded', 'REFUND', AppColors.statusCancelled);

  final String value;
  final String label;
  final Color color;

  const PaymentStatus(this.value, this.label, this.color);

  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentStatus.unpaid,
    );
  }
}
