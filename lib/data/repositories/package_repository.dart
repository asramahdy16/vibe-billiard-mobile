import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/package_model.dart';

class PackageRepository {
  final ApiClient _apiClient;

  PackageRepository(this._apiClient);

  Future<List<PackageModel>> getPackages() async {
    final response = await _apiClient.get(ApiConstants.packages);
    final data = response.data['data'] as List;
    return data.map((json) => PackageModel.fromJson(json)).toList();
  }
}

final packageRepositoryProvider = Provider<PackageRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return PackageRepository(apiClient);
});
