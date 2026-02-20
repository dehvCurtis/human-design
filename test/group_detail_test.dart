import 'package:flutter_test/flutter_test.dart';
import 'package:human_design/features/social/data/social_repository.dart';
import 'package:human_design/features/social/domain/social_providers.dart';

void main() {
  group('GroupPost.fromJson', () {
    test('parses valid JSON correctly', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'group_id': '223e4567-e89b-12d3-a456-426614174000',
        'content': 'Hello group!',
        'created_at': '2026-02-20T10:00:00Z',
        'author': {
          'id': '323e4567-e89b-12d3-a456-426614174000',
          'name': 'Test User',
          'avatar_url': 'https://example.com/avatar.png',
        },
      };

      final post = GroupPost.fromJson(json);

      expect(post.id, '123e4567-e89b-12d3-a456-426614174000');
      expect(post.groupId, '223e4567-e89b-12d3-a456-426614174000');
      expect(post.userId, '323e4567-e89b-12d3-a456-426614174000');
      expect(post.userName, 'Test User');
      expect(post.userAvatarUrl, 'https://example.com/avatar.png');
      expect(post.content, 'Hello group!');
      expect(post.createdAt, DateTime.utc(2026, 2, 20, 10, 0, 0));
    });

    test('handles null author gracefully', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'group_id': '223e4567-e89b-12d3-a456-426614174000',
        'content': 'Hello group!',
        'created_at': '2026-02-20T10:00:00Z',
        'author': null,
      };

      final post = GroupPost.fromJson(json);

      expect(post.userId, '');
      expect(post.userName, 'Unknown');
      expect(post.userAvatarUrl, isNull);
    });

    test('handles null avatar_url in author', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'group_id': '223e4567-e89b-12d3-a456-426614174000',
        'content': 'Test',
        'created_at': '2026-02-20T10:00:00Z',
        'author': {
          'id': '323e4567-e89b-12d3-a456-426614174000',
          'name': 'Jane',
          'avatar_url': null,
        },
      };

      final post = GroupPost.fromJson(json);

      expect(post.userAvatarUrl, isNull);
      expect(post.userName, 'Jane');
    });
  });

  group('UserSearchResult.fromJson', () {
    test('parses valid JSON correctly', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'name': 'Search User',
        'avatar_url': 'https://example.com/avatar.png',
        'hd_type': 'Generator',
      };

      final result = UserSearchResult.fromJson(json);

      expect(result.id, '123e4567-e89b-12d3-a456-426614174000');
      expect(result.name, 'Search User');
      expect(result.avatarUrl, 'https://example.com/avatar.png');
      expect(result.hdType, 'Generator');
    });

    test('handles null optional fields', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'name': null,
        'avatar_url': null,
        'hd_type': null,
      };

      final result = UserSearchResult.fromJson(json);

      expect(result.name, 'Unknown');
      expect(result.avatarUrl, isNull);
      expect(result.hdType, isNull);
    });
  });

  group('Input validation constants', () {
    test('maxGroupPostLength is 5000', () {
      expect(SocialRepository.maxGroupPostLength, 5000);
    });

    test('maxGroupNameLength is 100', () {
      expect(SocialRepository.maxGroupNameLength, 100);
    });

    test('maxGroupDescriptionLength is 500', () {
      expect(SocialRepository.maxGroupDescriptionLength, 500);
    });
  });

  group('Group model', () {
    test('isAdmin returns true for admin role', () {
      final group = Group(
        id: '1',
        name: 'Test',
        createdAt: DateTime(2026),
        userRole: 'admin',
      );
      expect(group.isAdmin, isTrue);
    });

    test('isAdmin returns false for member role', () {
      final group = Group(
        id: '1',
        name: 'Test',
        createdAt: DateTime(2026),
        userRole: 'member',
      );
      expect(group.isAdmin, isFalse);
    });

    test('isAdmin returns false for null role', () {
      final group = Group(
        id: '1',
        name: 'Test',
        createdAt: DateTime(2026),
      );
      expect(group.isAdmin, isFalse);
    });

    test('copyWith preserves fields', () {
      final group = Group(
        id: '1',
        name: 'Test',
        description: 'Desc',
        createdAt: DateTime(2026),
        userRole: 'admin',
      );
      final copy = group.copyWith(name: 'New Name');
      expect(copy.name, 'New Name');
      expect(copy.description, 'Desc');
      expect(copy.userRole, 'admin');
      expect(copy.id, '1');
    });
  });

  group('GroupMember model', () {
    test('isAdmin returns true for admin role', () {
      final member = GroupMember(
        userId: '1',
        name: 'Test',
        role: 'admin',
        joinedAt: DateTime(2026),
      );
      expect(member.isAdmin, isTrue);
    });

    test('isAdmin returns false for member role', () {
      final member = GroupMember(
        userId: '1',
        name: 'Test',
        role: 'member',
        joinedAt: DateTime(2026),
      );
      expect(member.isAdmin, isFalse);
    });

    test('fromJson parses correctly', () {
      final json = {
        'user': {
          'id': '123',
          'name': 'Member Name',
          'avatar_url': 'https://example.com/avatar.png',
        },
        'role': 'admin',
        'joined_at': '2026-02-20T10:00:00Z',
      };

      final member = GroupMember.fromJson(json);

      expect(member.userId, '123');
      expect(member.name, 'Member Name');
      expect(member.avatarUrl, 'https://example.com/avatar.png');
      expect(member.role, 'admin');
      expect(member.isAdmin, isTrue);
    });
  });

  group('InviteSearchParams', () {
    test('equality works correctly', () {
      const p1 = InviteSearchParams(query: 'test', groupId: '1');
      const p2 = InviteSearchParams(query: 'test', groupId: '1');
      const p3 = InviteSearchParams(query: 'other', groupId: '1');

      expect(p1, equals(p2));
      expect(p1, isNot(equals(p3)));
      expect(p1.hashCode, equals(p2.hashCode));
    });
  });
}
