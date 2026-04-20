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
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
        namaPaket: json['nama_paket'] ?? '',
        hargaPerJam: json['harga_per_jam'] != null
            ? double.tryParse(json['harga_per_jam'].toString()) ?? 0
            : null,
        hargaFlat: json['harga_flat'] != null
            ? double.tryParse(json['harga_flat'].toString()) ?? 0
            : null,
        durasiMinJam: json['durasi_min_jam'] is int ? json['durasi_min_jam'] : int.tryParse(json['durasi_min_jam']?.toString() ?? '') ?? 1,
        hariBerlaku: json['hari_berlaku'] ?? 'everyday',
        jamMulai: json['jam_mulai'],
        jamSelesai: json['jam_selesai'],
        isActive: json['is_active'] is bool ? json['is_active'] : (json['is_active'] == 1 || json['is_active'] == '1' || json['is_active'] == true),
      );

  bool get isReguler => hargaFlat == null;
  bool get isHemat => hargaFlat != null;

  /// Check if Paket Hemat is eligible for given date/time
  bool isEligibleForDate(DateTime date, String startTime, String endTime) {
    if (isReguler) return true; // Reguler always eligible

    // Guard against empty or malformed time strings
    if (startTime.isEmpty || endTime.isEmpty) return false;

    final dayOfWeek = date.weekday; // 1=Mon, 7=Sun
    final isWeekday = dayOfWeek >= 1 && dayOfWeek <= 5;

    final startHour = int.tryParse(startTime.split(':')[0]) ?? -1;
    final endHour = int.tryParse(endTime.split(':')[0]) ?? -1;

    if (startHour < 0 || endHour < 0) return false;

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
