import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/table_model.dart';

class TableRepository {
  final ApiClient _apiClient;

  TableRepository(this._apiClient);

  Future<List<TableModel>> getTables() async {
    final response = await _apiClient.get(ApiConstants.tables);
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
    
    final tables = <TableModel>[];
    for (final json in rawList) {
      try {
        tables.add(TableModel.fromJson(json));
      } catch (e) {
        debugPrint('Error parsing table: $e');
      }
    }
    return tables;
  }
}

final tableRepositoryProvider = Provider<TableRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return TableRepository(apiClient);
});

