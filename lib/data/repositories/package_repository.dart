import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/package_model.dart';

class PackageRepository {
  final ApiClient _apiClient;

  PackageRepository(this._apiClient);

  Future<List<PackageModel>> getPackages() async {
    final response = await _apiClient.get(ApiConstants.packages);
    final responseData = response.data;
    
    List rawList;
    if (responseData is Map && responseData.containsKey('data')) {
      final data = responseData['data'];
      if (data is List) {
        rawList = data;
      } else if (data is Map && data.containsKey('data')) {
        rawList = data['data'] as List;
      } else {
        rawList = [];
      }
    } else if (responseData is List) {
      rawList = responseData;
    } else {
      rawList = [];
    }
    
    final packages = <PackageModel>[];
    for (final json in rawList) {
      try {
        packages.add(PackageModel.fromJson(json));
      } catch (e) {
        debugPrint('Error parsing package: $e');
      }
    }
    return packages;
  }
}

final packageRepositoryProvider = Provider<PackageRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return PackageRepository(apiClient);
});

