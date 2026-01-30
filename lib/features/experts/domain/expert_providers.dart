import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/supabase_provider.dart';
import '../data/expert_repository.dart';
import 'models/expert.dart';

/// Repository provider
final expertRepositoryProvider = Provider<ExpertRepository>((ref) {
  return ExpertRepository(
    supabaseClient: ref.watch(supabaseClientProvider),
  );
});

// ==================== Experts ====================

/// Get all verified experts
final verifiedExpertsProvider = FutureProvider<List<Expert>>((ref) async {
  final repository = ref.watch(expertRepositoryProvider);
  return repository.getVerifiedExperts();
});

/// Get verified experts by specialization
final expertsBySpecializationProvider = FutureProvider.family<List<Expert>, ExpertSpecialization>((ref, specialization) async {
  final repository = ref.watch(expertRepositoryProvider);
  return repository.getVerifiedExperts(specialization: specialization);
});

/// Get featured experts
final featuredExpertsProvider = FutureProvider<List<Expert>>((ref) async {
  final repository = ref.watch(expertRepositoryProvider);
  return repository.getFeaturedExperts();
});

/// Get a specific expert
final expertProvider = FutureProvider.family<Expert?, String>((ref, expertId) async {
  final repository = ref.watch(expertRepositoryProvider);
  return repository.getExpert(expertId);
});

/// Get current user's expert profile (if they are an expert)
final myExpertProfileProvider = FutureProvider<Expert?>((ref) async {
  final repository = ref.watch(expertRepositoryProvider);
  return repository.getMyExpertProfile();
});

/// Get current user's application status
final myExpertApplicationProvider = FutureProvider<ExpertApplication?>((ref) async {
  final repository = ref.watch(expertRepositoryProvider);
  return repository.getMyApplication();
});

/// Search experts
final expertSearchProvider = FutureProvider.family<List<Expert>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final repository = ref.watch(expertRepositoryProvider);
  return repository.searchExperts(query);
});

// ==================== Following ====================

/// Check if user follows an expert
final isFollowingExpertProvider = FutureProvider.family<bool, String>((ref, expertId) async {
  final repository = ref.watch(expertRepositoryProvider);
  return repository.isFollowing(expertId);
});

/// Get experts the user follows
final followedExpertsProvider = FutureProvider<List<Expert>>((ref) async {
  final repository = ref.watch(expertRepositoryProvider);
  return repository.getFollowedExperts();
});

// ==================== Reviews ====================

/// Get reviews for an expert
final expertReviewsProvider = FutureProvider.family<List<ExpertReview>, String>((ref, expertId) async {
  final repository = ref.watch(expertRepositoryProvider);
  return repository.getExpertReviews(expertId);
});

/// Get user's review for an expert
final userExpertReviewProvider = FutureProvider.family<ExpertReview?, String>((ref, expertId) async {
  final repository = ref.watch(expertRepositoryProvider);
  return repository.getUserReview(expertId);
});

// ==================== Notifier ====================

/// Notifier for expert mutations
class ExpertNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  ExpertRepository get _repository => ref.read(expertRepositoryProvider);

  /// Submit application to become an expert
  Future<ExpertApplication?> submitApplication({
    required String title,
    required String bio,
    required List<ExpertSpecialization> specializations,
    required List<String> credentials,
    int? yearsOfExperience,
    String? websiteUrl,
    List<String>? portfolioUrls,
  }) async {
    state = const AsyncValue.loading();
    try {
      final application = await _repository.submitApplication(
        title: title,
        bio: bio,
        specializations: specializations,
        credentials: credentials,
        yearsOfExperience: yearsOfExperience,
        websiteUrl: websiteUrl,
        portfolioUrls: portfolioUrls,
      );
      state = const AsyncValue.data(null);
      ref.invalidate(myExpertApplicationProvider);
      return application;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Follow an expert
  Future<bool> followExpert(String expertId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.followExpert(expertId);
      state = const AsyncValue.data(null);
      ref.invalidate(isFollowingExpertProvider(expertId));
      ref.invalidate(expertProvider(expertId));
      ref.invalidate(followedExpertsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Unfollow an expert
  Future<bool> unfollowExpert(String expertId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.unfollowExpert(expertId);
      state = const AsyncValue.data(null);
      ref.invalidate(isFollowingExpertProvider(expertId));
      ref.invalidate(expertProvider(expertId));
      ref.invalidate(followedExpertsProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Add a review
  Future<ExpertReview?> addReview({
    required String expertId,
    required int rating,
    String? content,
  }) async {
    state = const AsyncValue.loading();
    try {
      final review = await _repository.addReview(
        expertId: expertId,
        rating: rating,
        content: content,
      );
      state = const AsyncValue.data(null);
      ref.invalidate(expertReviewsProvider(expertId));
      ref.invalidate(userExpertReviewProvider(expertId));
      ref.invalidate(expertProvider(expertId));
      return review;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Update expert profile
  Future<bool> updateProfile({
    required String expertId,
    String? title,
    String? bio,
    List<ExpertSpecialization>? specializations,
    List<String>? credentials,
    int? yearsOfExperience,
    String? websiteUrl,
    Map<String, String>? socialLinks,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateExpertProfile(
        expertId: expertId,
        title: title,
        bio: bio,
        specializations: specializations,
        credentials: credentials,
        yearsOfExperience: yearsOfExperience,
        websiteUrl: websiteUrl,
        socialLinks: socialLinks,
      );
      state = const AsyncValue.data(null);
      ref.invalidate(expertProvider(expertId));
      ref.invalidate(myExpertProfileProvider);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final expertNotifierProvider = NotifierProvider<ExpertNotifier, AsyncValue<void>>(() {
  return ExpertNotifier();
});
