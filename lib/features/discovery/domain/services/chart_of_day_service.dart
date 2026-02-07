import 'package:supabase_flutter/supabase_flutter.dart';

/// Service to fetch the Chart of the Day.
///
/// The featured user is selected server-side by a Supabase cron function
/// — never by the client. This prevents manipulation.
class ChartOfDayService {
  ChartOfDayService({required SupabaseClient supabaseClient})
      : _client = supabaseClient;

  final SupabaseClient _client;

  /// Get today's featured chart user.
  /// Returns null if no chart of the day is set for today.
  Future<ChartOfDayEntry?> getTodaysFeaturedChart() async {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final data = await _client
        .from('chart_of_day')
        .select('*, user:profiles!user_id(id, display_name, full_name, avatar_url)')
        .eq('featured_date', dateStr)
        .maybeSingle();

    if (data == null) return null;

    return ChartOfDayEntry.fromJson(data);
  }
}

/// Chart of the Day entry
class ChartOfDayEntry {
  const ChartOfDayEntry({
    required this.id,
    required this.userId,
    required this.featuredDate,
    this.reason,
    this.userName,
    this.avatarUrl,
  });

  final String id;
  final String userId;
  final DateTime featuredDate;
  final String? reason;
  final String? userName;
  final String? avatarUrl;

  factory ChartOfDayEntry.fromJson(Map<String, dynamic> json) {
    return ChartOfDayEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      featuredDate: DateTime.parse(json['featured_date'] as String),
      reason: json['reason'] as String?,
      userName: json['user']?['display_name'] as String? ??
          json['user']?['full_name'] as String?,
      avatarUrl: json['user']?['avatar_url'] as String?,
    );
  }
}
