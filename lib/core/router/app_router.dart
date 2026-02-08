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
import '../../features/discovery/presentation/user_profile_screen.dart' hide userProfileProvider;
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
import '../../features/ai_assistant/presentation/ai_hub_screen.dart';
import '../../features/ai_assistant/presentation/ai_chat_screen.dart';
import '../../features/ai_assistant/presentation/ai_transit_insight_screen.dart';
import '../../features/ai_assistant/presentation/ai_chart_reading_screen.dart';
import '../../features/ai_assistant/presentation/ai_compatibility_screen.dart';
import '../../features/ai_assistant/presentation/ai_journal_prompts_screen.dart';
import '../../features/home/domain/home_providers.dart' show userChartProvider, userProfileProvider;
import '../../features/profile/data/profile_repository.dart' show UserProfile;
import '../../features/chart/domain/models/human_design_chart.dart';
import '../../features/composite/domain/composite_calculator.dart';
import '../../features/dream_journal/presentation/dream_journal_screen.dart';
import '../../features/dream_journal/presentation/dream_entry_screen.dart';
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
  static const String aiHub = '/ai-hub';
  static const String aiChat = '/ai-chat';
  static const String aiConversations = '/ai-conversations';
  static const String aiConversationDetail = '/ai-chat/:conversationId';
  static const String aiTransitInsight = '/ai-transit-insight';
  static const String aiChartReading = '/ai-chart-reading';
  static const String aiCompatibility = '/ai-compatibility';

  // Dream journal & journaling routes
  static const String dreamJournal = '/dream-journal';
  static const String dreamEntry = '/dream-journal/new';
  static const String journalPrompts = '/journal-prompts';

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
            path: AppRoutes.aiHub,
            name: 'aiHub',
            builder: (context, state) => const AiHubScreen(),
          ),
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
          GoRoute(
            path: AppRoutes.aiTransitInsight,
            name: 'aiTransitInsight',
            builder: (context, state) => const AiTransitInsightScreen(),
          ),
          GoRoute(
            path: AppRoutes.aiChartReading,
            name: 'aiChartReading',
            builder: (context, state) => const AiChartReadingScreen(),
          ),
          GoRoute(
            path: AppRoutes.aiCompatibility,
            name: 'aiCompatibility',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return AiCompatibilityScreen(
                person1: extra['person1'] as HumanDesignChart,
                person2: extra['person2'] as HumanDesignChart,
                compositeResult: extra['result'] as CompositeResult,
              );
            },
          ),
          // Dream journal & journaling routes
          GoRoute(
            path: AppRoutes.dreamJournal,
            name: 'dreamJournal',
            builder: (context, state) => const DreamJournalScreen(),
          ),
          GoRoute(
            path: AppRoutes.dreamEntry,
            name: 'dreamEntry',
            builder: (context, state) => const DreamEntryScreen(),
          ),
          GoRoute(
            path: AppRoutes.journalPrompts,
            name: 'journalPrompts',
            builder: (context, state) => const AiJournalPromptsScreen(),
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
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 4,
                runSpacing: 4,
                children: AppLocale.values.map((locale) {
                  final isSelected = locale == currentLocale;
                  return GestureDetector(
                    onTap: () {
                      ref.read(settingsProvider.notifier).setLocale(locale);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
      drawer: const _AppDrawer(),
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
            icon: const Icon(Icons.auto_awesome_outlined),
            activeIcon: const Icon(Icons.auto_awesome),
            label: AppLocalizations.of(context)!.nav_ai,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline),
            activeIcon: const Icon(Icons.people),
            label: AppLocalizations.of(context)!.nav_social,
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.chart) ||
        location.startsWith(AppRoutes.savedCharts)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.aiHub) ||
        location.startsWith(AppRoutes.aiChat) ||
        location.startsWith(AppRoutes.aiTransitInsight) ||
        location.startsWith(AppRoutes.aiChartReading) ||
        location.startsWith(AppRoutes.aiCompatibility) ||
        location.startsWith(AppRoutes.dreamJournal) ||
        location.startsWith(AppRoutes.journalPrompts)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.social) ||
        location.startsWith(AppRoutes.feed) ||
        location.startsWith(AppRoutes.discover) ||
        location.startsWith(AppRoutes.messages) ||
        location.startsWith(AppRoutes.stories) ||
        location.startsWith(AppRoutes.circles) ||
        location.startsWith(AppRoutes.events) ||
        location.startsWith('/event')) {
      return 3;
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
        context.go(AppRoutes.aiHub);
        break;
      case 3:
        context.go(AppRoutes.social);
        break;
    }
  }
}

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final chartAsync = ref.watch(userChartProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header with user info
            _buildDrawerHeader(context, theme, profileAsync, chartAsync),

            const SizedBox(height: 8),

            // Your Design
            _SectionHeader(title: l10n.home_yourDesign.toUpperCase()),
            _DrawerItem(
              icon: Icons.auto_graph,
              title: l10n.home_myChart,
              onTap: () => _navigate(context, AppRoutes.chart),
            ),
            _DrawerItem(
              icon: Icons.folder_outlined,
              title: l10n.chart_savedCharts,
              onTap: () => _navigate(context, AppRoutes.savedCharts),
            ),
            _DrawerItem(
              icon: Icons.compare_arrows,
              title: l10n.home_composite,
              onTap: () => _navigate(context, AppRoutes.composite),
            ),
            _DrawerItem(
              icon: Icons.group_work_outlined,
              title: l10n.home_penta,
              onTap: () => _navigate(context, AppRoutes.penta),
            ),

            const Divider(height: 24),

            // AI & Insights
            _SectionHeader(title: l10n.ai_chatTitle.toUpperCase()),
            _DrawerItem(
              icon: Icons.auto_awesome,
              title: l10n.ai_askAi,
              onTap: () => _navigate(context, AppRoutes.aiChat),
            ),
            _DrawerItem(
              icon: Icons.auto_awesome_outlined,
              title: l10n.ai_transitInsightTitle,
              onTap: () => _navigate(context, AppRoutes.aiTransitInsight),
            ),
            _DrawerItem(
              icon: Icons.menu_book_outlined,
              title: l10n.ai_chartReadingTitle,
              onTap: () => _navigate(context, AppRoutes.aiChartReading),
            ),
            _DrawerItem(
              icon: Icons.nights_stay_outlined,
              title: l10n.ai_dreamJournalTitle,
              onTap: () => _navigate(context, AppRoutes.dreamJournal),
            ),
            _DrawerItem(
              icon: Icons.edit_note,
              title: l10n.ai_journalPromptsTitle,
              onTap: () => _navigate(context, AppRoutes.journalPrompts),
            ),

            const Divider(height: 24),

            // Daily
            _SectionHeader(title: l10n.nav_today.toUpperCase()),
            _DrawerItem(
              icon: Icons.wb_sunny_outlined,
              title: l10n.transit_title,
              onTap: () => _navigate(context, AppRoutes.transits),
            ),
            _DrawerItem(
              icon: Icons.self_improvement,
              title: l10n.affirmation_title,
              onTap: () => _navigate(context, AppRoutes.affirmations),
            ),

            const Divider(height: 24),

            // Community
            _SectionHeader(title: l10n.nav_social.toUpperCase()),
            _DrawerItem(
              icon: Icons.people_outlined,
              title: l10n.social_title,
              onTap: () => _navigate(context, AppRoutes.social),
            ),
            _DrawerItem(
              icon: Icons.explore_outlined,
              title: l10n.discovery_title,
              onTap: () => _navigate(context, AppRoutes.discover),
            ),
            _DrawerItem(
              icon: Icons.dynamic_feed_outlined,
              title: l10n.thought_feedTitle,
              onTap: () => _navigate(context, AppRoutes.feed),
            ),
            _DrawerItem(
              icon: Icons.mail_outlined,
              title: l10n.messages_title,
              onTap: () => _navigate(context, AppRoutes.messages),
            ),
            _DrawerItem(
              icon: Icons.event_outlined,
              title: l10n.events_title,
              onTap: () => _navigate(context, AppRoutes.events),
            ),

            const Divider(height: 24),

            // Learn
            _SectionHeader(title: l10n.nav_learn.toUpperCase()),
            _DrawerItem(
              icon: Icons.quiz_outlined,
              title: l10n.quiz_title,
              onTap: () => _navigate(context, AppRoutes.quizzes),
            ),
            _DrawerItem(
              icon: Icons.route_outlined,
              title: l10n.learningPaths_title,
              onTap: () => _navigate(context, AppRoutes.learningPaths),
            ),
            _DrawerItem(
              icon: Icons.school_outlined,
              title: l10n.mentorship_title,
              onTap: () => _navigate(context, AppRoutes.mentorship),
            ),

            const Divider(height: 24),

            // Account
            _SectionHeader(title: l10n.settings_account.toUpperCase()),
            _DrawerItem(
              icon: Icons.person_outline,
              title: l10n.nav_profile,
              onTap: () => _navigate(context, AppRoutes.profile),
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              title: l10n.common_settings,
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.settings);
              },
            ),
            _DrawerItem(
              icon: Icons.star_outlined,
              title: l10n.premium_upgrade,
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.premium);
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(
    BuildContext context,
    ThemeData theme,
    AsyncValue<UserProfile?> profileAsync,
    AsyncValue<HumanDesignChart?> chartAsync,
  ) {
    final l10n = AppLocalizations.of(context)!;

    final userName = profileAsync.whenOrNull(
          data: (profile) => profile?.name,
        ) ??
        l10n.profile_defaultUserName;

    final avatarUrl = profileAsync.whenOrNull(
      data: (profile) => profile?.avatarUrl,
    );

    final hdType = chartAsync.whenOrNull(
      data: (chart) => chart?.type.displayName,
    );

    return InkWell(
      onTap: () => _navigate(context, AppRoutes.profile),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl) : null,
              child: avatarUrl == null
                  ? Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: theme.textTheme.titleLarge,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hdType != null)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        hdType,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    context.go(route);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 22),
      title: Text(title),
      onTap: onTap,
      visualDensity: const VisualDensity(vertical: -1),
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
