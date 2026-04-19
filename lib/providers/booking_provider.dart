import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/table_model.dart';
import '../data/models/package_model.dart';
import '../data/models/booking_model.dart';
import '../data/repositories/booking_repository.dart';

class BookingWizardState {
  final int currentStep;
  final TableModel? selectedTable;
  final DateTime? selectedDate;
  final String? startTime;
  final String? endTime;
  final int duration;
  final PackageModel? selectedPackage;
  final double totalPrice;

  const BookingWizardState({
    this.currentStep = 1,
    this.selectedTable,
    this.selectedDate,
    this.startTime,
    this.endTime,
    this.duration = 2,
    this.selectedPackage,
    this.totalPrice = 0,
  });

  BookingWizardState copyWith({
    int? currentStep,
    TableModel? selectedTable,
    DateTime? selectedDate,
    String? startTime,
    String? endTime,
    int? duration,
    PackageModel? selectedPackage,
    double? totalPrice,
  }) {
    return BookingWizardState(
      currentStep: currentStep ?? this.currentStep,
      selectedTable: selectedTable ?? this.selectedTable,
      selectedDate: selectedDate ?? this.selectedDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

class BookingWizardNotifier extends StateNotifier<BookingWizardState> {
  BookingWizardNotifier() : super(const BookingWizardState());

  void selectTable(TableModel table) {
    state = state.copyWith(selectedTable: table);
  }

  void setDateTime(DateTime date, String start, String end, int duration) {
    state = state.copyWith(
      selectedDate: date,
      startTime: start,
      endTime: end,
      duration: duration,
      // Reset package when Date/Time changes as it might affect eligibility
      selectedPackage: null,
      totalPrice: 0,
    );
  }

  void selectPackage(PackageModel package) {
    final price = package.calculatePrice(state.duration);
    state = state.copyWith(selectedPackage: package, totalPrice: price);
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void reset() {
    state = const BookingWizardState();
  }
}

final bookingWizardProvider =
    StateNotifierProvider<BookingWizardNotifier, BookingWizardState>((ref) {
  return BookingWizardNotifier();
});

// A provider to fetch bookings for list

final myBookingsProvider =
    FutureProvider.autoDispose<List<BookingModel>>((ref) async {
  final repo = ref.watch(bookingRepositoryProvider);
  return await repo.getMyBookings();
});
