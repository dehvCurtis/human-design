import 'package:flutter_test/flutter_test.dart';
import 'package:human_design/features/ai_assistant/domain/models/ai_usage.dart';

void main() {
  group('AiUsage', () {
    group('Free user quota (limit=5)', () {
      test('can send message when under limit', () {
        const usage = AiUsage(messagesThisMonth: 3, limit: 5);

        expect(usage.canSendMessage, isTrue);
        expect(usage.remaining, equals(2));
      });

      test('can send last message when at limit-1', () {
        const usage = AiUsage(messagesThisMonth: 4, limit: 5);

        expect(usage.canSendMessage, isTrue);
        expect(usage.remaining, equals(1));
      });

      test('blocked when at limit', () {
        const usage = AiUsage(messagesThisMonth: 5, limit: 5);

        expect(usage.canSendMessage, isFalse);
        expect(usage.remaining, equals(0));
      });

      test('blocked when over limit', () {
        const usage = AiUsage(messagesThisMonth: 7, limit: 5);

        expect(usage.canSendMessage, isFalse);
        expect(usage.remaining, equals(0));
      });

      test('can send when no messages used', () {
        const usage = AiUsage(messagesThisMonth: 0, limit: 5);

        expect(usage.canSendMessage, isTrue);
        expect(usage.remaining, equals(5));
      });
    });

    group('Premium user (unlimited)', () {
      test('unlimited() factory creates high limit', () {
        final usage = AiUsage.unlimited();

        expect(usage.limit, equals(999999));
        expect(usage.messagesThisMonth, equals(0));
        expect(usage.bonusMessages, equals(0));
      });

      test('always canSendMessage for reasonable usage', () {
        final usage = AiUsage.unlimited();

        expect(usage.canSendMessage, isTrue);
        expect(usage.remaining, equals(999999));
      });

      test('canSendMessage even after many messages', () {
        const usage = AiUsage(messagesThisMonth: 1000, limit: 999999);

        expect(usage.canSendMessage, isTrue);
        expect(usage.remaining, equals(998999));
      });
    });

    group('Bonus messages', () {
      test('effectiveLimit includes bonus messages', () {
        const usage = AiUsage(
          messagesThisMonth: 0,
          limit: 5,
          bonusMessages: 10,
        );

        expect(usage.effectiveLimit, equals(15));
      });

      test('can send when under limit but would exceed without bonus', () {
        const usage = AiUsage(
          messagesThisMonth: 7,
          limit: 5,
          bonusMessages: 10,
        );

        expect(usage.canSendMessage, isTrue);
        expect(usage.remaining, equals(8));
      });

      test('blocked when at effective limit with bonus', () {
        const usage = AiUsage(
          messagesThisMonth: 15,
          limit: 5,
          bonusMessages: 10,
        );

        expect(usage.canSendMessage, isFalse);
        expect(usage.remaining, equals(0));
      });

      test('remaining accounts for bonus messages', () {
        const usage = AiUsage(
          messagesThisMonth: 3,
          limit: 5,
          bonusMessages: 7,
        );

        expect(usage.effectiveLimit, equals(12));
        expect(usage.remaining, equals(9));
      });

      test('bonus messages of 0 same as no bonus', () {
        const usage = AiUsage(
          messagesThisMonth: 3,
          limit: 5,
          bonusMessages: 0,
        );

        expect(usage.effectiveLimit, equals(5));
        expect(usage.remaining, equals(2));
      });
    });

    group('Period reset (empty factory)', () {
      test('empty() factory starts at 0 messages', () {
        final usage = AiUsage.empty(limit: 5);

        expect(usage.messagesThisMonth, equals(0));
        expect(usage.limit, equals(5));
        expect(usage.bonusMessages, equals(0));
      });

      test('empty() factory with custom limit', () {
        final usage = AiUsage.empty(limit: 20);

        expect(usage.messagesThisMonth, equals(0));
        expect(usage.limit, equals(20));
        expect(usage.remaining, equals(20));
      });

      test('empty() usage can send messages', () {
        final usage = AiUsage.empty(limit: 10);

        expect(usage.canSendMessage, isTrue);
        expect(usage.remaining, equals(10));
      });
    });

    group('fromJson parsing', () {
      test('parses with all fields present', () {
        final json = {
          'messages_count': 3,
          'bonus_messages': 5,
        };

        final usage = AiUsage.fromJson(json, limit: 10);

        expect(usage.messagesThisMonth, equals(3));
        expect(usage.limit, equals(10));
        expect(usage.bonusMessages, equals(5));
      });

      test('parses with missing bonus_messages (defaults to 0)', () {
        final json = {
          'messages_count': 7,
        };

        final usage = AiUsage.fromJson(json, limit: 10);

        expect(usage.messagesThisMonth, equals(7));
        expect(usage.limit, equals(10));
        expect(usage.bonusMessages, equals(0));
      });

      test('parses with missing messages_count (defaults to 0)', () {
        final json = {
          'bonus_messages': 3,
        };

        final usage = AiUsage.fromJson(json, limit: 10);

        expect(usage.messagesThisMonth, equals(0));
        expect(usage.limit, equals(10));
        expect(usage.bonusMessages, equals(3));
      });

      test('parses with empty json (all defaults)', () {
        final json = <String, dynamic>{};

        final usage = AiUsage.fromJson(json, limit: 5);

        expect(usage.messagesThisMonth, equals(0));
        expect(usage.limit, equals(5));
        expect(usage.bonusMessages, equals(0));
      });

      test('parses with null values (uses defaults)', () {
        final json = {
          'messages_count': null,
          'bonus_messages': null,
        };

        final usage = AiUsage.fromJson(json, limit: 10);

        expect(usage.messagesThisMonth, equals(0));
        expect(usage.limit, equals(10));
        expect(usage.bonusMessages, equals(0));
      });
    });

    group('remaining is never negative (clamped to 0)', () {
      test('remaining is 0 when at limit', () {
        const usage = AiUsage(messagesThisMonth: 5, limit: 5);

        expect(usage.remaining, equals(0));
      });

      test('remaining is 0 when over limit by 1', () {
        const usage = AiUsage(messagesThisMonth: 6, limit: 5);

        expect(usage.remaining, equals(0));
      });

      test('remaining is 0 when significantly over limit', () {
        const usage = AiUsage(messagesThisMonth: 100, limit: 5);

        expect(usage.remaining, equals(0));
      });

      test('remaining is 0 when over effective limit with bonus', () {
        const usage = AiUsage(
          messagesThisMonth: 20,
          limit: 5,
          bonusMessages: 10,
        );

        expect(usage.remaining, equals(0));
      });

      test('remaining is positive when under limit', () {
        const usage = AiUsage(messagesThisMonth: 2, limit: 5);

        expect(usage.remaining, equals(3));
        expect(usage.remaining, isPositive);
      });
    });

    group('Equatable', () {
      test('two AiUsage with same props are equal', () {
        const usage1 = AiUsage(
          messagesThisMonth: 3,
          limit: 5,
          bonusMessages: 2,
        );
        const usage2 = AiUsage(
          messagesThisMonth: 3,
          limit: 5,
          bonusMessages: 2,
        );

        expect(usage1, equals(usage2));
        expect(usage1.hashCode, equals(usage2.hashCode));
      });

      test('two AiUsage with different messagesThisMonth are not equal', () {
        const usage1 = AiUsage(messagesThisMonth: 3, limit: 5);
        const usage2 = AiUsage(messagesThisMonth: 4, limit: 5);

        expect(usage1, isNot(equals(usage2)));
      });

      test('two AiUsage with different limit are not equal', () {
        const usage1 = AiUsage(messagesThisMonth: 3, limit: 5);
        const usage2 = AiUsage(messagesThisMonth: 3, limit: 10);

        expect(usage1, isNot(equals(usage2)));
      });

      test('two AiUsage with different bonusMessages are not equal', () {
        const usage1 = AiUsage(
          messagesThisMonth: 3,
          limit: 5,
          bonusMessages: 2,
        );
        const usage2 = AiUsage(
          messagesThisMonth: 3,
          limit: 5,
          bonusMessages: 5,
        );

        expect(usage1, isNot(equals(usage2)));
      });

      test('empty() factory instances with same limit are equal', () {
        final usage1 = AiUsage.empty(limit: 5);
        final usage2 = AiUsage.empty(limit: 5);

        expect(usage1, equals(usage2));
      });

      test('unlimited() factory instances are equal', () {
        final usage1 = AiUsage.unlimited();
        final usage2 = AiUsage.unlimited();

        expect(usage1, equals(usage2));
      });
    });

    group('Edge cases', () {
      test('handles 0 limit', () {
        const usage = AiUsage(messagesThisMonth: 0, limit: 0);

        expect(usage.canSendMessage, isFalse);
        expect(usage.remaining, equals(0));
      });

      test('handles very large message count', () {
        const usage = AiUsage(messagesThisMonth: 1000000, limit: 5);

        expect(usage.canSendMessage, isFalse);
        expect(usage.remaining, equals(0));
      });

      test('effectiveLimit with only bonus messages (limit 0)', () {
        const usage = AiUsage(
          messagesThisMonth: 0,
          limit: 0,
          bonusMessages: 10,
        );

        expect(usage.effectiveLimit, equals(10));
        expect(usage.canSendMessage, isTrue);
        expect(usage.remaining, equals(10));
      });
    });
  });
}
