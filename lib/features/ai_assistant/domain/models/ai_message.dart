import 'package:equatable/equatable.dart';

/// Role of an AI chat message
enum AiMessageRole {
  user,
  assistant;

  String get value {
    switch (this) {
      case AiMessageRole.user:
        return 'user';
      case AiMessageRole.assistant:
        return 'assistant';
    }
  }

  static AiMessageRole fromString(String value) {
    switch (value) {
      case 'user':
        return AiMessageRole.user;
      case 'assistant':
        return AiMessageRole.assistant;
      default:
        throw ArgumentError('Invalid AiMessageRole: $value');
    }
  }
}

/// A single message in an AI conversation
class AiMessage extends Equatable {
  const AiMessage({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String conversationId;
  final AiMessageRole role;
  final String content;
  final DateTime createdAt;

  factory AiMessage.fromJson(Map<String, dynamic> json) {
    return AiMessage(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      role: AiMessageRole.fromString(json['role'] as String),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversation_id': conversationId,
        'role': role.value,
        'content': content,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, conversationId, role, content, createdAt];
}
