/// Models for Direct Messaging feature

enum MessageType {
  text,
  chartShare,
  transitShare,
  image,
}

class Conversation {
  const Conversation({
    required this.id,
    required this.participantIds,
    required this.participants,
    this.lastMessageAt,
    this.lastMessagePreview,
    required this.createdAt,
    this.updatedAt,
    this.unreadCount = 0,
  });

  final String id;
  final List<String> participantIds;
  final List<ConversationParticipant> participants;
  final DateTime? lastMessageAt;
  final String? lastMessagePreview;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int unreadCount;

  /// Get the other participant in a 1:1 conversation
  ConversationParticipant? getOtherParticipant(String currentUserId) {
    return participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => participants.first,
    );
  }

  factory Conversation.fromJson(
    Map<String, dynamic> json, {
    List<ConversationParticipant>? participants,
    int unreadCount = 0,
  }) {
    return Conversation(
      id: json['id'] as String,
      participantIds: (json['participant_ids'] as List<dynamic>).cast<String>(),
      participants: participants ?? [],
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessagePreview: json['last_message_preview'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      unreadCount: unreadCount,
    );
  }

  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    List<ConversationParticipant>? participants,
    DateTime? lastMessageAt,
    String? lastMessagePreview,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? unreadCount,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      participants: participants ?? this.participants,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class ConversationParticipant {
  const ConversationParticipant({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.hdType,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final String? hdType;

  factory ConversationParticipant.fromJson(Map<String, dynamic> json) {
    return ConversationParticipant(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      avatarUrl: json['avatar_url'] as String?,
      hdType: json['hd_type'] as String?,
    );
  }
}

class DirectMessage {
  const DirectMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    this.senderAvatarUrl,
    required this.content,
    required this.messageType,
    this.sharedChartId,
    this.mediaUrl,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String? senderAvatarUrl;
  final String content;
  final MessageType messageType;
  final String? sharedChartId;
  final String? mediaUrl;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  bool isMine(String currentUserId) => senderId == currentUserId;

  factory DirectMessage.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] as Map<String, dynamic>?;

    return DirectMessage(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: sender?['name'] as String?,
      senderAvatarUrl: sender?['avatar_url'] as String?,
      content: json['content'] as String,
      messageType: _parseMessageType(json['message_type'] as String),
      sharedChartId: json['shared_chart_id'] as String?,
      mediaUrl: json['media_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  DirectMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderAvatarUrl,
    String? content,
    MessageType? messageType,
    String? sharedChartId,
    String? mediaUrl,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return DirectMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      sharedChartId: sharedChartId ?? this.sharedChartId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static MessageType _parseMessageType(String value) {
    switch (value) {
      case 'text':
        return MessageType.text;
      case 'chart_share':
        return MessageType.chartShare;
      case 'transit_share':
        return MessageType.transitShare;
      case 'image':
        return MessageType.image;
      default:
        return MessageType.text;
    }
  }
}

extension MessageTypeExtension on MessageType {
  String get dbValue {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.chartShare:
        return 'chart_share';
      case MessageType.transitShare:
        return 'transit_share';
      case MessageType.image:
        return 'image';
    }
  }
}
