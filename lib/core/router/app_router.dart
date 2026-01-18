import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/domain/auth_providers.dart';
import '../../features/auth/presentation/birth_data_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/sign_up_screen.dart';
import '../../features/chart/presentation/add_chart_screen.dart';
import '../../features/chart/presentation/chart_screen.dart';
import '../../features/chart/presentation/saved_charts_screen.dart';
import '../../features/home/presentation/home_screen.dart' as home;
import '../../features/penta/presentation/penta_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/domain/settings_providers.dart';
import '../../features/settings/domain/settings_state.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/social/presentation/social_screen.dart';
import '../../features/transits/presentation/transits_screen.dart';
import '../../features/discovery/presentation/discovery_screen.dart';
import '../../features/feed/presentation/feed_screen.dart';
import '../../features/gamification/presentation/achievements_screen.dart';
import '../../features/gamification/presentation/challenges_screen.dart';
import '../../features/gamification/presentation/leaderboard_screen.dart';
import '../../features/messaging/presentation/conversations_screen.dart';
import '../../features/messaging/presentation/message_detail_screen.dart';
import '../../features/stories/presentation/stories_screen.dart';
import '../../features/learning/presentation/learning_screen.dart';
import '../../features/learning/presentation/content_detail_screen.dart';
import '../../features/learning/presentation/mentorship_screen.dart';
import '../../features/learning/presentation/live_sessions_screen.dart';
import '../../features/sharing/presentation/share_screen.dart';

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
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String premium = '/premium';
  static const String savedCharts = '/charts';
  static const String addChart = '/charts/add';

  // Social platform routes
  static const String discover = '/discover';
  static const String feed = '/feed';
  static const String achievements = '/achievements';
  static const String challenges = '/challenges';
  static const String leaderboard = '/leaderboard';
  static const String messages = '/messages';
  static const String messageDetail = '/messages/:id';
  static const String stories = '/stories';
  static const String learning = '/learning';
  static const String contentDetail = '/learning/:id';
  static const String mentorship = '/mentorship';
  static const String sessions = '/sessions';
  static const String share = '/share';
}

