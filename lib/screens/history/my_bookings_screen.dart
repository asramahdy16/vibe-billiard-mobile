import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../core/constants/route_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/enums/booking_status.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/status_badge.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  String _selectedFilter = 'Semua';

  final List<String> _filters = ['Semua', 'Aktif', 'Selesai', 'Batal'];

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(myBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Booking'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedFilter = filter);
                    },
                    backgroundColor: AppColors.surfaceContHigh,
                    selectedColor: AppColors.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? Colors.transparent : AppColors.outlineVariant.withOpacity(0.2),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myBookingsProvider);
          },
          child: bookingsAsync.when(
            data: (allBookings) {
              final bookings = allBookings.where((b) {
                if (_selectedFilter == 'Semua') return true;
                if (_selectedFilter == 'Aktif') return b.isActive;
                if (_selectedFilter == 'Selesai') return b.bookingStatus == BookingStatus.completed;
                if (_selectedFilter == 'Batal') return b.bookingStatus == BookingStatus.cancelled;
                return true;
              }).toList();

              if (bookings.isEmpty) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ErrorView.empty(
                    title: 'Belum ada booking',
                    subtitle: _selectedFilter == 'Semua' 
                        ? 'Kamu belum pernah melakukan booking meja.'
                        : 'Tidak ada booking dengan status $_selectedFilter.',
                    actionLabel: _selectedFilter == 'Semua' ? 'Mulai Booking' : null,
                    onAction: _selectedFilter == 'Semua' ? () => context.go(RouteConstants.booking) : null,
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: bookings.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return GestureDetector(
                    onTap: () {
                      context.push(RouteConstants.bookingDetailPath(booking.id)).then((_) {
                        // Refresh data just in case it was cancelled
                        ref.invalidate(myBookingsProvider);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                              Text(
                                Formatters.dateShort(booking.tanggal),
                                style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                              StatusBadge.booking(booking.bookingStatus),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceCont,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.sports_baseball, color: AppColors.primary),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      booking.table?.namaMeja ?? 'Meja',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${Formatters.time(booking.waktuMulai)} - ${Formatters.time(booking.waktuSelesai)}',
                                      style: const TextStyle(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                Formatters.currency(booking.totalHarga),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const LoadingIndicator(),
            error: (e, _) => ErrorView.network(onRetry: () => ref.invalidate(myBookingsProvider)),
          ),
        ),
      ),
    );
  }
}
