import 'package:equatable/equatable.dart';

/// Tracks AI message usage for a user in the current billing period
class AiUsage extends Equatable {
  const AiUsage({
    required this.messagesThisMonth,
    required this.limit,
  });

  final int messagesThisMonth;
  final int limit;

  /// Whether the user can send another AI message
  bool get canSendMessage => messagesThisMonth < limit;

  /// Messages remaining this month
  int get remaining => (limit - messagesThisMonth).clamp(0, limit);

  factory AiUsage.fromJson(Map<String, dynamic> json, {required int limit}) {
    return AiUsage(
      messagesThisMonth: json['messages_count'] as int? ?? 0,
      limit: limit,
    );
  }

  /// Default usage for premium users (unlimited)
  factory AiUsage.unlimited() {
    return const AiUsage(
      messagesThisMonth: 0,
      limit: 999999,
    );
  }

  /// Default empty usage
  factory AiUsage.empty({required int limit}) {
    return AiUsage(
      messagesThisMonth: 0,
      limit: limit,
    );
  }

  @override
  List<Object?> get props => [messagesThisMonth, limit];
}