/// Provider for the router
final routerProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authStatusProvider);
  final needsOnboarding = ref.watch(needsOnboardingProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: _RouterRefreshStream(ref),
    redirect: (context, state) {
      final isLoading = authStatus == AuthStatus.loading;
      final isAuthenticated = authStatus == AuthStatus.authenticated;
      final currentPath = state.matchedLocation;

      // Auth routes that don't require authentication
      final authRoutes = [
        AppRoutes.splash,
        AppRoutes.onboarding,
        AppRoutes.signIn,
        AppRoutes.signUp,
      ];

      final isOnAuthRoute = authRoutes.contains(currentPath);

      // Show splash while loading
      if (isLoading) {
        return currentPath == AppRoutes.splash ? null : AppRoutes.splash;
      }

      // Not authenticated - redirect to appropriate auth screen
      if (!isAuthenticated) {
        // Allow staying on auth screens (except splash which should redirect)
        if (isOnAuthRoute && currentPath != AppRoutes.splash) return null;
        if (needsOnboarding) return AppRoutes.onboarding;
        return AppRoutes.signIn;
      }

      // Authenticated - redirect away from auth routes
      if (isAuthenticated && isOnAuthRoute) {
        // If on splash or onboarding, go to home
        if (currentPath == AppRoutes.splash ||
            currentPath == AppRoutes.onboarding) {
          return AppRoutes.home;
        }
        // If on sign-in/sign-up, go to home
        if (currentPath == AppRoutes.signIn ||
            currentPath == AppRoutes.signUp) {
          return AppRoutes.home;
        }
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
            path: AppRoutes.savedCharts,
            name: 'savedCharts',
            builder: (context, state) => const SavedChartsScreen(),
          ),
          GoRoute(
            path: AppRoutes.addChart,
            name: 'addChart',
            builder: (context, state) => const AddChartScreen(),
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
          // Social platform routes
          GoRoute(
            path: AppRoutes.discover,
            name: 'discover',
            builder: (context, state) => const DiscoveryScreen(),
          ),
          GoRoute(
            path: AppRoutes.feed,
            name: 'feed',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: AppRoutes.achievements,
            name: 'achievements',
            builder: (context, state) => const AchievementsScreen(),
          ),
          GoRoute(
            path: AppRoutes.challenges,
            name: 'challenges',
            builder: (context, state) => const ChallengesScreen(),
          ),
          GoRoute(
            path: AppRoutes.leaderboard,
            name: 'leaderboard',
            builder: (context, state) => const LeaderboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.messages,
            name: 'messages',
            builder: (context, state) => const ConversationsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'messageDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return MessageDetailScreen(conversationId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.stories,
            name: 'stories',
            builder: (context, state) => const StoriesScreen(),
          ),
          GoRoute(
            path: AppRoutes.learning,
            name: 'learning',
            builder: (context, state) => const LearningScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'contentDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ContentDetailScreen(contentId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.mentorship,
            name: 'mentorship',
            builder: (context, state) => const MentorshipScreen(),
          ),
          GoRoute(
            path: AppRoutes.sessions,
            name: 'sessions',
            builder: (context, state) => const LiveSessionsScreen(),
          ),
          GoRoute(
            path: AppRoutes.share,
            name: 'share',
            builder: (context, state) => const ShareScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
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

/// Listenable for refreshing router when auth state changes
class _RouterRefreshStream extends ChangeNotifier {
  _RouterRefreshStream(this._ref) {
    _ref.listen(authStatusProvider, (_, _) => notifyListeners());
    _ref.listen(needsOnboardingProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;
}

// =============================================================================
// Placeholder screens (to be moved to feature modules)
// =============================================================================

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_graph,
              size: 64,
              color: Color(0xFF6366F1),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _showLanguageSelector = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(settingsProvider.select((s) => s.locale));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _showLanguageSelector
              ? _buildLanguageSelector(context, currentLocale)
              : _buildWelcomeContent(context, l10n),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, AppLocale currentLocale) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const Spacer(),
        const Icon(
          Icons.language,
          size: 80,
          color: Color(0xFF6366F1),
        ),
        const SizedBox(height: 32),
        Text(
          l10n.onboarding_selectLanguage,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...AppLocale.values.map((locale) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await ref.read(settingsProvider.notifier).setLocale(locale);
                    setState(() {
                      _showLanguageSelector = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: locale == currentLocale
                          ? const Color(0xFF6366F1)
                          : Colors.grey[300]!,
                      width: locale == currentLocale ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        locale.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        locale.displayName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: locale == currentLocale
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        const Spacer(),
      ],
    );
  }

  Widget _buildWelcomeContent(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // Change language button at top
        Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _showLanguageSelector = true;
              });
            },
            icon: const Icon(Icons.language, size: 18),
            label: Text(l10n.settings_changeLanguage),
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.auto_graph,
          size: 80,
          color: Color(0xFF6366F1),
        ),
        const SizedBox(height: 32),
        Text(
          l10n.onboarding_welcome,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.onboarding_liveInAlignment,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).completeOnboarding();
              context.go(AppRoutes.signUp);
            },
            child: Text(l10n.onboarding_getStarted),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            ref.read(settingsProvider.notifier).completeOnboarding();
            context.go(AppRoutes.signIn);
          },
          child: Text(l10n.onboarding_alreadyHaveAccount),
        ),
      ],
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.nav_home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_graph_outlined),
            activeIcon: const Icon(Icons.auto_graph),
            label: AppLocalizations.of(context)!.nav_chart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.wb_sunny_outlined),
            activeIcon: const Icon(Icons.wb_sunny),
            label: AppLocalizations.of(context)!.nav_today,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline),
            activeIcon: const Icon(Icons.people),
            label: AppLocalizations.of(context)!.nav_social,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.nav_profile,
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
        location.startsWith(AppRoutes.affirmations)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.social) ||
        location.startsWith(AppRoutes.composite) ||
        location.startsWith(AppRoutes.penta)) {
      return 3;
    }
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

class ChartDetailScreen extends StatelessWidget {
  const ChartDetailScreen({super.key, required this.chartId});

  final String chartId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(child: Text('Chart Detail: $chartId')),
    );
  }
}

class AffirmationsScreen extends StatelessWidget {
  const AffirmationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Affirmations')),
      body: const Center(child: Text('Daily Affirmations')),
    );
  }
}

class CompositeScreen extends StatelessWidget {
  const CompositeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Composite Charts')),
      body: const Center(child: Text('Relationship Analysis')),
    );
  }
}

// PentaScreen moved to lib/features/penta/presentation/penta_screen.dart

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
      body: const Center(child: Text('Upgrade to Premium')),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
