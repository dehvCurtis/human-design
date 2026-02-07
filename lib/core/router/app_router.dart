import 'package:flutter/foundation.dart';
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
import '../../features/composite/presentation/composite_screen.dart';
import '../../features/penta/presentation/penta_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/domain/settings_providers.dart';
import '../../features/settings/domain/settings_state.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/social/presentation/social_screen.dart';
import '../../features/transits/presentation/transits_screen.dart';
import '../../features/discovery/presentation/discovery_screen.dart';
import '../../features/discovery/presentation/user_profile_screen.dart';
import '../../features/feed/presentation/feed_screen.dart';
import '../../features/gamification/presentation/achievements_screen.dart';
import '../../features/gamification/presentation/challenges_screen.dart';
import '../../features/gamification/presentation/leaderboard_screen.dart';
import '../../features/messaging/presentation/conversations_screen.dart';
import '../../features/messaging/presentation/message_detail_screen.dart';
import '../../features/messaging/presentation/message_with_user_screen.dart';
import '../../features/stories/presentation/stories_screen.dart';
import '../../features/learning/presentation/mentorship_screen.dart';
import '../../features/learning/presentation/live_sessions_screen.dart';
import '../../features/sharing/presentation/share_screen.dart';
import '../../features/sharing/presentation/my_shares_screen.dart';
import '../../features/subscription/presentation/premium_screen.dart';
import '../../features/quiz/presentation/quiz_list_screen.dart';
import '../../features/quiz/presentation/quiz_detail_screen.dart';
import '../../features/quiz/presentation/quiz_taking_screen.dart';
import '../../features/quiz/presentation/quiz_results_screen.dart';
import '../../features/quiz/domain/models/quiz.dart';
import '../../features/hashtags/presentation/hashtag_feed_screen.dart';
import '../../features/hashtags/presentation/trending_hashtags_screen.dart';
import '../../features/feed/presentation/gate_feed_screen.dart';
import '../../features/transits/presentation/transit_events_screen.dart';
import '../../features/transits/presentation/transit_event_detail_screen.dart';
import '../../features/activity/presentation/activity_feed_screen.dart';
import '../../features/gamification/presentation/group_challenges_screen.dart';
import '../../features/gamification/presentation/team_detail_screen.dart';
import '../../features/gamification/presentation/group_challenge_detail_screen.dart';
import '../../features/circles/presentation/circles_screen.dart';
import '../../features/circles/presentation/circle_detail_screen.dart';
import '../../features/experts/presentation/experts_screen.dart';
import '../../features/experts/presentation/expert_detail_screen.dart';
import '../../features/learning_paths/presentation/learning_paths_screen.dart';
import '../../features/learning_paths/presentation/learning_path_detail_screen.dart';
import '../../features/discovery/presentation/popular_charts_screen.dart';
import '../../features/ai_assistant/presentation/ai_chat_screen.dart';
import '../../features/events/presentation/events_screen.dart';
import '../../features/events/presentation/event_detail_screen.dart';
import '../../features/events/presentation/create_event_screen.dart';

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
  static const String userProfile = '/user/:id';
  static const String feed = '/feed';
  static const String postDetail = '/feed/post/:id';
  static const String achievements = '/achievements';
  static const String challenges = '/challenges';
  static const String leaderboard = '/leaderboard';
  static const String messages = '/messages';
  static const String messageDetail = '/messages/:id';
  static const String messageWithUser = '/messages/user/:userId';
  static const String stories = '/stories';
  static const String storyViewer = '/stories/view';
  static const String learning = '/learning';
  static const String contentDetail = '/learning/:id';
  static const String mentorship = '/mentorship';
  static const String sessions = '/sessions';
  static const String share = '/share';
  static const String myShares = '/my-shares';

  // Quiz routes
  static const String quizzes = '/quizzes';
  static const String quizDetail = '/quizzes/:id';
  static const String quizTake = '/quizzes/:id/take';
  static const String quizResults = '/quizzes/:id/results/:attemptId';

  // Hashtag routes
  static const String hashtags = '/hashtags';
  static const String hashtagFeed = '/hashtag/:tag';

  // Gate feed route
  static const String gateFeed = '/gate/:number';

  // Transit event routes
  static const String transitEvents = '/transit-events';
  static const String transitEventDetail = '/transit-event/:id';

  // Activity feed route
  static const String activityFeed = '/activity';

  // Group challenges routes
  static const String groupChallenges = '/group-challenges';
  static const String groupChallengeDetail = '/group-challenge/:id';
  static const String teamDetail = '/team/:id';

  // Compatibility circles routes
  static const String circles = '/circles';
  static const String circleDetail = '/circle/:id';

  // Expert routes
  static const String experts = '/experts';
  static const String expertDetail = '/expert/:id';
  static const String becomeExpert = '/become-expert';

  // Learning paths routes
  static const String learningPaths = '/learning-paths';
  static const String learningPathDetail = '/learning-path/:id';

  // Popular charts route
  static const String popularCharts = '/popular-charts';

  // AI Assistant routes
  static const String aiChat = '/ai-chat';
  static const String aiConversations = '/ai-conversations';
  static const String aiConversationDetail = '/ai-chat/:conversationId';

  // Community events routes
  static const String events = '/events';
  static const String eventDetail = '/event/:id';
  static const String createEvent = '/events/create';
}

