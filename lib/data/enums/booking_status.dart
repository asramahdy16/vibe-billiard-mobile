import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Booking status enum matching backend
enum BookingStatus {
  pending('pending', 'PENDING', AppColors.statusPending),
  confirmed('confirmed', 'CONFIRMED', AppColors.statusConfirmed),
  inProgress('in_progress', 'BERMAIN', AppColors.statusInProgress),
  completed('completed', 'SELESAI', AppColors.statusCompleted),
  cancelled('cancelled', 'BATAL', AppColors.statusCancelled);

  final String value;
  final String label;
  final Color color;

  const BookingStatus(this.value, this.label, this.color);

  static BookingStatus fromString(String value) {
    return BookingStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BookingStatus.pending,
    );
  }

  bool get canCancel => this == BookingStatus.pending;
  bool get isActive => this == BookingStatus.confirmed || this == BookingStatus.inProgress;
}
