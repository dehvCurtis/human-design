import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/domain/auth_providers.dart';
import '../../features/home/presentation/home_screen.dart' as home;

/// Route names
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String birthData = '/birth-data';
  static const String home = '/home';
  static const String chart = '/chart';
  static const String chartDetail = '/chart/:id';
  static const String transits = '/transits';
  static const String affirmations = '/affirmations';
  static const String composite = '/composite';
  static const String penta = '/penta';
  static const String social = '/social';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String premium = '/premium';
}

/// Provider for the router
final routerProvider = Provider<GoRouter>((ref) {
  final appAuthState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // TODO: Remove this bypass after testing - go straight to home
      final isSplash = state.matchedLocation == AppRoutes.splash;
      if (isSplash) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        name: 'signIn',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        name: 'signUp',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.birthData,
        name: 'birthData',
        builder: (context, state) => const BirthDataScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const home.HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.chart,
            name: 'chart',
            builder: (context, state) => const ChartScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'chartDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ChartDetailScreen(chartId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.transits,
            name: 'transits',
            builder: (context, state) => const TransitsScreen(),
          ),
          GoRoute(
            path: AppRoutes.affirmations,
            name: 'affirmations',
            builder: (context, state) => const AffirmationsScreen(),
          ),
          GoRoute(
            path: AppRoutes.composite,
            name: 'composite',
            builder: (context, state) => const CompositeScreen(),
          ),
          GoRoute(
            path: AppRoutes.penta,
            name: 'penta',
            builder: (context, state) => const PentaScreen(),
          ),
          GoRoute(
            path: AppRoutes.social,
            name: 'social',
            builder: (context, state) => const SocialScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.premium,
        name: 'premium',
        builder: (context, state) => const PremiumScreen(),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});

// Placeholder screens - these would be implemented in their respective feature folders

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Onboarding')),
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Sign In')),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Sign Up')),
    );
  }
}

class BirthDataScreen extends StatelessWidget {
  const BirthDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Birth Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(child: Text('Birth Data Entry Form')),
    );
  }
}

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph_outlined),
            activeIcon: Icon(Icons.auto_graph),
            label: 'Chart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny_outlined),
            activeIcon: Icon(Icons.wb_sunny),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.chart)) return 1;
    if (location.startsWith(AppRoutes.transits) ||
        location.startsWith(AppRoutes.affirmations)) return 2;
    if (location.startsWith(AppRoutes.social) ||
        location.startsWith(AppRoutes.composite) ||
        location.startsWith(AppRoutes.penta)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.chart);
        break;
      case 2:
        context.go(AppRoutes.transits);
        break;
      case 3:
        context.go(AppRoutes.social);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }
}

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Chart')),
      body: const Center(child: Text('Chart View - Bodygraph will appear here')),
    );
  }
}

class ChartDetailScreen extends StatelessWidget {
  const ChartDetailScreen({super.key, required this.chartId});

  final String chartId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Chart Detail: $chartId')),
    );
  }
}

class TransitsScreen extends StatelessWidget {
  const TransitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Today\'s Transits')),
      body: const Center(child: Text('Current planetary transits')),
    );
  }
}

class AffirmationsScreen extends StatelessWidget {
  const AffirmationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Affirmations')),
    );
  }
}

class CompositeScreen extends StatelessWidget {
  const CompositeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Composite Charts')),
    );
  }
}

class PentaScreen extends StatelessWidget {
  const PentaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Penta')),
    );
  }
}

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: const Center(child: Text('Connections & Groups')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: const Center(child: Text('User Profile')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(child: Text('Settings')),
    );
  }
}

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(child: Text('Premium')),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Error: ${error?.toString() ?? "Unknown error"}'),
      ),
    );
  }
}