/// Provider for the router
final routerProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authStatusProvider);
  final needsOnboarding = ref.watch(needsOnboardingProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,
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
        AppRoutes.birthData, // Part of signup flow
      ];

      final isOnAuthRoute = authRoutes.contains(currentPath);

      // Show splash while loading
      if (isLoading) {
        return currentPath == AppRoutes.splash ? null : AppRoutes.splash;
      }

      // Not authenticated - redirect to appropriate auth screen
      if (!isAuthenticated) {
        // Allow staying on auth screens (except splash and birthData which need auth)
        if (isOnAuthRoute &&
            currentPath != AppRoutes.splash &&
            currentPath != AppRoutes.birthData) {
          return null;
        }
        if (needsOnboarding) return AppRoutes.onboarding;
        return AppRoutes.signIn;
      }

      // Authenticated - redirect away from certain auth routes
      if (isAuthenticated && isOnAuthRoute) {
        // Allow staying on birthData (part of signup flow)
        if (currentPath == AppRoutes.birthData) {
          return null;
        }
        // If on splash or onboarding, go to home
        if (currentPath == AppRoutes.splash ||
            currentPath == AppRoutes.onboarding) {
          return AppRoutes.home;
        }
        // If on sign-in/sign-up, go to birthData to complete profile
        // (router will redirect to home if profile already has birth data)
        if (currentPath == AppRoutes.signIn ||
            currentPath == AppRoutes.signUp) {
          return AppRoutes.birthData;
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
        builder: (context, state) {
          final isEditMode = state.uri.queryParameters['edit'] == 'true';
          return BirthDataScreen(isEditMode: isEditMode);
        },
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
                  return ChartScreen(chartId: id);
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
            path: AppRoutes.popularCharts,
            name: 'popularCharts',
            builder: (context, state) => const PopularChartsScreen(),
          ),
          GoRoute(
            path: AppRoutes.userProfile,
            name: 'userProfile',
            builder: (context, state) => UserProfileScreen(
              userId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: AppRoutes.feed,
            name: 'feed',
            builder: (context, state) => const FeedScreen(),
            routes: [
              GoRoute(
                path: 'post/:id',
                name: 'postDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return PostDetailScreen(postId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.hashtags,
            name: 'hashtags',
            builder: (context, state) => const TrendingHashtagsScreen(),
          ),
          GoRoute(
            path: '/hashtag/:tag',
            name: 'hashtagFeed',
            builder: (context, state) {
              final tag = state.pathParameters['tag']!;
              return HashtagFeedScreen(hashtag: tag);
            },
          ),
          GoRoute(
            path: '/gate/:number',
            name: 'gateFeed',
            builder: (context, state) {
              final numberParam = state.pathParameters['number'];
              final number = int.tryParse(numberParam ?? '');
              if (number == null || number < 1 || number > 64) {
                // Invalid gate number - redirect to error screen
                return ErrorScreen(
                  error: Exception('Invalid gate number: $numberParam'),
                );
              }
              return GateFeedScreen(gateNumber: number);
            },
          ),
          GoRoute(
            path: AppRoutes.transitEvents,
            name: 'transitEvents',
            builder: (context, state) => const TransitEventsScreen(),
          ),
          GoRoute(
            path: '/transit-event/:id',
            name: 'transitEventDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return TransitEventDetailScreen(eventId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.activityFeed,
            name: 'activityFeed',
            builder: (context, state) => const ActivityFeedScreen(),
          ),
          GoRoute(
            path: AppRoutes.groupChallenges,
            name: 'groupChallenges',
            builder: (context, state) => const GroupChallengesScreen(),
          ),
          GoRoute(
            path: '/group-challenge/:id',
            name: 'groupChallengeDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return GroupChallengeDetailScreen(challengeId: id);
            },
          ),
          GoRoute(
            path: '/team/:id',
            name: 'teamDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return TeamDetailScreen(teamId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.circles,
            name: 'circles',
            builder: (context, state) => const CirclesScreen(),
          ),
          GoRoute(
            path: '/circle/:id',
            name: 'circleDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return CircleDetailScreen(circleId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.experts,
            name: 'experts',
            builder: (context, state) => const ExpertsScreen(),
          ),
          GoRoute(
            path: '/expert/:id',
            name: 'expertDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ExpertDetailScreen(expertId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.learningPaths,
            name: 'learningPaths',
            builder: (context, state) => const LearningPathsScreen(),
          ),
          GoRoute(
            path: '/learning-path/:id',
            name: 'learningPathDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return LearningPathDetailScreen(pathId: id);
            },
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
          // AI Assistant routes
          GoRoute(
            path: AppRoutes.aiChat,
            name: 'aiChat',
            builder: (context, state) => const AiChatScreen(),
          ),
          GoRoute(
            path: '/ai-chat/:conversationId',
            name: 'aiConversationDetail',
            builder: (context, state) {
              final conversationId = state.pathParameters['conversationId']!;
              return AiChatScreen(conversationId: conversationId);
            },
          ),
          // Community events routes
          GoRoute(
            path: AppRoutes.events,
            name: 'events',
            builder: (context, state) => const EventsScreen(),
          ),
          GoRoute(
            path: '/event/:id',
            name: 'eventDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return EventDetailScreen(eventId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.createEvent,
            name: 'createEvent',
            builder: (context, state) => const CreateEventScreen(),
          ),
          GoRoute(
            path: AppRoutes.messages,
            name: 'messages',
            builder: (context, state) => const ConversationsScreen(),
            routes: [
              GoRoute(
                path: 'user/:userId',
                name: 'messageWithUser',
                builder: (context, state) {
                  final userId = state.pathParameters['userId']!;
                  return MessageWithUserScreen(userId: userId);
                },
              ),
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
            builder: (context, state) => const QuizListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'contentDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return QuizDetailScreen(quizId: id);
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
          GoRoute(
            path: AppRoutes.myShares,
            name: 'myShares',
            builder: (context, state) => const MySharesScreen(),
          ),
          // Quiz routes
          GoRoute(
            path: AppRoutes.quizzes,
            name: 'quizzes',
            builder: (context, state) => const QuizListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'quizDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return QuizDetailScreen(quizId: id);
                },
                routes: [
                  GoRoute(
                    path: 'take',
                    name: 'quizTake',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return QuizTakingScreen(quizId: id);
                    },
                  ),
                  GoRoute(
                    path: 'results/:attemptId',
                    name: 'quizResults',
                    builder: (context, state) {
                      final quizId = state.pathParameters['id']!;
                      final attemptId = state.pathParameters['attemptId']!;
                      final extra = state.extra as Map<String, dynamic>?;
                      return QuizResultsScreen(
                        quizId: quizId,
                        attemptId: attemptId,
                        attempt: extra?['attempt'] as QuizAttempt?,
                        isNewBest: extra?['isNewBest'] as bool? ?? false,
                        streakUpdated: extra?['streakUpdated'] as bool? ?? false,
                        pointsEarned: extra?['pointsEarned'] as int? ?? 0,
                      );
                    },
                  ),
                ],
              ),
            ],
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
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(settingsProvider.select((s) => s.locale));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Language flags at top right
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: AppLocale.values.map((locale) {
                  final isSelected = locale == currentLocale;
                  return GestureDetector(
                    onTap: () {
                      ref.read(settingsProvider.notifier).setLocale(locale);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected
                            ? const Color(0xFF6366F1).withAlpha(25)
                            : Colors.transparent,
                        border: isSelected
                            ? Border.all(color: const Color(0xFF6366F1), width: 2)
                            : null,
                      ),
                      child: Text(
                        locale.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              // Crystal ball icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFE0E7FF),
                      const Color(0xFF818CF8),
                      const Color(0xFF6366F1),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 40,
                  color: Colors.white,
                ),
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
          ),
        ),
      ),
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
            icon: const Icon(Icons.more_horiz_outlined),
            activeIcon: const Icon(Icons.more_horiz),
            label: AppLocalizations.of(context)!.nav_more,
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
        location.startsWith(AppRoutes.penta) ||
        location.startsWith(AppRoutes.feed) ||
        location.startsWith(AppRoutes.discover) ||
        location.startsWith(AppRoutes.messages) ||
        location.startsWith(AppRoutes.stories) ||
        location.startsWith(AppRoutes.circles) ||
        location.startsWith(AppRoutes.events) ||
        location.startsWith('/event')) {
      return 3;
    }
    // Profile, Learning, Settings all map to "More" tab (index 4)
    if (location.startsWith(AppRoutes.profile) ||
        location.startsWith(AppRoutes.learning) ||
        location.startsWith(AppRoutes.quizzes) ||
        location.startsWith(AppRoutes.settings)) {
      return 4;
    }
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
        _showMoreBottomSheet(context);
        break;
    }
  }

  void _showMoreBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(l10n.nav_profile),
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppRoutes.profile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.school_outlined),
                title: Text(l10n.nav_learn),
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppRoutes.learning);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: Text(l10n.common_settings),
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.settings);
                },
              ),
            ],
          ),
        ),
      ),
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

// CompositeScreen moved to lib/features/composite/presentation/composite_screen.dart

// PentaScreen moved to lib/features/penta/presentation/penta_screen.dart

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
