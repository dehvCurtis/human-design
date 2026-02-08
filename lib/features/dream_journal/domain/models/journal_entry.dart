import 'package:equatable/equatable.dart';

/// Type of journal entry
enum JournalEntryType {
  dream,
  journal;

  String get value => name;

  static JournalEntryType fromString(String value) {
    switch (value) {
      case 'dream':
        return JournalEntryType.dream;
      case 'journal':
        return JournalEntryType.journal;
      default:
        return JournalEntryType.dream;
    }
  }
}

/// A dream or journal entry
class JournalEntry extends Equatable {
  const JournalEntry({
    required this.id,
    required this.userId,
    required this.content,
    required this.entryType,
    required this.createdAt,
    this.aiInterpretation,
    this.transitSunGate,
    this.conversationId,
    this.prompt,
  });

  final String id;
  final String userId;
  final String content;
  final JournalEntryType entryType;
  final String? aiInterpretation;
  final int? transitSunGate;
  final String? conversationId;
  final String? prompt;
  final DateTime createdAt;

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      entryType: JournalEntryType.fromString(
        json['entry_type'] as String? ?? 'dream',
      ),
      aiInterpretation: json['ai_interpretation'] as String?,
      transitSunGate: json['transit_sun_gate'] as int?,
      conversationId: json['conversation_id'] as String?,
      prompt: json['prompt'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'content': content,
        'entry_type': entryType.value,
        'ai_interpretation': aiInterpretation,
        'transit_sun_gate': transitSunGate,
        'conversation_id': conversationId,
        'prompt': prompt,
        'created_at': createdAt.toIso8601String(),
      };

  JournalEntry copyWith({
    String? aiInterpretation,
    String? conversationId,
  }) {
    return JournalEntry(
      id: id,
      userId: userId,
      content: content,
      entryType: entryType,
      aiInterpretation: aiInterpretation ?? this.aiInterpretation,
      transitSunGate: transitSunGate,
      conversationId: conversationId ?? this.conversationId,
      prompt: prompt,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        content,
        entryType,
        aiInterpretation,
        transitSunGate,
        conversationId,
        prompt,
        createdAt,
      ];
}
