import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Formatters for currency, date, and time (id-ID locale)
class Formatters {
  Formatters._();

  // ─── Currency ─────────────────────────────────────────────
  static String currency(double amount) {
    final formatter = NumberFormat.currency(
      locale: AppConstants.currencyLocale,
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String currencyCompact(double amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}K';
    }
    return currency(amount);
  }

  // ─── Date ─────────────────────────────────────────────────
  static String date(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  static String dateShort(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }

  static String dateFromDateTime(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  static String dayName(DateTime date) {
    return DateFormat('EEEE', 'id_ID').format(date);
  }

  static String dayNameShort(DateTime date) {
    return DateFormat('E', 'id_ID').format(date);
  }

  static String apiDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // ─── Time ─────────────────────────────────────────────────
  static String time(String timeStr) {
    // Convert "08:00:00" or "08:00" to "08:00"
    final parts = timeStr.split(':');
    return '${parts[0]}:${parts[1]}';
  }

  static String timeRange(String start, String end) {
    return '${time(start)} - ${time(end)}';
  }

  static String timeFromHour(int hour) {
    return '${hour.toString().padLeft(2, '0')}:00';
  }

  // ─── Relative Time ────────────────────────────────────────
  static String relativeTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return dateShort(dateTimeStr);
  }
}
