import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/enums/payment_status.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/status_badge.dart';

final bookingDetailProvider = FutureProvider.family.autoDispose<BookingModel, int>((ref, id) async {
  final repo = ref.watch(bookingRepositoryProvider);
  return await repo.getBookingById(id);
});

class BookingDetailScreen extends ConsumerStatefulWidget {
  final int id;

  const BookingDetailScreen({super.key, required this.id});

  @override
  ConsumerState<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  bool _isCanceling = false;

  Future<void> _cancelBooking() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Booking?'),
        content: const Text('Apakah kamu yakin ingin membatalkan booking ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Batalkan', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isCanceling = true);
    try {
      final repo = ref.read(bookingRepositoryProvider);
      await repo.cancelBooking(widget.id);
      
      if (mounted) {
        context.showSuccessSnackBar('Booking berhasil dibatalkan');
        ref.invalidate(bookingDetailProvider(widget.id));
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Gagal membatalkan: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isCanceling = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncBooking = ref.watch(bookingDetailProvider(widget.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Booking'),
      ),
      body: SafeArea(
        child: asyncBooking.when(
          data: (booking) => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#VB-${booking.id.toString().padLeft(4, '0')}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        StatusBadge.booking(booking.bookingStatus),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Detail Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContHigh,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informasi Booking',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _DetailRow(icon: Icons.sports_baseball, label: 'Meja', value: booking.table?.namaMeja ?? '-'),
                          const Divider(height: 24),
                          _DetailRow(
                            icon: Icons.calendar_today, 
                            label: 'Tanggal', 
                            value: Formatters.date(booking.tanggal)
                          ),
                          const SizedBox(height: 12),
                          _DetailRow(
                            icon: Icons.access_time, 
                            label: 'Waktu', 
                            value: '${Formatters.time(booking.waktuMulai)} - ${Formatters.time(booking.waktuSelesai)} (${booking.durasiJam} Jam)'
                          ),
                          const Divider(height: 24),
                          _DetailRow(icon: Icons.local_offer, label: 'Paket', value: booking.package?.namaPaket ?? '-'),
                          if (booking.catatan != null && booking.catatan!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            _DetailRow(icon: LucideIcons.fileText, label: 'Catatan', value: booking.catatan!),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContHigh,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Informasi Pembayaran',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (booking.payment != null)
                                StatusBadge.payment(PaymentStatus.fromString(booking.payment!.statusBayar))
                            ],
                          ),
                          const SizedBox(height: 16),
                          _DetailRow(
                            icon: LucideIcons.wallet, 
                            label: 'Metode', 
                            value: booking.payment?.metode.toUpperCase() ?? '-'
                          ),
                          const SizedBox(height: 12),
                          _DetailRow(
                            icon: LucideIcons.badgeDollarSign, 
                            label: 'Total Tagihan', 
                            value: Formatters.currency(booking.totalHarga),
                            valueColor: AppColors.tertiary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (booking.canCancel)
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                        ),
                        onPressed: _cancelBooking,
                        icon: const Icon(LucideIcons.xCircle, size: 20),
                        label: const Text('Batalkan Booking'),
                      ),
                  ],
                ),
              ),
              if (_isCanceling)
                Container(
                  color: AppColors.background.withOpacity(0.5),
                  child: const LoadingIndicator(),
                ),
            ],
          ),
          loading: () => const LoadingIndicator(),
          error: (e, _) => ErrorView.network(onRetry: () => ref.invalidate(bookingDetailProvider(widget.id))),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon, 
    required this.label, 
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
