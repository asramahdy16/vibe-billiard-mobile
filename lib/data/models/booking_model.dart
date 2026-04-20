import '../enums/booking_status.dart';
import 'table_model.dart';
import 'package_model.dart';
import 'payment_model.dart';

/// Booking data model with nested relations
class BookingModel {
  final int id;
  final int userId;
  final int tableId;
  final int packageId;
  final String tanggal;
  final String waktuMulai;
  final String waktuSelesai;
  final int durasiJam;
  final double totalHarga;
  final String status;
  final String? catatan;
  final TableModel? table;
  final PackageModel? package;
  final PaymentModel? payment;
  final String? createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.tableId,
    required this.packageId,
    required this.tanggal,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.durasiJam,
    required this.totalHarga,
    required this.status,
    this.catatan,
    this.table,
    this.package,
    this.payment,
    this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
        userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
        tableId: json['table_id'] is int ? json['table_id'] : int.tryParse(json['table_id']?.toString() ?? '') ?? 0,
        packageId: json['package_id'] is int ? json['package_id'] : int.tryParse(json['package_id']?.toString() ?? '') ?? 0,
        tanggal: json['tanggal'] ?? '',
        waktuMulai: json['waktu_mulai'] ?? '00:00',
        waktuSelesai: json['waktu_selesai'] ?? '00:00',
        durasiJam: json['durasi_jam'] is int ? json['durasi_jam'] : int.tryParse(json['durasi_jam']?.toString() ?? '') ?? 0,
        totalHarga: double.tryParse(json['total_harga']?.toString() ?? '0') ?? 0,
        status: json['status'] ?? 'pending',
        catatan: json['catatan'],
        table:
            json['table'] != null ? TableModel.fromJson(json['table']) : null,
        package: json['package'] != null
            ? PackageModel.fromJson(json['package'])
            : null,
        payment: json['payment'] != null
            ? PaymentModel.fromJson(json['payment'])
            : null,
        createdAt: json['created_at'],
      );

  BookingStatus get bookingStatus => BookingStatus.fromString(status);
  bool get canCancel => bookingStatus.canCancel;
  bool get isActive => bookingStatus.isActive;
}
