import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/constants/route_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/common/glass_container.dart';
import '../../widgets/common/gradient_button.dart';

class BookingSuccessScreen extends ConsumerWidget {
  final BookingModel? booking; // Passed via GoRouter extra

  const BookingSuccessScreen({super.key, this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Checkmark (using simple Icon for now)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.checkCircle2,
                      color: AppColors.tertiary,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Booking Berhasil!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Terima kasih, pesananmu sedang diproses.',
                  style: TextStyle(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 48),

                // Digital Ticket Placeholder
                GlassContainer(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'TIKET DIGITAL',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        booking != null ? '#VB-${booking!.id.toString().padLeft(4, '0')}' : '#VB-XXXX',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _TicketDetail(
                        label: 'Waktu bermain',
                        value: booking != null
                            ? '${Formatters.dateShort(booking!.tanggal)}\n${Formatters.time(booking!.waktuMulai)} - ${Formatters.time(booking!.waktuSelesai)}'
                            : '-\n-',
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.outlineVariant),
                      const SizedBox(height: 12),
                      const Text(
                        'Tunjukkan ID Booking ini ke kasir saat datang.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                GradientButton(
                  text: 'Kembali ke Dashboard',
                  onPressed: () {
                    ref.read(bookingWizardProvider.notifier).reset();
                    context.go(RouteConstants.home);
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    ref.read(bookingWizardProvider.notifier).reset();
                    context.go(RouteConstants.history);
                  },
                  child: const Text('Lihat Riwayat Booking'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketDetail extends StatelessWidget {
  final String label;
  final String value;

  const _TicketDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.onSurfaceVariant),
        ),
        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
