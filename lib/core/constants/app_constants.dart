/// Application-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Vibe Billiard';
  static const String appTagline = 'Book Your Game, Own The Table';

  // ─── Operational Hours ────────────────────────────────────
  static const int openHour = 8;   // 08:00
  static const int closeHour = 23; // 23:00

  // ─── Booking Constraints ──────────────────────────────────
  static const int minDuration = 1;
  static const int maxDuration = 5;
  static const int maxAdvanceDays = 7;

  // ─── Package Hemat Constraints ────────────────────────────
  static const int hematMinDuration = 2;
  static const int hematStartHour = 8;
  static const int hematEndHour = 17;

  // ─── Storage Keys ─────────────────────────────────────────
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String onboardingKey = 'is_onboarding_done';

  // ─── Currency ─────────────────────────────────────────────
  static const String currencyLocale = 'id_ID';
  static const String currencySymbol = 'Rp';
}
