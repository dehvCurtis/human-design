import 'package:equatable/equatable.dart';

/// Tracks AI message usage for a user in the current billing period
class AiUsage extends Equatable {
  const AiUsage({
    required this.messagesThisMonth,
    required this.limit,
    this.bonusMessages = 0,
  });

  final int messagesThisMonth;
  final int limit;
  final int bonusMessages;

  /// Effective limit including purchased bonus messages
  int get effectiveLimit => limit + bonusMessages;

  /// Whether the user can send another AI message
  bool get canSendMessage => messagesThisMonth < effectiveLimit;

  /// Messages remaining this month
  int get remaining => (effectiveLimit - messagesThisMonth).clamp(0, effectiveLimit);

  factory AiUsage.fromJson(Map<String, dynamic> json, {required int limit}) {
    return AiUsage(
      messagesThisMonth: json['messages_count'] as int? ?? 0,
      limit: limit,
      bonusMessages: json['bonus_messages'] as int? ?? 0,
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
  List<Object?> get props => [messagesThisMonth, limit, bonusMessages];
}
