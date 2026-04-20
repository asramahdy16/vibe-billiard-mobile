import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/payment_model.dart';

class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  Future<PaymentModel> processPayment({
    required int bookingId,
    required String metode,
    String? buktiTransferPath, // Path for multipart if needed later
  }) async {
    final response = await _apiClient.post(
      ApiConstants.bookingPayment(bookingId),
      data: {
        'metode': metode,
        // Optional file upload logic would use Dio FormData here
      },
    );
    final responseData = response.data;
    final data = responseData is Map && responseData.containsKey('data')
        ? responseData['data']
        : responseData;
    return PaymentModel.fromJson(data);
  }
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return PaymentRepository(apiClient);
});

