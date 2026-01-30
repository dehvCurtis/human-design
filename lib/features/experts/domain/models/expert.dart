/// Models for the Verified Expert System
/// Allows HD teachers and practitioners to be verified and highlighted

/// Represents a verified expert profile
class Expert {
  const Expert({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.title,
    this.bio,
    required this.specializations,
    this.credentials,
    this.yearsOfExperience,
    this.websiteUrl,
    this.socialLinks,
    required this.verificationStatus,
    this.verifiedAt,
    required this.followerCount,
    required this.contentCount,
    this.averageRating,
    this.reviewCount,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String title;
  final String? bio;
  final List<ExpertSpecialization> specializations;
  final List<String>? credentials;
  final int? yearsOfExperience;
  final String? websiteUrl;
  final Map<String, String>? socialLinks;
  final ExpertVerificationStatus verificationStatus;
  final DateTime? verifiedAt;
  final int followerCount;
  final int contentCount;
  final double? averageRating;
  final int? reviewCount;
  final DateTime createdAt;

  bool get isVerified => verificationStatus == ExpertVerificationStatus.verified;

  factory Expert.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return Expert(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String? ?? json['display_name'] as String? ?? 'Unknown',
      userAvatarUrl: user?['avatar_url'] as String?,
      title: json['title'] as String,
      bio: json['bio'] as String?,
      specializations: (json['specializations'] as List?)
          ?.map((s) => _parseSpecialization(s as String))
          .toList() ?? [],
      credentials: (json['credentials'] as List?)?.cast<String>(),
      yearsOfExperience: json['years_of_experience'] as int?,
      websiteUrl: json['website_url'] as String?,
      socialLinks: (json['social_links'] as Map<String, dynamic>?)?.cast<String, String>(),
      verificationStatus: _parseVerificationStatus(json['verification_status'] as String),
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
      followerCount: json['follower_count'] as int? ?? 0,
      contentCount: json['content_count'] as int? ?? 0,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'bio': bio,
      'specializations': specializations.map((s) => s.dbValue).toList(),
      'credentials': credentials,
      'years_of_experience': yearsOfExperience,
      'website_url': websiteUrl,
      'social_links': socialLinks,
    };
  }

  Expert copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    String? title,
    String? bio,
    List<ExpertSpecialization>? specializations,
    List<String>? credentials,
    int? yearsOfExperience,
    String? websiteUrl,
    Map<String, String>? socialLinks,
    ExpertVerificationStatus? verificationStatus,
    DateTime? verifiedAt,
    int? followerCount,
    int? contentCount,
    double? averageRating,
    int? reviewCount,
    DateTime? createdAt,
  }) {
    return Expert(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      specializations: specializations ?? this.specializations,
      credentials: credentials ?? this.credentials,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      socialLinks: socialLinks ?? this.socialLinks,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      followerCount: followerCount ?? this.followerCount,
      contentCount: contentCount ?? this.contentCount,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static ExpertVerificationStatus _parseVerificationStatus(String value) {
    switch (value) {
      case 'pending':
        return ExpertVerificationStatus.pending;
      case 'verified':
        return ExpertVerificationStatus.verified;
      case 'rejected':
        return ExpertVerificationStatus.rejected;
      default:
        return ExpertVerificationStatus.pending;
    }
  }

  static ExpertSpecialization _parseSpecialization(String value) {
    switch (value) {
      case 'chart_readings':
        return ExpertSpecialization.chartReadings;
      case 'business_coaching':
        return ExpertSpecialization.businessCoaching;
      case 'relationship_analysis':
        return ExpertSpecialization.relationshipAnalysis;
      case 'parenting':
        return ExpertSpecialization.parenting;
      case 'career_guidance':
        return ExpertSpecialization.careerGuidance;
      case 'health_wellness':
        return ExpertSpecialization.healthWellness;
      case 'spiritual_development':
        return ExpertSpecialization.spiritualDevelopment;
      case 'gene_keys':
        return ExpertSpecialization.geneKeys;
      case 'bazi_integration':
        return ExpertSpecialization.baziIntegration;
      default:
        return ExpertSpecialization.chartReadings;
    }
  }
}

enum ExpertVerificationStatus {
  pending,
  verified,
  rejected,
}

extension ExpertVerificationStatusExtension on ExpertVerificationStatus {
  String get dbValue {
    switch (this) {
      case ExpertVerificationStatus.pending:
        return 'pending';
      case ExpertVerificationStatus.verified:
        return 'verified';
      case ExpertVerificationStatus.rejected:
        return 'rejected';
    }
  }

  String get displayName {
    switch (this) {
      case ExpertVerificationStatus.pending:
        return 'Pending Review';
      case ExpertVerificationStatus.verified:
        return 'Verified';
      case ExpertVerificationStatus.rejected:
        return 'Not Approved';
    }
  }
}

enum ExpertSpecialization {
  chartReadings,
  businessCoaching,
  relationshipAnalysis,
  parenting,
  careerGuidance,
  healthWellness,
  spiritualDevelopment,
  geneKeys,
  baziIntegration,
}

extension ExpertSpecializationExtension on ExpertSpecialization {
  String get dbValue {
    switch (this) {
      case ExpertSpecialization.chartReadings:
        return 'chart_readings';
      case ExpertSpecialization.businessCoaching:
        return 'business_coaching';
      case ExpertSpecialization.relationshipAnalysis:
        return 'relationship_analysis';
      case ExpertSpecialization.parenting:
        return 'parenting';
      case ExpertSpecialization.careerGuidance:
        return 'career_guidance';
      case ExpertSpecialization.healthWellness:
        return 'health_wellness';
      case ExpertSpecialization.spiritualDevelopment:
        return 'spiritual_development';
      case ExpertSpecialization.geneKeys:
        return 'gene_keys';
      case ExpertSpecialization.baziIntegration:
        return 'bazi_integration';
    }
  }

  String get displayName {
    switch (this) {
      case ExpertSpecialization.chartReadings:
        return 'Chart Readings';
      case ExpertSpecialization.businessCoaching:
        return 'Business Coaching';
      case ExpertSpecialization.relationshipAnalysis:
        return 'Relationship Analysis';
      case ExpertSpecialization.parenting:
        return 'Parenting';
      case ExpertSpecialization.careerGuidance:
        return 'Career Guidance';
      case ExpertSpecialization.healthWellness:
        return 'Health & Wellness';
      case ExpertSpecialization.spiritualDevelopment:
        return 'Spiritual Development';
      case ExpertSpecialization.geneKeys:
        return 'Gene Keys';
      case ExpertSpecialization.baziIntegration:
        return 'BaZi Integration';
    }
  }

  String get emoji {
    switch (this) {
      case ExpertSpecialization.chartReadings:
        return '\u{1F4CA}'; // 📊
      case ExpertSpecialization.businessCoaching:
        return '\u{1F4BC}'; // 💼
      case ExpertSpecialization.relationshipAnalysis:
        return '\u{2764}'; // ❤️
      case ExpertSpecialization.parenting:
        return '\u{1F46A}'; // 👪
      case ExpertSpecialization.careerGuidance:
        return '\u{1F3AF}'; // 🎯
      case ExpertSpecialization.healthWellness:
        return '\u{1F331}'; // 🌱
      case ExpertSpecialization.spiritualDevelopment:
        return '\u{2728}'; // ✨
      case ExpertSpecialization.geneKeys:
        return '\u{1F9EC}'; // 🧬
      case ExpertSpecialization.baziIntegration:
        return '\u{262F}'; // ☯️
    }
  }
}

/// Review for an expert
class ExpertReview {
  const ExpertReview({
    required this.id,
    required this.expertId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.rating,
    this.content,
    required this.createdAt,
  });

  final String id;
  final String expertId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final int rating;
  final String? content;
  final DateTime createdAt;

  factory ExpertReview.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return ExpertReview(
      id: json['id'] as String,
      expertId: json['expert_id'] as String,
      userId: json['user_id'] as String,
      userName: user?['name'] as String? ?? 'Anonymous',
      userAvatarUrl: user?['avatar_url'] as String?,
      rating: json['rating'] as int,
      content: json['content'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Follow relationship for an expert
class ExpertFollow {
  const ExpertFollow({
    required this.id,
    required this.expertId,
    required this.userId,
    required this.createdAt,
  });

  final String id;
  final String expertId;
  final String userId;
  final DateTime createdAt;

  factory ExpertFollow.fromJson(Map<String, dynamic> json) {
    return ExpertFollow(
      id: json['id'] as String,
      expertId: json['expert_id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Application to become a verified expert
class ExpertApplication {
  const ExpertApplication({
    required this.id,
    required this.userId,
    required this.title,
    required this.bio,
    required this.specializations,
    required this.credentials,
    this.yearsOfExperience,
    this.websiteUrl,
    this.portfolioUrls,
    required this.status,
    this.reviewedAt,
    this.reviewNotes,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final String bio;
  final List<String> specializations;
  final List<String> credentials;
  final int? yearsOfExperience;
  final String? websiteUrl;
  final List<String>? portfolioUrls;
  final ExpertVerificationStatus status;
  final DateTime? reviewedAt;
  final String? reviewNotes;
  final DateTime createdAt;

  factory ExpertApplication.fromJson(Map<String, dynamic> json) {
    return ExpertApplication(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      bio: json['bio'] as String,
      specializations: List<String>.from(json['specializations'] as List),
      credentials: List<String>.from(json['credentials'] as List),
      yearsOfExperience: json['years_of_experience'] as int?,
      websiteUrl: json['website_url'] as String?,
      portfolioUrls: (json['portfolio_urls'] as List?)?.cast<String>(),
      status: Expert._parseVerificationStatus(json['status'] as String),
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      reviewNotes: json['review_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
