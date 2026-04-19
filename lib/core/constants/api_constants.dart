/// API endpoint constants
class ApiConstants {
  ApiConstants._();

  // ─── Base URL ─────────────────────────────────────────────
  // Android Emulator (maps localhost to host machine)
  // static const String baseUrl = 'http://10.0.2.2:8000/api';

  // iOS Simulator
  // static const String baseUrl = 'http://localhost:8000/api';

  // Real device (use your dev machine's IP)
  static const String baseUrl = 'http://192.168.1.9:8000/api';

  // ─── Auth ─────────────────────────────────────────────────
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String user = '/user';
  static const String userProfile = '/user/profile';
  static const String userPassword = '/user/password';

  // ─── Public ───────────────────────────────────────────────
  static const String tables = '/tables';
  static const String packages = '/packages';

  // ─── Bookings ─────────────────────────────────────────────
  static const String bookings = '/bookings';
  static String bookingDetail(int id) => '/bookings/$id';
  static String cancelBooking(int id) => '/bookings/$id/cancel';
  static String bookingPayment(int id) => '/bookings/$id/payment';
}
