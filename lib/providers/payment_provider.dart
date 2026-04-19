import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/payment_model.dart';
import '../data/repositories/payment_repository.dart';

class PaymentNotifier extends StateNotifier<AsyncValue<PaymentModel?>> {
  final PaymentRepository _repository;

  PaymentNotifier(this._repository) : super(const AsyncData(null));

  Future<PaymentModel?> processPayment({
    required int bookingId,
    required String metode,
    String? buktiTransferPath,
  }) async {
    state = const AsyncLoading();
    try {
      final payment = await _repository.processPayment(
        bookingId: bookingId,
        metode: metode,
        buktiTransferPath: buktiTransferPath,
      );
      state = AsyncData(payment);
      return payment;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, AsyncValue<PaymentModel?>>((ref) {
  final repo = ref.read(paymentRepositoryProvider);
  return PaymentNotifier(repo);
});
