import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../chart/domain/models/human_design_chart.dart';

/// Chart visibility levels for user profiles
enum ChartVisibility {
  /// Only the owner can see their chart
  private,
  /// Mutual followers can view the chart
  friends,
  /// Anyone can view the chart
  public;

  /// Parse from string (for database values)
  static ChartVisibility fromString(String? value) {
    switch (value) {
      case 'public':
        return ChartVisibility.public;
      case 'friends':
        return ChartVisibility.friends;
      case 'private':
      default:
        return ChartVisibility.private;
    }
  }
}

/// Repository for user profile operations
class ProfileRepository {
  ProfileRepository({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  /// Get current user's profile
  Future<UserProfile?> getCurrentProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserProfile.fromJson(response);
  }

  /// Create or update user profile
  Future<UserProfile> upsertProfile(UserProfile profile) async {
    final response = await _client
        .from('profiles')
        .upsert(profile.toJson())
        .select()
        .single();

    return UserProfile.fromJson(response);
  }

  /// Update profile birth data
  ///
  /// [birthDateTime] is the local birth time (naive DateTime, not UTC)
  /// [timezone] is the IANA timezone string for the birth location
  Future<void> updateBirthData({
    required DateTime birthDateTime,
    required BirthLocation birthLocation,
    required String timezone,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('User not authenticated');

    // Convert local birth time to UTC using the birth location's timezone
    // This ensures the stored UTC time is correct regardless of device timezone
    DateTime utcBirthDateTime;
    try {
      final location = tz.getLocation(timezone);
      final localTime = tz.TZDateTime(
        location,
        birthDateTime.year,
        birthDateTime.month,
        birthDateTime.day,
        birthDateTime.hour,
        birthDateTime.minute,
        birthDateTime.second,
      );
      utcBirthDateTime = localTime.toUtc();
    } catch (e) {
      // Fallback to device timezone if timezone lookup fails
      utcBirthDateTime = birthDateTime.toUtc();
    }

    await _client.from('profiles').update({
      'birth_date': utcBirthDateTime.toIso8601String(),
      'birth_location': birthLocation.toJson(),
      'timezone': timezone,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  /// Save a chart to the database
  Future<void> saveChart(HumanDesignChart chart) async {
    try {
      // Ensure birth datetime is stored as UTC
      DateTime utcBirthDateTime;
      if (chart.birthDateTime.isUtc) {
        utcBirthDateTime = chart.birthDateTime;
      } else {
        // Convert local time to UTC using chart's timezone
        try {
          final location = tz.getLocation(chart.timezone);
          final localTime = tz.TZDateTime(
            location,
            chart.birthDateTime.year,
            chart.birthDateTime.month,
            chart.birthDateTime.day,
            chart.birthDateTime.hour,
            chart.birthDateTime.minute,
            chart.birthDateTime.second,
          );
          utcBirthDateTime = localTime.toUtc();
        } catch (e) {
          utcBirthDateTime = chart.birthDateTime.toUtc();
        }
      }

      await _client.from('charts').upsert({
        'id': chart.id,
        'user_id': chart.userId,
        'name': chart.name,
        'birth_datetime': utcBirthDateTime.toIso8601String(),
        'birth_location': chart.birthLocation.toJson(),
        'timezone': chart.timezone,
        'type': chart.type.name,
        'authority': chart.authority.name,
        'profile': chart.profile.notation,
        'definition': chart.definition.name,
        'defined_centers': chart.definedCenters.map((c) => c.name).toList(),
        'conscious_gates': chart.consciousGates.toList(),
        'unconscious_gates': chart.unconsciousGates.toList(),
        'created_at': chart.createdAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Re-throw with more context
      throw Exception('Failed to save chart: $e');
    }
  }

  /// Get user's charts
  Future<List<ChartSummary>> getUserCharts() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from('charts')
          .select('id, name, type, created_at')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ChartSummary.fromJson(json))
          .toList();
    } catch (e) {
      // Return empty list if charts table doesn't exist or query fails
      return [];
    }
  }

  /// Get a specific chart by ID
  Future<Map<String, dynamic>?> getChartById(String chartId) async {
    final response = await _client
        .from('charts')
        .select()
        .eq('id', chartId)
        .maybeSingle();

    return response;
  }

  /// Get charts for multiple user IDs (for Penta analysis)
  Future<List<Map<String, dynamic>>> getChartsByUserIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];

    final response = await _client
        .from('charts')
        .select()
        .inFilter('user_id', userIds);

    return (response as List).cast<Map<String, dynamic>>();
  }

  /// Get a user's profile by ID
  Future<UserProfile?> getProfileById(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserProfile.fromJson(response);
  }

  /// Get profiles for multiple user IDs
  Future<List<UserProfile>> getProfilesByIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];

    final response = await _client
        .from('profiles')
        .select()
        .inFilter('id', userIds);

    return (response as List)
        .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Delete a chart
  Future<void> deleteChart(String chartId) async {
    await _client.from('charts').delete().eq('id', chartId);
  }

  /// Update premium status
  Future<void> updatePremiumStatus(bool isPremium) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('User not authenticated');

    await _client.from('profiles').update({
      'is_premium': isPremium,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  /// Update chart visibility setting
  Future<void> setChartVisibility(ChartVisibility visibility) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('User not authenticated');

    await _client.from('profiles').update({
      'chart_visibility': visibility.name,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  /// Get share count for current month
  Future<int> getMonthlyShareCount() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return 0;

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    final response = await _client
        .from('shares')
        .select('id')
        .eq('user_id', userId)
        .gte('created_at', startOfMonth.toIso8601String());

    return (response as List).length;
  }

  /// Find a user by email address
  /// Returns null if not found or if it's the current user
  Future<UserSearchResult?> findUserByEmail(String email) async {
    final currentUserId = _client.auth.currentUser?.id;
    final normalizedEmail = email.trim().toLowerCase();

    final response = await _client
        .from('profiles')
        .select('id, name, avatar_url, email')
        .eq('email', normalizedEmail)
        .maybeSingle();

    if (response == null) return null;

    final userId = response['id'] as String;
    // Don't return the current user
    if (userId == currentUserId) return null;

    return UserSearchResult.fromJson(response);
  }
}

/// User profile data
class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.birthDate,
    this.birthLocation,
    this.timezone,
    this.isPremium = false,
    this.preferredLanguage = 'en',
    this.chartVisibility = ChartVisibility.private,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final DateTime? birthDate;
  final BirthLocation? birthLocation;
  final String? timezone;
  final bool isPremium;
  final String preferredLanguage;
  final ChartVisibility chartVisibility;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get hasBirthData =>
      birthDate != null && birthLocation != null && timezone != null;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      birthLocation: json['birth_location'] != null
          ? BirthLocation.fromJson(json['birth_location'] as Map<String, dynamic>)
          : null,
      timezone: json['timezone'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
      preferredLanguage: json['preferred_language'] as String? ?? 'en',
      chartVisibility: ChartVisibility.fromString(json['chart_visibility'] as String?),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'birth_date': birthDate?.toIso8601String(),
      'birth_location': birthLocation?.toJson(),
      'timezone': timezone,
      'is_premium': isPremium,
      'preferred_language': preferredLanguage,
      'chart_visibility': chartVisibility.name,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? birthDate,
    BirthLocation? birthLocation,
    String? timezone,
    bool? isPremium,
    String? preferredLanguage,
    ChartVisibility? chartVisibility,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      birthDate: birthDate ?? this.birthDate,
      birthLocation: birthLocation ?? this.birthLocation,
      timezone: timezone ?? this.timezone,
      isPremium: isPremium ?? this.isPremium,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      chartVisibility: chartVisibility ?? this.chartVisibility,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Summary of a chart for list display
class ChartSummary {
  const ChartSummary({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String type;
  final DateTime createdAt;

  factory ChartSummary.fromJson(Map<String, dynamic> json) {
    return ChartSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Result from searching for a user by email
class UserSearchResult {
  const UserSearchResult({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;

  String get displayName => name ?? email;

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}
