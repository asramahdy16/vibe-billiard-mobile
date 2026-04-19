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
        id: json['id'],
        userId: json['user_id'],
        tableId: json['table_id'],
        packageId: json['package_id'],
        tanggal: json['tanggal'],
        waktuMulai: json['waktu_mulai'],
        waktuSelesai: json['waktu_selesai'],
        durasiJam: json['durasi_jam'],
        totalHarga: double.parse(json['total_harga'].toString()),
        status: json['status'],
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
