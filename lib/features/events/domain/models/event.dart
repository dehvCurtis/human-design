import 'package:equatable/equatable.dart';

/// Type of community event
enum EventType {
  online,
  inPerson,
  hybrid;

  String get value {
    switch (this) {
      case EventType.online:
        return 'online';
      case EventType.inPerson:
        return 'in_person';
      case EventType.hybrid:
        return 'hybrid';
    }
  }

  static EventType fromString(String value) {
    switch (value) {
      case 'online':
        return EventType.online;
      case 'in_person':
        return EventType.inPerson;
      case 'hybrid':
        return EventType.hybrid;
      default:
        return EventType.online;
    }
  }
}

/// A community event
class CommunityEvent extends Equatable {
  const CommunityEvent({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.eventType,
    required this.startsAt,
    required this.endsAt,
    required this.createdAt,
    this.location,
    this.virtualLink,
    this.hdTypeFilter,
    this.gateThemes = const [],
    this.maxParticipants,
    this.currentParticipants = 0,
    this.creatorName,
  });

  final String id;
  final String creatorId;
  final String title;
  final String description;
  final EventType eventType;
  final DateTime startsAt;
  final DateTime endsAt;
  final String? location;
  final String? virtualLink;
  final String? hdTypeFilter;
  final List<int> gateThemes;
  final int? maxParticipants;
  final int currentParticipants;
  final DateTime createdAt;
  final String? creatorName;

  bool get isUpcoming => startsAt.isAfter(DateTime.now());
  bool get isOngoing =>
      startsAt.isBefore(DateTime.now()) && endsAt.isAfter(DateTime.now());
  bool get isPast => endsAt.isBefore(DateTime.now());
  bool get isFull =>
      maxParticipants != null && currentParticipants >= maxParticipants!;

  factory CommunityEvent.fromJson(Map<String, dynamic> json) {
    return CommunityEvent(
      id: json['id'] as String,
      creatorId: json['creator_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      eventType: EventType.fromString(json['event_type'] as String? ?? 'online'),
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      location: json['location'] as String?,
      virtualLink: json['virtual_link'] as String?,
      hdTypeFilter: json['hd_type_filter'] as String?,
      gateThemes: (json['gate_themes'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      maxParticipants: json['max_participants'] as int?,
      currentParticipants: json['current_participants'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      creatorName: json['creator']?['display_name'] as String? ??
          json['creator']?['full_name'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        creatorId,
        title,
        description,
        eventType,
        startsAt,
        endsAt,
        currentParticipants,
      ];
}

/// Participant status
class EventParticipant extends Equatable {
  const EventParticipant({
    required this.eventId,
    required this.userId,
    required this.status,
    required this.createdAt,
    this.userName,
  });

  final String eventId;
  final String userId;
  final String status;
  final DateTime createdAt;
  final String? userName;

  factory EventParticipant.fromJson(Map<String, dynamic> json) {
    return EventParticipant(
      eventId: json['event_id'] as String,
      userId: json['user_id'] as String,
      status: json['status'] as String? ?? 'registered',
      createdAt: DateTime.parse(json['created_at'] as String),
      userName: json['user']?['display_name'] as String? ??
          json['user']?['full_name'] as String?,
    );
  }

  @override
  List<Object?> get props => [eventId, userId, status];
}
