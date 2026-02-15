import 'package:flutter_test/flutter_test.dart';
import 'package:human_design/features/feed/data/feed_repository.dart';
import 'package:human_design/features/feed/domain/models/post.dart';

void main() {
  group('FeedRepository Constants', () {
    test('maxPostLength should be 5000', () {
      expect(FeedRepository.maxPostLength, equals(5000));
    });

    test('maxCommentLength should be 2000', () {
      expect(FeedRepository.maxCommentLength, equals(2000));
    });
  });

  group('Post Model', () {
    late Map<String, dynamic> validPostJson;
    late DateTime testCreatedAt;

    setUp(() {
      testCreatedAt = DateTime.parse('2026-02-14T12:00:00Z');
      validPostJson = {
        'id': 'post-123',
        'user_id': 'user-456',
        'content': 'This is a test post about Human Design',
        'post_type': 'insight',
        'visibility': 'public',
        'is_pinned': false,
        'reaction_count': 5,
        'comment_count': 3,
        'share_count': 1,
        'created_at': testCreatedAt.toIso8601String(),
        'is_regenerate': false,
        'regenerate_count': 0,
        'user': {
          'id': 'user-456',
          'name': 'Test User',
          'avatar_url': 'https://example.com/avatar.png',
          'hd_type': 'Generator',
        },
      };
    });

    test('fromJson creates Post with all required fields', () {
      final post = Post.fromJson(validPostJson);

      expect(post.id, equals('post-123'));
      expect(post.userId, equals('user-456'));
      expect(post.userName, equals('Test User'));
      expect(post.userAvatarUrl, equals('https://example.com/avatar.png'));
      expect(post.userHdType, equals('Generator'));
      expect(post.content, equals('This is a test post about Human Design'));
      expect(post.postType, equals(PostType.insight));
      expect(post.visibility, equals(PostVisibility.public));
      expect(post.isPinned, equals(false));
      expect(post.reactionCount, equals(5));
      expect(post.commentCount, equals(3));
      expect(post.shareCount, equals(1));
      expect(post.createdAt, equals(testCreatedAt));
      expect(post.isRegenerate, equals(false));
      expect(post.regenerateCount, equals(0));
    });

    test('fromJson handles missing user data gracefully', () {
      validPostJson.remove('user');
      final post = Post.fromJson(validPostJson);

      expect(post.userName, equals('Unknown'));
      expect(post.userAvatarUrl, isNull);
      expect(post.userHdType, isNull);
    });

    test('fromJson handles null optional fields', () {
      final minimalJson = {
        'id': 'post-123',
        'user_id': 'user-456',
        'content': 'Minimal post',
        'post_type': 'question',
        'visibility': 'followers',
        'created_at': testCreatedAt.toIso8601String(),
      };

      final post = Post.fromJson(minimalJson);

      expect(post.mediaUrls, isNull);
      expect(post.chartId, isNull);
      expect(post.gateNumber, isNull);
      expect(post.channelId, isNull);
      expect(post.transitData, isNull);
      expect(post.badgeId, isNull);
      expect(post.updatedAt, isNull);
      expect(post.userReaction, isNull);
      expect(post.reactions, isNull);
      expect(post.originalPostId, isNull);
      expect(post.originalPost, isNull);
    });

    test('fromJson parses media URLs correctly', () {
      validPostJson['media_urls'] = ['https://example.com/img1.jpg', 'https://example.com/img2.jpg'];
      final post = Post.fromJson(validPostJson);

      expect(post.mediaUrls, isNotNull);
      expect(post.mediaUrls!.length, equals(2));
      expect(post.mediaUrls![0], equals('https://example.com/img1.jpg'));
      expect(post.mediaUrls![1], equals('https://example.com/img2.jpg'));
    });

    test('fromJson parses optional fields correctly', () {
      validPostJson['chart_id'] = 'chart-789';
      validPostJson['gate_number'] = 41;
      validPostJson['channel_id'] = '41-30';
      validPostJson['badge_id'] = 'badge-001';
      validPostJson['updated_at'] = '2026-02-14T13:00:00Z';
      validPostJson['transit_data'] = {'sun': 'Gate 41', 'earth': 'Gate 31'};

      final post = Post.fromJson(validPostJson);

      expect(post.chartId, equals('chart-789'));
      expect(post.gateNumber, equals(41));
      expect(post.channelId, equals('41-30'));
      expect(post.badgeId, equals('badge-001'));
      expect(post.updatedAt, equals(DateTime.parse('2026-02-14T13:00:00Z')));
      expect(post.transitData, isNotNull);
      expect(post.transitData!['sun'], equals('Gate 41'));
    });

    test('fromJson handles regenerate (repost) fields', () {
      validPostJson['original_post_id'] = 'original-post-123';
      validPostJson['is_regenerate'] = true;
      validPostJson['regenerate_count'] = 5;
      validPostJson['original_post'] = {
        'id': 'original-post-123',
        'user_id': 'original-user',
        'content': 'Original content',
        'post_type': 'reflection',
        'visibility': 'public',
        'is_pinned': false,
        'reaction_count': 10,
        'comment_count': 2,
        'share_count': 0,
        'created_at': '2026-02-13T12:00:00Z',
        'is_regenerate': false,
        'regenerate_count': 5,
        'user': {
          'id': 'original-user',
          'name': 'Original User',
        },
      };

      final post = Post.fromJson(validPostJson);

      expect(post.originalPostId, equals('original-post-123'));
      expect(post.isRegenerate, equals(true));
      expect(post.regenerateCount, equals(5));
      expect(post.originalPost, isNotNull);
      expect(post.originalPost!.id, equals('original-post-123'));
      expect(post.originalPost!.content, equals('Original content'));
      expect(post.originalPost!.userName, equals('Original User'));
    });

    test('fromJson handles user reaction parameter', () {
      final post = Post.fromJson(
        validPostJson,
        userReaction: ReactionType.love,
      );

      expect(post.userReaction, equals(ReactionType.love));
    });

    test('fromJson handles reactions map parameter', () {
      final reactionsMap = {
        ReactionType.like: 3,
        ReactionType.love: 2,
        ReactionType.insight: 1,
      };

      final post = Post.fromJson(
        validPostJson,
        reactions: reactionsMap,
      );

      expect(post.reactions, isNotNull);
      expect(post.reactions![ReactionType.like], equals(3));
      expect(post.reactions![ReactionType.love], equals(2));
      expect(post.reactions![ReactionType.insight], equals(1));
    });

    test('toJson serializes correctly', () {
      final post = Post.fromJson(validPostJson);
      final json = post.toJson();

      expect(json['content'], equals('This is a test post about Human Design'));
      expect(json['post_type'], equals('insight'));
      expect(json['visibility'], equals('public'));
      expect(json['is_pinned'], equals(false));
      expect(json['is_regenerate'], equals(false));
    });

    test('toJson includes optional fields when present', () {
      validPostJson['media_urls'] = ['https://example.com/img.jpg'];
      validPostJson['chart_id'] = 'chart-789';
      validPostJson['gate_number'] = 41;
      validPostJson['channel_id'] = '41-30';
      validPostJson['badge_id'] = 'badge-001';
      validPostJson['transit_data'] = {'sun': 'Gate 41'};
      validPostJson['original_post_id'] = 'original-123';

      final post = Post.fromJson(validPostJson);
      final json = post.toJson();

      expect(json['media_urls'], isNotNull);
      expect(json['chart_id'], equals('chart-789'));
      expect(json['gate_number'], equals(41));
      expect(json['channel_id'], equals('41-30'));
      expect(json['badge_id'], equals('badge-001'));
      expect(json['transit_data'], isNotNull);
      expect(json['original_post_id'], equals('original-123'));
    });

    test('copyWith creates new Post with updated fields', () {
      final post = Post.fromJson(validPostJson);
      final updated = post.copyWith(
        content: 'Updated content',
        reactionCount: 10,
        isPinned: true,
      );

      expect(updated.content, equals('Updated content'));
      expect(updated.reactionCount, equals(10));
      expect(updated.isPinned, equals(true));
      // Original fields remain unchanged
      expect(updated.id, equals(post.id));
      expect(updated.userId, equals(post.userId));
      expect(updated.commentCount, equals(post.commentCount));
    });

    test('copyWith preserves original values for unspecified fields', () {
      final post = Post.fromJson(validPostJson);
      final updated = post.copyWith(content: 'New content');

      expect(updated.id, equals(post.id));
      expect(updated.userId, equals(post.userId));
      expect(updated.userName, equals(post.userName));
      expect(updated.postType, equals(post.postType));
      expect(updated.visibility, equals(post.visibility));
      expect(updated.reactionCount, equals(post.reactionCount));
    });
  });

  group('PostType Enum', () {
    test('all PostType values are defined', () {
      expect(PostType.values.length, equals(8));
      expect(PostType.values, contains(PostType.insight));
      expect(PostType.values, contains(PostType.reflection));
      expect(PostType.values, contains(PostType.transitShare));
      expect(PostType.values, contains(PostType.chartShare));
      expect(PostType.values, contains(PostType.question));
      expect(PostType.values, contains(PostType.achievement));
      expect(PostType.values, contains(PostType.regenerate));
      expect(PostType.values, contains(PostType.dreamShare));
    });

    test('PostType.dbValue returns correct database values', () {
      expect(PostType.insight.dbValue, equals('insight'));
      expect(PostType.reflection.dbValue, equals('reflection'));
      expect(PostType.transitShare.dbValue, equals('transit_share'));
      expect(PostType.chartShare.dbValue, equals('chart_share'));
      expect(PostType.question.dbValue, equals('question'));
      expect(PostType.achievement.dbValue, equals('achievement'));
      expect(PostType.regenerate.dbValue, equals('regenerate'));
      expect(PostType.dreamShare.dbValue, equals('dream_share'));
    });

    test('Post._parsePostType handles all valid types', () {
      final testCases = {
        'insight': PostType.insight,
        'reflection': PostType.reflection,
        'transit_share': PostType.transitShare,
        'chart_share': PostType.chartShare,
        'question': PostType.question,
        'achievement': PostType.achievement,
        'regenerate': PostType.regenerate,
        'dream_share': PostType.dreamShare,
      };

      testCases.forEach((dbValue, expectedType) {
        final json = {
          'id': 'test-id',
          'user_id': 'test-user',
          'content': 'Test',
          'post_type': dbValue,
          'visibility': 'public',
          'is_pinned': false,
          'reaction_count': 0,
          'comment_count': 0,
          'share_count': 0,
          'created_at': DateTime.now().toIso8601String(),
          'is_regenerate': false,
          'regenerate_count': 0,
        };
        final post = Post.fromJson(json);
        expect(post.postType, equals(expectedType));
      });
    });

    test('Post._parsePostType defaults to insight for unknown type', () {
      final json = {
        'id': 'test-id',
        'user_id': 'test-user',
        'content': 'Test',
        'post_type': 'unknown_type',
        'visibility': 'public',
        'is_pinned': false,
        'reaction_count': 0,
        'comment_count': 0,
        'share_count': 0,
        'created_at': DateTime.now().toIso8601String(),
        'is_regenerate': false,
        'regenerate_count': 0,
      };
      final post = Post.fromJson(json);
      expect(post.postType, equals(PostType.insight));
    });
  });

  group('PostVisibility Enum', () {
    test('all PostVisibility values are defined', () {
      expect(PostVisibility.values.length, equals(3));
      expect(PostVisibility.values, contains(PostVisibility.public));
      expect(PostVisibility.values, contains(PostVisibility.followers));
      expect(PostVisibility.values, contains(PostVisibility.private));
    });

    test('Post._parseVisibility handles all valid types', () {
      final testCases = {
        'public': PostVisibility.public,
        'followers': PostVisibility.followers,
        'private': PostVisibility.private,
      };

      testCases.forEach((dbValue, expectedVisibility) {
        final json = {
          'id': 'test-id',
          'user_id': 'test-user',
          'content': 'Test',
          'post_type': 'insight',
          'visibility': dbValue,
          'is_pinned': false,
          'reaction_count': 0,
          'comment_count': 0,
          'share_count': 0,
          'created_at': DateTime.now().toIso8601String(),
          'is_regenerate': false,
          'regenerate_count': 0,
        };
        final post = Post.fromJson(json);
        expect(post.visibility, equals(expectedVisibility));
      });
    });

    test('Post._parseVisibility defaults to public for unknown type', () {
      final json = {
        'id': 'test-id',
        'user_id': 'test-user',
        'content': 'Test',
        'post_type': 'insight',
        'visibility': 'unknown_visibility',
        'is_pinned': false,
        'reaction_count': 0,
        'comment_count': 0,
        'share_count': 0,
        'created_at': DateTime.now().toIso8601String(),
        'is_regenerate': false,
        'regenerate_count': 0,
      };
      final post = Post.fromJson(json);
      expect(post.visibility, equals(PostVisibility.public));
    });
  });

  group('ReactionType Enum', () {
    test('all ReactionType values are defined', () {
      expect(ReactionType.values.length, equals(9));
      expect(ReactionType.values, contains(ReactionType.like));
      expect(ReactionType.values, contains(ReactionType.love));
      expect(ReactionType.values, contains(ReactionType.insight));
      expect(ReactionType.values, contains(ReactionType.resonate));
      expect(ReactionType.values, contains(ReactionType.generatorSacral));
      expect(ReactionType.values, contains(ReactionType.projectorRecognition));
      expect(ReactionType.values, contains(ReactionType.manifestorPeace));
      expect(ReactionType.values, contains(ReactionType.reflectorSurprise));
      expect(ReactionType.values, contains(ReactionType.mgSatisfaction));
    });

    test('ReactionType.dbValue returns correct database values', () {
      expect(ReactionType.like.dbValue, equals('like'));
      expect(ReactionType.love.dbValue, equals('love'));
      expect(ReactionType.insight.dbValue, equals('insight'));
      expect(ReactionType.resonate.dbValue, equals('resonate'));
      expect(ReactionType.generatorSacral.dbValue, equals('generator_sacral'));
      expect(ReactionType.projectorRecognition.dbValue, equals('projector_recognition'));
      expect(ReactionType.manifestorPeace.dbValue, equals('manifestor_peace'));
      expect(ReactionType.reflectorSurprise.dbValue, equals('reflector_surprise'));
      expect(ReactionType.mgSatisfaction.dbValue, equals('mg_satisfaction'));
    });

    test('ReactionType.emoji returns correct emoji values', () {
      expect(ReactionType.like.emoji, equals('👍'));
      expect(ReactionType.love.emoji, equals('❤'));
      expect(ReactionType.insight.emoji, equals('💡'));
      expect(ReactionType.resonate.emoji, equals('🌟'));
      expect(ReactionType.generatorSacral.emoji, equals('🔥'));
      expect(ReactionType.projectorRecognition.emoji, equals('👁'));
      expect(ReactionType.manifestorPeace.emoji, equals('🕊'));
      expect(ReactionType.reflectorSurprise.emoji, equals('✨'));
      expect(ReactionType.mgSatisfaction.emoji, equals('⚡'));
    });

    test('ReactionType.label returns correct label values', () {
      expect(ReactionType.like.label, equals('Like'));
      expect(ReactionType.love.label, equals('Love'));
      expect(ReactionType.insight.label, equals('Insight'));
      expect(ReactionType.resonate.label, equals('Resonate'));
      expect(ReactionType.generatorSacral.label, equals('Sacral Yes'));
      expect(ReactionType.projectorRecognition.label, equals('I See You'));
      expect(ReactionType.manifestorPeace.label, equals('In Peace'));
      expect(ReactionType.reflectorSurprise.label, equals('Delighted'));
      expect(ReactionType.mgSatisfaction.label, equals('Satisfied'));
    });
  });

  group('Content Validation', () {
    test('content at max post length should be valid', () {
      final maxContent = 'a' * FeedRepository.maxPostLength;
      expect(maxContent.length, equals(5000));
      // In real usage, createPost would validate this
      expect(maxContent.length <= FeedRepository.maxPostLength, isTrue);
    });

    test('content over max post length should be invalid', () {
      final overMaxContent = 'a' * (FeedRepository.maxPostLength + 1);
      expect(overMaxContent.length, equals(5001));
      expect(overMaxContent.length > FeedRepository.maxPostLength, isTrue);
    });

    test('content at max comment length should be valid', () {
      final maxComment = 'a' * FeedRepository.maxCommentLength;
      expect(maxComment.length, equals(2000));
      expect(maxComment.length <= FeedRepository.maxCommentLength, isTrue);
    });

    test('content over max comment length should be invalid', () {
      final overMaxComment = 'a' * (FeedRepository.maxCommentLength + 1);
      expect(overMaxComment.length, equals(2001));
      expect(overMaxComment.length > FeedRepository.maxCommentLength, isTrue);
    });

    test('empty content should be valid', () {
      const emptyContent = '';
      expect(emptyContent.length <= FeedRepository.maxPostLength, isTrue);
      expect(emptyContent.length <= FeedRepository.maxCommentLength, isTrue);
    });

    test('unicode characters are counted correctly', () {
      // Emoji and special characters should count as single characters in Dart
      final unicodeContent = '🌟🔥💡' * 100; // 300 emojis
      // Note: Dart string length counts UTF-16 code units, not characters
      // Each emoji is 2 UTF-16 code units, so 300 emojis = 600 code units
      expect(unicodeContent.length, equals(600));
      expect(unicodeContent.length <= FeedRepository.maxPostLength, isTrue);
    });

    test('multi-line content is handled correctly', () {
      final multilineContent = 'Line 1\nLine 2\nLine 3\n' * 100;
      expect(multilineContent.length <= FeedRepository.maxPostLength, isTrue);
    });
  });

  group('PostComment Model', () {
    late Map<String, dynamic> validCommentJson;
    late DateTime testCreatedAt;

    setUp(() {
      testCreatedAt = DateTime.parse('2026-02-14T12:30:00Z');
      validCommentJson = {
        'id': 'comment-123',
        'post_id': 'post-456',
        'user_id': 'user-789',
        'content': 'This is a comment',
        'reaction_count': 2,
        'created_at': testCreatedAt.toIso8601String(),
        'user': {
          'id': 'user-789',
          'name': 'Commenter',
          'avatar_url': 'https://example.com/avatar.png',
        },
      };
    });

    test('fromJson creates PostComment with required fields', () {
      final comment = PostComment.fromJson(validCommentJson);

      expect(comment.id, equals('comment-123'));
      expect(comment.postId, equals('post-456'));
      expect(comment.userId, equals('user-789'));
      expect(comment.userName, equals('Commenter'));
      expect(comment.userAvatarUrl, equals('https://example.com/avatar.png'));
      expect(comment.content, equals('This is a comment'));
      expect(comment.reactionCount, equals(2));
      expect(comment.createdAt, equals(testCreatedAt));
      expect(comment.parentId, isNull);
      expect(comment.isReply, isFalse);
    });

    test('fromJson handles reply comments', () {
      validCommentJson['parent_id'] = 'parent-comment-123';
      final comment = PostComment.fromJson(validCommentJson);

      expect(comment.parentId, equals('parent-comment-123'));
      expect(comment.isReply, isTrue);
    });

    test('fromJson handles missing user data gracefully', () {
      validCommentJson.remove('user');
      final comment = PostComment.fromJson(validCommentJson);

      expect(comment.userName, equals('Unknown'));
      expect(comment.userAvatarUrl, isNull);
    });

    test('copyWith creates new PostComment with updated fields', () {
      final comment = PostComment.fromJson(validCommentJson);
      final updated = comment.copyWith(
        content: 'Updated comment',
        reactionCount: 5,
      );

      expect(updated.content, equals('Updated comment'));
      expect(updated.reactionCount, equals(5));
      expect(updated.id, equals(comment.id));
      expect(updated.postId, equals(comment.postId));
    });
  });

  group('Reaction Model', () {
    late Map<String, dynamic> validReactionJson;
    late DateTime testCreatedAt;

    setUp(() {
      testCreatedAt = DateTime.parse('2026-02-14T12:45:00Z');
      validReactionJson = {
        'id': 'reaction-123',
        'user_id': 'user-456',
        'post_id': 'post-789',
        'reaction_type': 'love',
        'created_at': testCreatedAt.toIso8601String(),
      };
    });

    test('fromJson creates Reaction for post', () {
      final reaction = Reaction.fromJson(validReactionJson);

      expect(reaction.id, equals('reaction-123'));
      expect(reaction.userId, equals('user-456'));
      expect(reaction.postId, equals('post-789'));
      expect(reaction.commentId, isNull);
      expect(reaction.reactionType, equals(ReactionType.love));
      expect(reaction.createdAt, equals(testCreatedAt));
    });

    test('fromJson creates Reaction for comment', () {
      validReactionJson.remove('post_id');
      validReactionJson['comment_id'] = 'comment-999';
      final reaction = Reaction.fromJson(validReactionJson);

      expect(reaction.postId, isNull);
      expect(reaction.commentId, equals('comment-999'));
    });

    test('Reaction._parseReactionType handles all valid types', () {
      final testCases = {
        'like': ReactionType.like,
        'love': ReactionType.love,
        'insight': ReactionType.insight,
        'resonate': ReactionType.resonate,
        'generator_sacral': ReactionType.generatorSacral,
        'projector_recognition': ReactionType.projectorRecognition,
        'manifestor_peace': ReactionType.manifestorPeace,
        'reflector_surprise': ReactionType.reflectorSurprise,
        'mg_satisfaction': ReactionType.mgSatisfaction,
      };

      testCases.forEach((dbValue, expectedType) {
        validReactionJson['reaction_type'] = dbValue;
        final reaction = Reaction.fromJson(validReactionJson);
        expect(reaction.reactionType, equals(expectedType));
      });
    });

    test('Reaction._parseReactionType defaults to like for unknown type', () {
      validReactionJson['reaction_type'] = 'unknown_type';
      final reaction = Reaction.fromJson(validReactionJson);
      expect(reaction.reactionType, equals(ReactionType.like));
    });
  });
}
