import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../core/constants/route_constants.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/dashboard_tab.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/booking/checkout_screen.dart';
import '../screens/booking/booking_success_screen.dart';
import '../data/models/booking_model.dart';
import '../screens/history/my_bookings_screen.dart';
import '../screens/history/booking_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/change_password_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Create the refresh notifier — it listens to authProvider changes
  // and tells GoRouter to re-evaluate its redirect, WITHOUT recreating
  // the entire GoRouter instance.
  final refreshNotifier = _RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: RouteConstants.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      // Read (NOT watch) auth state inside redirect.
      // This is called every time refreshListenable fires.
      final authState = ref.read(authProvider);
      final currentLocation = state.matchedLocation;

      // Let splash screen handle its own navigation logic
      if (currentLocation == RouteConstants.splash) {
        return null;
      }

      final isOnboarding = currentLocation == RouteConstants.onboarding;
      final isAuthRoute = currentLocation == RouteConstants.login ||
          currentLocation == RouteConstants.register;

      // If auth hasn't been checked yet, don't redirect
      if (!authState.isInitialCheckDone) {
        return null;
      }

      // Authenticated user on auth/onboarding page → redirect to home
      if (authState.isAuthenticated) {
        if (isAuthRoute || isOnboarding) {
          return RouteConstants.home;
        }
        return null;
      }

      // Not authenticated — allow auth routes and onboarding
      if (isAuthRoute || isOnboarding) {
        return null;
      }

      // Not authenticated AND not on auth/onboarding → redirect to login
      return RouteConstants.login;
    },
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteConstants.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteConstants.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: RouteConstants.bookingSuccess,
        builder: (context, state) {
          final booking = state.extra as BookingModel?;
          return BookingSuccessScreen(booking: booking);
        },
      ),
      GoRoute(
        path: RouteConstants.bookingDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BookingDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: RouteConstants.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteConstants.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(
            path: RouteConstants.home,
            builder: (context, state) => const DashboardTab(),
          ),
          GoRoute(
            path: RouteConstants.booking,
            builder: (context, state) => const BookingScreen(),
          ),
          GoRoute(
            path: RouteConstants.history,
            builder: (context, state) => const MyBookingsScreen(),
          ),
          GoRoute(
            path: RouteConstants.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

/// Notifies GoRouter to re-evaluate its redirect whenever auth state changes.
/// This avoids recreating the entire GoRouter instance.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) {
      notifyListeners();
    });
  }
}
