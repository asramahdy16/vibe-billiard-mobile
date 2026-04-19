/// Payment data model
class PaymentModel {
  final int id;
  final int bookingId;
  final String metode;
  final double jumlah;
  final String statusBayar;
  final String? buktiTransfer;
  final String? paidAt;

  PaymentModel({
    required this.id,
    required this.bookingId,
    required this.metode,
    required this.jumlah,
    required this.statusBayar,
    this.buktiTransfer,
    this.paidAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json['id'],
        bookingId: json['booking_id'],
        metode: json['metode'] ?? 'cash',
        jumlah: double.parse(json['jumlah'].toString()),
        statusBayar: json['status_bayar'] ?? 'unpaid',
        buktiTransfer: json['bukti_transfer'],
        paidAt: json['paid_at'],
      );
}
