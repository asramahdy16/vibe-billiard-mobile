import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/booking_provider.dart';
import '../../providers/table_provider.dart';
import '../../providers/package_provider.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/booking/table_card.dart';
import '../../widgets/booking/time_slot_picker.dart';
import '../../widgets/booking/package_selector.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep(int currentStep) {
    if (currentStep < 3) {
      ref.read(bookingWizardProvider.notifier).nextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.push(RouteConstants.checkout);
    }
  }

  void _prevStep(int currentStep) {
    if (currentStep > 1) {
      ref.read(bookingWizardProvider.notifier).previousStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(RouteConstants.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingWizardProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _prevStep(state.currentStep),
        ),
        title: const Text('Booking Meja'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StepCircle(step: 1, active: state.currentStep >= 1),
                  _StepLine(active: state.currentStep >= 2),
                  _StepCircle(step: 2, active: state.currentStep >= 2),
                  _StepLine(active: state.currentStep >= 3),
                  _StepCircle(step: 3, active: state.currentStep >= 3),
                ],
              ),
            ),
            const Divider(),

            // Forms
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildTableSelection(),
                  _buildTimeSelection(),
                  _buildPackageSelection(),
                ],
              ),
            ),

            // Navigation Area
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GradientButton(
                text: state.currentStep == 3 ? 'Lanjut Checkout' : 'Lanjut',
                onPressed: _canProceed(state) ? () => _nextStep(state.currentStep) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed(BookingWizardState state) {
    if (state.currentStep == 1) return state.selectedTable != null;
    if (state.currentStep == 2) return state.selectedDate != null && state.startTime != null;
    if (state.currentStep == 3) return state.selectedPackage != null;
    return false;
  }

  Widget _buildTableSelection() {
    final tablesAsync = ref.watch(tablesProvider);

    return tablesAsync.when(
      data: (tables) {
        if (tables.isEmpty) return ErrorView.empty(title: 'Tidak ada meja tersedia');
        
        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: tables.length,
          itemBuilder: (context, index) {
            final table = tables[index];
            final state = ref.watch(bookingWizardProvider);
            final isSelected = state.selectedTable?.id == table.id;

            return TableCard(
              table: table,
              isSelected: isSelected,
              onTap: () {
                ref.read(bookingWizardProvider.notifier).selectTable(table);
              },
            );
          },
        );
      },
      loading: () => const LoadingIndicator(),
      error: (e, _) => ErrorView.network(),
    );
  }

  Widget _buildTimeSelection() {
    final state = ref.watch(bookingWizardProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: TimeSlotPicker(
        selectedDate: state.selectedDate,
        startTime: state.startTime,
        duration: state.duration,
        onDateSelected: (date) {
          // Keep current time, reset if past in new date happens down the line. (Simplified)
          ref.read(bookingWizardProvider.notifier).setDateTime(date, state.startTime ?? '', state.endTime ?? '', state.duration);
        },
        onTimeSelected: (start, end) {
          ref.read(bookingWizardProvider.notifier).setDateTime(state.selectedDate ?? DateTime.now(), start, end, state.duration);
        },
        onDurationChanged: (dur) {
          if (state.startTime != null && state.selectedDate != null) {
            final hour = int.parse(state.startTime!.split(':')[0]);
            final endStr = '${(hour + dur).toString().padLeft(2, '0')}:00';
            ref.read(bookingWizardProvider.notifier).setDateTime(state.selectedDate!, state.startTime!, endStr, dur);
          }
        },
      ),
    );
  }

  Widget _buildPackageSelection() {
    final packagesAsync = ref.watch(packagesProvider);
    final state = ref.watch(bookingWizardProvider);

    return packagesAsync.when(
      data: (packages) {
        if (packages.isEmpty) return ErrorView.empty(title: 'Tidak ada paket tersedia');

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final package = packages[index];
            bool isEligible = true;

            if (state.selectedDate != null && state.startTime != null && state.endTime != null) {
              isEligible = package.isEligibleForDate(
                state.selectedDate!,
                state.startTime!,
                state.endTime!,
              );
            }

            final isSelected = state.selectedPackage?.id == package.id;

            return PackageSelector(
              package: package,
              isEligible: isEligible,
              isSelected: isSelected,
              duration: state.duration,
              onTap: () {
                ref.read(bookingWizardProvider.notifier).selectPackage(package);
              },
            );
          },
        );
      },
      loading: () => const LoadingIndicator(),
      error: (e, _) => ErrorView.network(),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int step;
  final bool active;

  const _StepCircle({required this.step, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.primary : AppColors.surfaceContHigh,
        border: Border.all(
          color: active ? AppColors.primaryContainer : AppColors.outlineVariant,
        ),
      ),
      child: Center(
        child: Text(
          '$step',
          style: TextStyle(
            color: active ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool active;

  const _StepLine({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 2,
      color: active ? AppColors.primary : AppColors.outlineVariant,
    );
  }
}
