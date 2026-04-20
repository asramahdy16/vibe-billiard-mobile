
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../data/models/booking_model.dart';


class BookingRepository {
  final ApiClient _apiClient;

  BookingRepository(this._apiClient);

  Future<List<BookingModel>> getMyBookings() async {
    final response = await _apiClient.get(ApiConstants.bookings);
    final responseData = response.data;
    
    // Handle different response structures from the API
    List rawList;
    if (responseData is Map && responseData.containsKey('data')) {
      final data = responseData['data'];
      if (data is List) {
        rawList = data;
      } else if (data is Map && data.containsKey('data')) {
        // Paginated response: { data: { data: [...], ... } }
        rawList = data['data'] as List;
      } else {
        rawList = [];
      }
    } else if (responseData is List) {
      rawList = responseData;
    } else {
      rawList = [];
    }
    
    final bookings = <BookingModel>[];
    for (final json in rawList) {
      try {
        bookings.add(BookingModel.fromJson(json));
      } catch (e) {
        debugPrint('Error parsing booking: $e');
      }
    }
    return bookings;
  }

  Future<BookingModel> getBookingById(int id) async {
    final response = await _apiClient.get(ApiConstants.bookingDetail(id));
    final responseData = response.data;
    final data = responseData is Map && responseData.containsKey('data')
        ? responseData['data']
        : responseData;
    return BookingModel.fromJson(data);
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
    final responseData = response.data;
    final data = responseData is Map && responseData.containsKey('data')
        ? responseData['data']
        : responseData;
    return BookingModel.fromJson(data);
  }

  // Called to update the status to CANCELLED logic
  Future<BookingModel> cancelBooking(int id) async {
    final response = await _apiClient.patch(ApiConstants.cancelBooking(id));
    final responseData = response.data;
    final data = responseData is Map && responseData.containsKey('data')
        ? responseData['data']
        : responseData;
    return BookingModel.fromJson(data);
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return BookingRepository(apiClient);
});

