import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

/// Re-implementation of AuthRepository._generateNonce that is self-contained
/// so the test never needs to import Supabase / Apple sign-in platform plugins.
///
/// The implementation is an exact copy of the private method:
///   const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZ...';
///   final random = Random.secure();
///   return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
String _generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = math.Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

void main() {
  group('Nonce generation logic (_generateNonce)', () {
    group('Length', () {
      test('default call produces a 32-character string', () {
        final nonce = _generateNonce();
        expect(nonce.length, equals(32));
      });

      test('length 16 produces a 16-character string', () {
        expect(_generateNonce(16).length, equals(16));
      });

      test('length 64 produces a 64-character string', () {
        expect(_generateNonce(64).length, equals(64));
      });
    });

    group('Character set', () {
      test('nonce contains only valid charset characters', () {
        const charset =
            '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
        final nonce = _generateNonce();
        for (final char in nonce.split('')) {
          expect(
            charset.contains(char),
            isTrue,
            reason: 'Unexpected character "$char" not in charset',
          );
        }
      });
    });

    group('Uniqueness', () {
      test('two successive nonces are different', () {
        // P(collision) ≈ 64^-32 ≈ 10^-57 — effectively impossible.
        final nonce1 = _generateNonce();
        final nonce2 = _generateNonce();
        expect(nonce1, isNot(equals(nonce2)));
      });

      test('100 generated nonces are all unique', () {
        final nonces = List.generate(100, (_) => _generateNonce());
        final unique = nonces.toSet();
        expect(unique.length, equals(100));
      });
    });

    group('SHA-256 hashing (as used in signInWithApple)', () {
      test('hashing a nonce produces a 64-character hex string', () {
        final nonce = _generateNonce();
        final hashed = sha256.convert(utf8.encode(nonce)).toString();
        expect(hashed.length, equals(64));
      });

      test('hashed nonce contains only lowercase hex characters', () {
        final nonce = _generateNonce();
        final hashed = sha256.convert(utf8.encode(nonce)).toString();
        final hexPattern = RegExp(r'^[0-9a-f]+$');
        expect(hexPattern.hasMatch(hashed), isTrue);
      });

      test('hashing the same nonce twice produces the same hash (deterministic)', () {
        const nonce = 'FixedTestNonce-42.xyz';
        final hash1 = sha256.convert(utf8.encode(nonce)).toString();
        final hash2 = sha256.convert(utf8.encode(nonce)).toString();
        expect(hash1, equals(hash2));
      });

      test('two different nonces produce different hashes', () {
        final nonce1 = _generateNonce();
        final nonce2 = _generateNonce();
        final hash1 = sha256.convert(utf8.encode(nonce1)).toString();
        final hash2 = sha256.convert(utf8.encode(nonce2)).toString();
        expect(hash1, isNot(equals(hash2)));
      });
    });
  });
}
