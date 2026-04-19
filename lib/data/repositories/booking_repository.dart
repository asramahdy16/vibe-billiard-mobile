
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../data/models/booking_model.dart';


class BookingRepository {
  final ApiClient _apiClient;

  BookingRepository(this._apiClient);

  Future<List<BookingModel>> getMyBookings() async {
    final response = await _apiClient.get(ApiConstants.bookings);
    final data = response.data['data'] as List;
    return data.map((json) => BookingModel.fromJson(json)).toList();
  }

  Future<BookingModel> getBookingById(int id) async {
    final response = await _apiClient.get(ApiConstants.bookingDetail(id));
    return BookingModel.fromJson(response.data['data']);
  }

  Future<BookingModel> createBooking({
    required int tableId,
    required int packageId,
    required String tanggal,
    required String waktuMulai,
    required String waktuSelesai,
    String? catatan,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.bookings,
      data: {
        'table_id': tableId,
        'package_id': packageId,
        'tanggal': tanggal,
        'waktu_mulai': waktuMulai,
        'waktu_selesai': waktuSelesai,
        if (catatan != null && catatan.isNotEmpty) 'catatan': catatan,
      },
    );
    return BookingModel.fromJson(response.data['data']);
  }

  // Called to update the status to CANCELLED logic
  Future<BookingModel> cancelBooking(int id) async {
    final response = await _apiClient.patch(ApiConstants.cancelBooking(id));
    return BookingModel.fromJson(response.data['data']);
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return BookingRepository(apiClient);
});
