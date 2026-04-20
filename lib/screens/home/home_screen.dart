import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/route_constants.dart';
import '../../core/theme/app_colors.dart';

import '../../widgets/common/background_shapes.dart';

class HomeScreen extends ConsumerWidget {
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(RouteConstants.booking)) return 1;
    if (location.startsWith(RouteConstants.history)) return 2;
    if (location.startsWith(RouteConstants.profile)) return 3;
    return 0; // Default to home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(RouteConstants.home);
        break;
      case 1:
        context.go(RouteConstants.booking);
        break;
      case 2:
        context.go(RouteConstants.history);
        break;
      case 3:
        context.go(RouteConstants.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = _calculateSelectedIndex(context);

    return Scaffold(
      extendBody: true, // For glassmorphism bottom nav if added later
      body: Stack(
        children: [
          const BackgroundShapes(),
          child,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            activeIcon: Icon(LucideIcons.home, color: AppColors.primary),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_baseball), // Billiard ball
            activeIcon: Icon(Icons.sports_baseball, color: AppColors.primary),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.clock),
            activeIcon: Icon(LucideIcons.clock, color: AppColors.primary),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user),
            activeIcon: Icon(LucideIcons.user, color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
