/// Named route path constants
class RouteConstants {
  RouteConstants._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  // ─── Main (Shell) ─────────────────────────────────────────
  static const String home = '/home';
  static const String booking = '/booking';
  static const String history = '/history';
  static const String profile = '/profile';

  // ─── Sub routes ───────────────────────────────────────────
  static const String checkout = '/checkout';
  static const String bookingSuccess = '/booking-success';
  static const String bookingDetail = '/booking/:id';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';

  static String bookingDetailPath(int id) => '/booking/$id';
}
