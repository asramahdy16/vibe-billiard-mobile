import '../enums/table_status.dart';

/// Billiard table data model
class TableModel {
  final int id;
  final String namaMeja;
  final String? deskripsi;
  final String? gambar;
  final String status;

  TableModel({
    required this.id,
    required this.namaMeja,
    this.deskripsi,
    this.gambar,
    required this.status,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
        namaMeja: json['nama_meja'] ?? '',
        deskripsi: json['deskripsi'],
        gambar: json['gambar'],
        status: json['status'] ?? 'available',
      );

  TableStatus get tableStatus => TableStatus.fromString(status);
  bool get isAvailable => tableStatus == TableStatus.available;
}
