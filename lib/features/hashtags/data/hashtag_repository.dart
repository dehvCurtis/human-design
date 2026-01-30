import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/hashtag.dart';

/// Repository for hashtag operations
class HashtagRepository {
  HashtagRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  // ==================== Hashtag CRUD ====================

  /// Get or create a hashtag by name
  Future<Hashtag> getOrCreateHashtag(String name) async {
    final normalizedName = name.toLowerCase().trim();

    // Try to get existing
    final existing = await _client
        .from('hashtags')
        .select()
        .eq('name', normalizedName)
        .maybeSingle();

    if (existing != null) {
      return Hashtag.fromJson(existing);
    }

    // Create new hashtag
    final response = await _client
        .from('hashtags')
        .insert({'name': normalizedName})
        .select()
        .single();

    return Hashtag.fromJson(response);
  }

  /// Get a hashtag by name
  Future<Hashtag?> getHashtag(String name) async {
    final response = await _client
        .from('hashtags')
        .select()
        .eq('name', name.toLowerCase())
        .maybeSingle();

    if (response == null) return null;
    return Hashtag.fromJson(response);
  }

  /// Get hashtag by ID
  Future<Hashtag?> getHashtagById(String id) async {
    final response = await _client
        .from('hashtags')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Hashtag.fromJson(response);
  }

  /// Search hashtags by prefix
  Future<List<Hashtag>> searchHashtags(String query, {int limit = 20}) async {
    final response = await _client
        .from('hashtags')
        .select()
        .ilike('name', '${query.toLowerCase()}%')
        .order('post_count', ascending: false)
        .limit(limit);

    return (response as List).map((json) => Hashtag.fromJson(json)).toList();
  }

  // ==================== Post-Hashtag Associations ====================

  /// Associate hashtags with a post
  Future<void> addHashtagsToPost(String postId, List<String> hashtagNames) async {
    if (hashtagNames.isEmpty) return;

    // Get or create all hashtags
    final hashtags = await Future.wait(
      hashtagNames.map((name) => getOrCreateHashtag(name)),
    );

    // Create associations
    final associations = hashtags.map((hashtag) => {
      'post_id': postId,
      'hashtag_id': hashtag.id,
    }).toList();

    await _client.from('post_hashtags').upsert(
      associations,
      onConflict: 'post_id,hashtag_id',
    );

    // Update hashtag post counts and last_used_at
    for (final hashtag in hashtags) {
      await _client.rpc('increment_hashtag_count', params: {
        'hashtag_id': hashtag.id,
      });
    }
  }

  /// Remove all hashtag associations for a post
  Future<void> removeHashtagsFromPost(String postId) async {
    // Get current associations to decrement counts
    final existing = await _client
        .from('post_hashtags')
        .select('hashtag_id')
        .eq('post_id', postId);

    // Delete associations
    await _client.from('post_hashtags').delete().eq('post_id', postId);

    // Decrement counts
    for (final assoc in existing as List) {
      await _client.rpc('decrement_hashtag_count', params: {
        'hashtag_id': assoc['hashtag_id'],
      });
    }
  }

  /// Get all hashtags for a post
  Future<List<Hashtag>> getHashtagsForPost(String postId) async {
    final response = await _client
        .from('post_hashtags')
        .select('hashtag:hashtags(*)')
        .eq('post_id', postId);

    return (response as List)
        .map((json) => Hashtag.fromJson(json['hashtag']))
        .toList();
  }

  // ==================== Trending & Discovery ====================

  /// Get trending hashtags (most used in last 24 hours)
  Future<List<TrendingHashtag>> getTrendingHashtags({int limit = 10}) async {
    final response = await _client.rpc('get_trending_hashtags', params: {
      'limit_count': limit,
    });

    return (response as List)
        .map((json) => TrendingHashtag.fromJson(json))
        .toList();
  }

  /// Get popular hashtags overall
  Future<List<Hashtag>> getPopularHashtags({int limit = 20}) async {
    final response = await _client
        .from('hashtags')
        .select()
        .gt('post_count', 0)
        .order('post_count', ascending: false)
        .limit(limit);

    return (response as List).map((json) => Hashtag.fromJson(json)).toList();
  }

  /// Get HD-related hashtags
  Future<List<Hashtag>> getHdHashtags({int limit = 20}) async {
    final allHashtags = await getPopularHashtags(limit: 100);
    return allHashtags.where((h) => h.isHdHashtag).take(limit).toList();
  }

  /// Get posts by hashtag
  Future<List<String>> getPostIdsByHashtag(
    String hashtagName, {
    int limit = 20,
    int offset = 0,
  }) async {
    final hashtag = await getHashtag(hashtagName);
    if (hashtag == null) return [];

    final response = await _client
        .from('post_hashtags')
        .select('post_id')
        .eq('hashtag_id', hashtag.id)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List).map((json) => json['post_id'] as String).toList();
  }

  /// Get suggested hashtags based on content
  Future<List<Hashtag>> getSuggestedHashtags(String content, {int limit = 5}) async {
    // Extract any existing hashtags from content
    final existingTags = HashtagParser.extractHashtags(content);

    // Get related hashtags based on what user is typing
    final suggestions = <Hashtag>[];

    // If content mentions HD concepts, suggest related hashtags
    final contentLower = content.toLowerCase();

    if (contentLower.contains('gate')) {
      final gateHashtags = await searchHashtags('gate', limit: 3);
      suggestions.addAll(gateHashtags);
    }

    if (contentLower.contains('generator') || contentLower.contains('sacral')) {
      final genHashtag = await getHashtag('generator');
      if (genHashtag != null) suggestions.add(genHashtag);
    }

    if (contentLower.contains('projector')) {
      final projHashtag = await getHashtag('projector');
      if (projHashtag != null) suggestions.add(projHashtag);
    }

    if (contentLower.contains('transit')) {
      final transitHashtag = await getHashtag('transits');
      if (transitHashtag != null) suggestions.add(transitHashtag);
    }

    // Fill remaining with popular hashtags
    if (suggestions.length < limit) {
      final popular = await getPopularHashtags(limit: limit * 2);
      for (final hashtag in popular) {
        if (suggestions.length >= limit) break;
        if (!suggestions.any((h) => h.name == hashtag.name) &&
            !existingTags.contains(hashtag.name)) {
          suggestions.add(hashtag);
        }
      }
    }

    return suggestions.take(limit).toList();
  }

  // ==================== Analytics ====================

  /// Get hashtag usage over time (for charts)
  Future<List<Map<String, dynamic>>> getHashtagUsageHistory(
    String hashtagId, {
    int days = 7,
  }) async {
    final response = await _client.rpc('get_hashtag_usage_history', params: {
      'target_hashtag_id': hashtagId,
      'days_back': days,
    });

    return (response as List).cast<Map<String, dynamic>>();
  }
}
