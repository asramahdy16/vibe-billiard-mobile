import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/table_model.dart';

class TableRepository {
  final ApiClient _apiClient;

  TableRepository(this._apiClient);

  Future<List<TableModel>> getTables() async {
    final response = await _apiClient.get(ApiConstants.tables);
    final data = response.data['data'] as List;
    return data.map((json) => TableModel.fromJson(json)).toList();
  }
}

final tableRepositoryProvider = Provider<TableRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return TableRepository(apiClient);
});
