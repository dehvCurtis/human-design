import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/expert.dart';

/// Repository for Verified Expert System operations
class ExpertRepository {
  ExpertRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  /// Escape ILIKE special characters to prevent wildcard injection
  static String _escapeIlike(String input) =>
      input.replaceAll('\\', '\\\\').replaceAll('%', '\\%').replaceAll('_', '\\_');

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==================== Expert Profiles ====================

  /// Get all verified experts
  Future<List<Expert>> getVerifiedExperts({
    ExpertSpecialization? specialization,
    int limit = 50,
  }) async {
    var query = _client
        .from('experts')
        .select('''
          *,
          user:profiles!experts_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('verification_status', 'verified');

    if (specialization != null) {
      query = query.contains('specializations', [specialization.dbValue]);
    }

    final response = await query
        .order('follower_count', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => Expert.fromJson(json))
        .toList();
  }

  /// Get an expert by ID
  Future<Expert?> getExpert(String expertId) async {
    final response = await _client
        .from('experts')
        .select('''
          *,
          user:profiles!experts_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('id', expertId)
        .maybeSingle();

    if (response == null) return null;
    return Expert.fromJson(response);
  }

  /// Get expert by user ID
  Future<Expert?> getExpertByUserId(String userId) async {
    final response = await _client
        .from('experts')
        .select('''
          *,
          user:profiles!experts_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return Expert.fromJson(response);
  }

  /// Get current user's expert profile
  Future<Expert?> getMyExpertProfile() async {
    final userId = _currentUserId;
    if (userId == null) return null;
    return getExpertByUserId(userId);
  }

  /// Search experts by name or specialization
  Future<List<Expert>> searchExperts(String query, {int limit = 20}) async {
    final response = await _client
        .from('experts')
        .select('''
          *,
          user:profiles!experts_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('verification_status', 'verified')
        .or('title.ilike.%${_escapeIlike(query)}%,bio.ilike.%${_escapeIlike(query)}%')
        .order('follower_count', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => Expert.fromJson(json))
        .toList();
  }

  /// Get featured experts (high ratings + high follower count)
  Future<List<Expert>> getFeaturedExperts({int limit = 10}) async {
    final response = await _client
        .from('experts')
        .select('''
          *,
          user:profiles!experts_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('verification_status', 'verified')
        .order('average_rating', ascending: false)
        .order('follower_count', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => Expert.fromJson(json))
        .toList();
  }

  // ==================== Expert Applications ====================

  /// Submit application to become a verified expert
  Future<ExpertApplication> submitApplication({
    required String title,
    required String bio,
    required List<ExpertSpecialization> specializations,
    required List<String> credentials,
    int? yearsOfExperience,
    String? websiteUrl,
    List<String>? portfolioUrls,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('expert_applications').insert({
      'user_id': userId,
      'title': title,
      'bio': bio,
      'specializations': specializations.map((s) => s.dbValue).toList(),
      'credentials': credentials,
      'years_of_experience': yearsOfExperience,
      'website_url': websiteUrl,
      'portfolio_urls': portfolioUrls,
      'status': 'pending',
    }).select().single();

    return ExpertApplication.fromJson(response);
  }

  /// Get current user's application status
  Future<ExpertApplication?> getMyApplication() async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('expert_applications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return ExpertApplication.fromJson(response);
  }

  // ==================== Following ====================

  /// Follow an expert
  Future<void> followExpert(String expertId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client.from('expert_follows').insert({
      'expert_id': expertId,
      'user_id': userId,
    });

    // Update follower count
    await _client.rpc('increment_expert_follower_count', params: {
      'target_expert_id': expertId,
    });
  }

  /// Unfollow an expert
  Future<void> unfollowExpert(String expertId) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    await _client
        .from('expert_follows')
        .delete()
        .eq('expert_id', expertId)
        .eq('user_id', userId);

    // Update follower count
    await _client.rpc('decrement_expert_follower_count', params: {
      'target_expert_id': expertId,
    });
  }

  /// Check if user follows an expert
  Future<bool> isFollowing(String expertId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    final response = await _client
        .from('expert_follows')
        .select('id')
        .eq('expert_id', expertId)
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }

  /// Get experts the current user follows
  Future<List<Expert>> getFollowedExperts() async {
    final userId = _currentUserId;
    if (userId == null) return [];

    final response = await _client
        .from('expert_follows')
        .select('''
          expert:experts(
            *,
            user:profiles!experts_user_id_fkey(id, name, avatar_url)
          )
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Expert.fromJson(json['expert'] as Map<String, dynamic>))
        .toList();
  }

  // ==================== Reviews ====================

  /// Add a review for an expert
  Future<ExpertReview> addReview({
    required String expertId,
    required int rating,
    String? content,
  }) async {
    final userId = _currentUserId;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client.from('expert_reviews').insert({
      'expert_id': expertId,
      'user_id': userId,
      'rating': rating,
      'content': content,
    }).select('''
          *,
          user:profiles!expert_reviews_user_id_fkey(id, name, avatar_url)
        ''').single();

    // Update expert's average rating
    await _client.rpc('update_expert_rating', params: {
      'target_expert_id': expertId,
    });

    return ExpertReview.fromJson(response);
  }

  /// Get reviews for an expert
  Future<List<ExpertReview>> getExpertReviews(String expertId, {int limit = 50}) async {
    final response = await _client
        .from('expert_reviews')
        .select('''
          *,
          user:profiles!expert_reviews_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('expert_id', expertId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => ExpertReview.fromJson(json))
        .toList();
  }

  /// Get user's review for an expert
  Future<ExpertReview?> getUserReview(String expertId) async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('expert_reviews')
        .select('''
          *,
          user:profiles!expert_reviews_user_id_fkey(id, name, avatar_url)
        ''')
        .eq('expert_id', expertId)
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return ExpertReview.fromJson(response);
  }

  // ==================== Update Profile ====================

  /// Update expert profile (for verified experts)
  Future<void> updateExpertProfile({
    required String expertId,
    String? title,
    String? bio,
    List<ExpertSpecialization>? specializations,
    List<String>? credentials,
    int? yearsOfExperience,
    String? websiteUrl,
    Map<String, String>? socialLinks,
  }) async {
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    if (bio != null) updates['bio'] = bio;
    if (specializations != null) {
      updates['specializations'] = specializations.map((s) => s.dbValue).toList();
    }
    if (credentials != null) updates['credentials'] = credentials;
    if (yearsOfExperience != null) updates['years_of_experience'] = yearsOfExperience;
    if (websiteUrl != null) updates['website_url'] = websiteUrl;
    if (socialLinks != null) updates['social_links'] = socialLinks;

    if (updates.isEmpty) return;

    await _client
        .from('experts')
        .update(updates)
        .eq('id', expertId);
  }
}
