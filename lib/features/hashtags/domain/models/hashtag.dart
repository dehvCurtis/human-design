/// Models for the hashtag system

/// Represents a hashtag in the system
class Hashtag {
  const Hashtag({
    required this.id,
    required this.name,
    required this.postCount,
    required this.createdAt,
    this.lastUsedAt,
  });

  final String id;
  final String name;
  final int postCount;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  /// Whether this is a Human Design specific hashtag
  bool get isHdHashtag => _hdHashtags.contains(name.toLowerCase());

  /// The category of HD hashtag if applicable
  HashtagCategory? get hdCategory {
    final lower = name.toLowerCase();

    // Check for gate hashtags (#gate1 through #gate64)
    if (lower.startsWith('gate')) {
      final num = int.tryParse(lower.substring(4));
      if (num != null && num >= 1 && num <= 64) {
        return HashtagCategory.gate;
      }
    }

    // Check for channel hashtags
    if (lower.startsWith('channel')) {
      return HashtagCategory.channel;
    }

    // Check for type hashtags
    if (_typeHashtags.contains(lower)) {
      return HashtagCategory.type;
    }

    // Check for authority hashtags
    if (_authorityHashtags.contains(lower)) {
      return HashtagCategory.authority;
    }

    // Check for profile hashtags
    if (_profileHashtags.contains(lower)) {
      return HashtagCategory.profile;
    }

    // Check for center hashtags
    if (_centerHashtags.contains(lower)) {
      return HashtagCategory.center;
    }

    return null;
  }

  factory Hashtag.fromJson(Map<String, dynamic> json) {
    return Hashtag(
      id: json['id'] as String,
      name: json['name'] as String,
      postCount: json['post_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastUsedAt: json['last_used_at'] != null
          ? DateTime.parse(json['last_used_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  Hashtag copyWith({
    String? id,
    String? name,
    int? postCount,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) {
    return Hashtag(
      id: id ?? this.id,
      name: name ?? this.name,
      postCount: postCount ?? this.postCount,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }
}

/// Represents a post-hashtag association
class PostHashtag {
  const PostHashtag({
    required this.postId,
    required this.hashtagId,
    required this.createdAt,
  });

  final String postId;
  final String hashtagId;
  final DateTime createdAt;

  factory PostHashtag.fromJson(Map<String, dynamic> json) {
    return PostHashtag(
      postId: json['post_id'] as String,
      hashtagId: json['hashtag_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Trending hashtag with additional metadata
class TrendingHashtag {
  const TrendingHashtag({
    required this.hashtag,
    required this.recentPostCount,
    required this.trendScore,
    this.percentChange,
  });

  final Hashtag hashtag;
  final int recentPostCount; // Posts in last 24 hours
  final double trendScore;
  final double? percentChange; // Growth compared to previous period

  factory TrendingHashtag.fromJson(Map<String, dynamic> json) {
    return TrendingHashtag(
      hashtag: Hashtag.fromJson(json),
      recentPostCount: json['recent_post_count'] as int? ?? 0,
      trendScore: (json['trend_score'] as num?)?.toDouble() ?? 0.0,
      percentChange: (json['percent_change'] as num?)?.toDouble(),
    );
  }
}

/// Categories for Human Design specific hashtags
enum HashtagCategory {
  gate,
  channel,
  type,
  authority,
  profile,
  center,
}

extension HashtagCategoryExtension on HashtagCategory {
  String get displayName {
    switch (this) {
      case HashtagCategory.gate:
        return 'Gate';
      case HashtagCategory.channel:
        return 'Channel';
      case HashtagCategory.type:
        return 'Type';
      case HashtagCategory.authority:
        return 'Authority';
      case HashtagCategory.profile:
        return 'Profile';
      case HashtagCategory.center:
        return 'Center';
    }
  }
}

// HD-specific hashtag sets
const _typeHashtags = {
  'generator',
  'manifestinggenerator',
  'mg',
  'projector',
  'manifestor',
  'reflector',
};

const _authorityHashtags = {
  'emotionalauthority',
  'sacralauthority',
  'splenicauthority',
  'egoauthority',
  'selfprojectedauthority',
  'mentalauthority',
  'lunarauthority',
  'noauthority',
};

const _profileHashtags = {
  'profile13',
  'profile14',
  'profile24',
  'profile25',
  'profile35',
  'profile36',
  'profile46',
  'profile41',
  'profile51',
  'profile52',
  'profile62',
  'profile63',
  '1/3',
  '1/4',
  '2/4',
  '2/5',
  '3/5',
  '3/6',
  '4/6',
  '4/1',
  '5/1',
  '5/2',
  '6/2',
  '6/3',
};

const _centerHashtags = {
  'head',
  'headcenter',
  'ajna',
  'ajnacenter',
  'throat',
  'throatcenter',
  'gcenter',
  'selfcenter',
  'identity',
  'heart',
  'heartcenter',
  'ego',
  'egocenter',
  'sacral',
  'sacralcenter',
  'solarplexus',
  'emotionalcenter',
  'spleen',
  'spleencenter',
  'spleniccenter',
  'root',
  'rootcenter',
};

// Combined set of all HD hashtags
final _hdHashtags = {
  ..._typeHashtags,
  ..._authorityHashtags,
  ..._profileHashtags,
  ..._centerHashtags,
  // Add generic HD terms
  'humandesign',
  'hd',
  'bodygraph',
  'transit',
  'transits',
  'incarnationcross',
  'definition',
  'singledefinition',
  'splitdefinition',
  'triplesplit',
  'quadsplit',
  'noconnectiondefinition',
  'strategy',
  'notself',
  'signature',
  'experiment',
  'deconditioning',
};

/// Utility class for parsing hashtags from text
class HashtagParser {
  static final _hashtagRegex = RegExp(r'#(\w+)');

  /// Extracts all hashtags from a text string
  static List<String> extractHashtags(String text) {
    final matches = _hashtagRegex.allMatches(text);
    return matches.map((m) => m.group(1)!.toLowerCase()).toSet().toList();
  }

  /// Checks if a hashtag is valid (alphanumeric, at least 2 chars)
  static bool isValidHashtag(String tag) {
    return tag.length >= 2 && RegExp(r'^\w+$').hasMatch(tag);
  }

  /// Returns all hashtag matches with their positions in the text
  static List<HashtagMatch> findHashtagMatches(String text) {
    final matches = _hashtagRegex.allMatches(text);
    return matches.map((m) => HashtagMatch(
      tag: m.group(1)!,
      start: m.start,
      end: m.end,
    )).toList();
  }
}

/// Represents a hashtag match in text with position information
class HashtagMatch {
  const HashtagMatch({
    required this.tag,
    required this.start,
    required this.end,
  });

  final String tag;
  final int start;
  final int end;
}
