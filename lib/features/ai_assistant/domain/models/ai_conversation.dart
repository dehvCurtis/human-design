import 'package:equatable/equatable.dart';

/// Context type for an AI conversation
enum AiContextType {
  chart,
  transit,
  general,
  transitInsight,
  chartReading,
  compatibility,
  dream,
  journal;

  String get value {
    switch (this) {
      case AiContextType.chart:
        return 'chart';
      case AiContextType.transit:
        return 'transit';
      case AiContextType.general:
        return 'general';
      case AiContextType.transitInsight:
        return 'transit_insight';
      case AiContextType.chartReading:
        return 'chart_reading';
      case AiContextType.compatibility:
        return 'compatibility';
      case AiContextType.dream:
        return 'dream';
      case AiContextType.journal:
        return 'journal';
    }
  }

  static AiContextType fromString(String value) {
    switch (value) {
      case 'chart':
        return AiContextType.chart;
      case 'transit':
        return AiContextType.transit;
      case 'general':
        return AiContextType.general;
      case 'transit_insight':
        return AiContextType.transitInsight;
      case 'chart_reading':
        return AiContextType.chartReading;
      case 'compatibility':
        return AiContextType.compatibility;
      case 'dream':
        return AiContextType.dream;
      case 'journal':
        return AiContextType.journal;
      default:
        return AiContextType.general;
    }
  }
}

/// An AI chat conversation
class AiConversation extends Equatable {
  const AiConversation({
    required this.id,
    required this.userId,
    required this.contextType,
    required this.createdAt,
    this.title,
    this.lastMessageAt,
    this.messageCount = 0,
  });

  final String id;
  final String userId;
  final String? title;
  final AiContextType contextType;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final int messageCount;

  factory AiConversation.fromJson(Map<String, dynamic> json) {
    return AiConversation(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String?,
      contextType: AiContextType.fromString(
        json['context_type'] as String? ?? 'general',
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      messageCount: json['message_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'context_type': contextType.value,
        'created_at': createdAt.toIso8601String(),
        'last_message_at': lastMessageAt?.toIso8601String(),
        'message_count': messageCount,
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        contextType,
        createdAt,
        lastMessageAt,
        messageCount,
      ];
}
