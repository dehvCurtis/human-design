// Models for the transit event community feature

/// Represents a major transit event that the community can experience together
class TransitEvent {
  const TransitEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.eventType,
    required this.gateNumber,
    this.channelId,
    required this.planet,
    required this.startsAt,
    required this.endsAt,
    this.imageUrl,
    this.participantCount = 0,
    this.postCount = 0,
    this.isActive = false,
    this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final TransitEventType eventType;
  final int gateNumber;
  final String? channelId;
  final String planet;
  final DateTime startsAt;
  final DateTime endsAt;
  final String? imageUrl;
  final int participantCount;
  final int postCount;
  final bool isActive;
  final DateTime? createdAt;

  /// Whether the event is currently happening
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return now.isAfter(startsAt) && now.isBefore(endsAt);
  }

  /// Whether the event is upcoming
  bool get isUpcoming => DateTime.now().isBefore(startsAt);

  /// Whether the event has ended
  bool get hasEnded => DateTime.now().isAfter(endsAt);

  /// Duration until the event starts (for upcoming events)
  Duration get timeUntilStart => startsAt.difference(DateTime.now());

  /// Duration until the event ends (for active events)
  Duration get timeUntilEnd => endsAt.difference(DateTime.now());

  /// Total duration of the event
  Duration get duration => endsAt.difference(startsAt);

  factory TransitEvent.fromJson(Map<String, dynamic> json) {
    return TransitEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      eventType: _parseEventType(json['event_type'] as String),
      gateNumber: json['gate_number'] as int,
      channelId: json['channel_id'] as String?,
      planet: json['planet'] as String,
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      imageUrl: json['image_url'] as String?,
      participantCount: json['participant_count'] as int? ?? 0,
      postCount: json['post_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'event_type': eventType.dbValue,
      'gate_number': gateNumber,
      'channel_id': channelId,
      'planet': planet,
      'starts_at': startsAt.toIso8601String(),
      'ends_at': endsAt.toIso8601String(),
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }

  TransitEvent copyWith({
    String? id,
    String? title,
    String? description,
    TransitEventType? eventType,
    int? gateNumber,
    String? channelId,
    String? planet,
    DateTime? startsAt,
    DateTime? endsAt,
    String? imageUrl,
    int? participantCount,
    int? postCount,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return TransitEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventType: eventType ?? this.eventType,
      gateNumber: gateNumber ?? this.gateNumber,
      channelId: channelId ?? this.channelId,
      planet: planet ?? this.planet,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      imageUrl: imageUrl ?? this.imageUrl,
      participantCount: participantCount ?? this.participantCount,
      postCount: postCount ?? this.postCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static TransitEventType _parseEventType(String value) {
    switch (value) {
      case 'sun_transit':
        return TransitEventType.sunTransit;
      case 'moon_transit':
        return TransitEventType.moonTransit;
      case 'new_year':
        return TransitEventType.newYear;
      case 'full_moon':
        return TransitEventType.fullMoon;
      case 'new_moon':
        return TransitEventType.newMoon;
      case 'planetary_return':
        return TransitEventType.planetaryReturn;
      case 'channel_activation':
        return TransitEventType.channelActivation;
      default:
        return TransitEventType.sunTransit;
    }
  }
}

/// Types of transit events
enum TransitEventType {
  sunTransit,
  moonTransit,
  newYear,
  fullMoon,
  newMoon,
  planetaryReturn,
  channelActivation,
}

extension TransitEventTypeExtension on TransitEventType {
  String get dbValue {
    switch (this) {
      case TransitEventType.sunTransit:
        return 'sun_transit';
      case TransitEventType.moonTransit:
        return 'moon_transit';
      case TransitEventType.newYear:
        return 'new_year';
      case TransitEventType.fullMoon:
        return 'full_moon';
      case TransitEventType.newMoon:
        return 'new_moon';
      case TransitEventType.planetaryReturn:
        return 'planetary_return';
      case TransitEventType.channelActivation:
        return 'channel_activation';
    }
  }

  String get displayName {
    switch (this) {
      case TransitEventType.sunTransit:
        return 'Sun Transit';
      case TransitEventType.moonTransit:
        return 'Moon Transit';
      case TransitEventType.newYear:
        return 'HD New Year';
      case TransitEventType.fullMoon:
        return 'Full Moon';
      case TransitEventType.newMoon:
        return 'New Moon';
      case TransitEventType.planetaryReturn:
        return 'Planetary Return';
      case TransitEventType.channelActivation:
        return 'Channel Activation';
    }
  }

  String get emoji {
    switch (this) {
      case TransitEventType.sunTransit:
        return '\u{2600}'; // ☀️
      case TransitEventType.moonTransit:
        return '\u{1F319}'; // 🌙
      case TransitEventType.newYear:
        return '\u{1F389}'; // 🎉
      case TransitEventType.fullMoon:
        return '\u{1F315}'; // 🌕
      case TransitEventType.newMoon:
        return '\u{1F311}'; // 🌑
      case TransitEventType.planetaryReturn:
        return '\u{1FA90}'; // 🪐
      case TransitEventType.channelActivation:
        return '\u{26A1}'; // ⚡
    }
  }
}

/// User participation in a transit event
class TransitEventParticipation {
  const TransitEventParticipation({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.joinedAt,
    this.reflection,
    this.mood,
  });

  final String id;
  final String userId;
  final String eventId;
  final DateTime joinedAt;
  final String? reflection;
  final String? mood;

  factory TransitEventParticipation.fromJson(Map<String, dynamic> json) {
    return TransitEventParticipation(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      eventId: json['event_id'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      reflection: json['reflection'] as String?,
      mood: json['mood'] as String?,
    );
  }
}

/// Post associated with a transit event
class TransitEventPost {
  const TransitEventPost({
    required this.postId,
    required this.eventId,
    required this.createdAt,
  });

  final String postId;
  final String eventId;
  final DateTime createdAt;

  factory TransitEventPost.fromJson(Map<String, dynamic> json) {
    return TransitEventPost(
      postId: json['post_id'] as String,
      eventId: json['event_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Collective insight from a transit event
class TransitEventInsight {
  const TransitEventInsight({
    required this.eventId,
    required this.totalParticipants,
    required this.totalPosts,
    this.topKeywords,
    this.moodDistribution,
    this.typeDistribution,
  });

  final String eventId;
  final int totalParticipants;
  final int totalPosts;
  final List<String>? topKeywords;
  final Map<String, int>? moodDistribution;
  final Map<String, int>? typeDistribution;

  factory TransitEventInsight.fromJson(Map<String, dynamic> json) {
    return TransitEventInsight(
      eventId: json['event_id'] as String,
      totalParticipants: json['total_participants'] as int? ?? 0,
      totalPosts: json['total_posts'] as int? ?? 0,
      topKeywords: (json['top_keywords'] as List<dynamic>?)?.cast<String>(),
      moodDistribution: (json['mood_distribution'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int)),
      typeDistribution: (json['type_distribution'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int)),
    );
  }
}
