import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/formatters.dart';
import '../../data/enums/payment_method.dart';

import '../../data/repositories/booking_repository.dart';
import '../../providers/booking_provider.dart';
import '../../providers/payment_provider.dart';
import '../../widgets/booking/booking_summary_card.dart';
import '../../widgets/common/gradient_button.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.cash;
  bool _isLoading = false;

  Future<void> _processCheckout() async {
    final state = ref.read(bookingWizardProvider);
    if (state.selectedTable == null ||
        state.selectedPackage == null ||
        state.selectedDate == null ||
        state.startTime == null ||
        state.endTime == null) {
      context.showSnackBar('Data booking tidak lengkap', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Create Booking
      final bookingRepo = ref.read(bookingRepositoryProvider);
      final booking = await bookingRepo.createBooking(
        tableId: state.selectedTable!.id,
        packageId: state.selectedPackage!.id,
        tanggal: Formatters.apiDate(state.selectedDate!),
        waktuMulai: state.startTime!,
        waktuSelesai: state.endTime!,
      );

      // 2. Process Payment
      await ref.read(paymentProvider.notifier).processPayment(
            bookingId: booking.id,
            metode: _selectedMethod.value,
          );

      if (mounted) {
        // Invalidate my bookings to refresh history
        ref.invalidate(myBookingsProvider);
        
        // Pass the booking ID to success screen (handled via GoRouter extra for simplicity if needed, but we can pass object)
        context.go(RouteConstants.bookingSuccess, extra: booking);
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar(e.toString(), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingWizardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingSummaryCard(state: state),
                    const SizedBox(height: 32),
                    const Text(
                      'Pilih Metode Pembayaran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...PaymentMethod.values.map((method) => _PaymentMethodRadio(
                          method: method,
                          isSelected: _selectedMethod == method,
                          onSelect: () => setState(() => _selectedMethod = method),
                        )),
                    if (_selectedMethod != PaymentMethod.cash) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContHigh,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.info, color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Kamu akan diarahkan untuk mengunggah bukti pembayaran setelah ini.',
                                style: TextStyle(
                                  color: AppColors.onSurface.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: GradientButton(
                text: 'KONFIRMASI BOOKING',
                isLoading: _isLoading,
                onPressed: _processCheckout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodRadio extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onSelect;

  const _PaymentMethodRadio({
    required this.method,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              method == PaymentMethod.cash
                  ? LucideIcons.banknote
                  : method == PaymentMethod.transfer
                      ? LucideIcons.landmark
                      : LucideIcons.smartphone,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method.label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
