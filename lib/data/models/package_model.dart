/// Package data model
class PackageModel {
  final int id;
  final String namaPaket;
  final double? hargaPerJam;
  final double? hargaFlat;
  final int durasiMinJam;
  final String hariBerlaku;
  final String? jamMulai;
  final String? jamSelesai;
  final bool isActive;

  PackageModel({
    required this.id,
    required this.namaPaket,
    this.hargaPerJam,
    this.hargaFlat,
    required this.durasiMinJam,
    required this.hariBerlaku,
    this.jamMulai,
    this.jamSelesai,
    required this.isActive,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        id: json['id'],
        namaPaket: json['nama_paket'] ?? '',
        hargaPerJam: json['harga_per_jam'] != null
            ? double.parse(json['harga_per_jam'].toString())
            : null,
        hargaFlat: json['harga_flat'] != null
            ? double.parse(json['harga_flat'].toString())
            : null,
        durasiMinJam: json['durasi_min_jam'] ?? 1,
        hariBerlaku: json['hari_berlaku'] ?? 'everyday',
        jamMulai: json['jam_mulai'],
        jamSelesai: json['jam_selesai'],
        isActive: json['is_active'] ?? true,
      );

  bool get isReguler => hargaFlat == null;
  bool get isHemat => hargaFlat != null;

  /// Check if Paket Hemat is eligible for given date/time
  bool isEligibleForDate(DateTime date, String startTime, String endTime) {
    if (isReguler) return true; // Reguler always eligible

    final dayOfWeek = date.weekday; // 1=Mon, 7=Sun
    final isWeekday = dayOfWeek >= 1 && dayOfWeek <= 5;

    final startHour = int.parse(startTime.split(':')[0]);
    final endHour = int.parse(endTime.split(':')[0]);

    final isWithinHours = startHour >= 8 && endHour <= 17;
    final duration = endHour - startHour;
    final hasMinDuration = duration >= 2;

    return isWeekday && isWithinHours && hasMinDuration;
  }

  /// Calculate total price
  double calculatePrice(int durationHours, {double regularRate = 35000}) {
    if (isHemat) {
      final extra = (durationHours - durasiMinJam).clamp(0, 99);
      return hargaFlat! + (extra * regularRate);
    }
    return (hargaPerJam ?? 0) * durationHours;
  }
}
