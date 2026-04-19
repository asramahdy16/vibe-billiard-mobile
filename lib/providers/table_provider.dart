import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/table_model.dart';
import '../data/repositories/table_repository.dart';

final tablesProvider = FutureProvider.autoDispose<List<TableModel>>((ref) async {
  final repo = ref.watch(tableRepositoryProvider);
  return await repo.getTables();
});
