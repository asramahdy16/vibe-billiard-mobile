import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../data/enums/booking_status.dart';
import '../../data/enums/payment_status.dart';

/// Reusable status badge widget (booking/payment)
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.fontSize = 10,
  });

  factory StatusBadge.booking(BookingStatus status) {
    return StatusBadge(label: status.label, color: status.color);
  }

  factory StatusBadge.payment(PaymentStatus status) {
    return StatusBadge(label: status.label, color: status.color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.statusBadge.copyWith(
          color: color,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
