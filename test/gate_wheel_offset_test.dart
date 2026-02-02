import 'package:flutter_test/flutter_test.dart';
import 'package:human_design/features/ephemeris/mappers/degree_to_gate_mapper.dart';

// Test the 58° HD wheel offset fix
//
// The Human Design wheel is offset from the tropical zodiac:
// - Gate 41 starts at 2° Aquarius (302° tropical), not 0° Aries
// - This means 0° Aries (spring equinox) maps to Gate 25, not Gate 41
void main() {
  group('HD Wheel Offset Tests', () {
    test('0° Aries (Spring Equinox) should map to Gate 25', () {
      // Sun at 0° tropical = Spring Equinox (March 20-21)
      // Should map to Gate 25, NOT Gate 41
      final activation = DegreeToGateMapper.mapDegreeToGate(0.0);

      expect(activation.gate, 25, reason: '0° Aries should be Gate 25 (Vessel of Love)');
    });

    test('302° tropical (2° Aquarius) should map to Gate 41', () {
      // Gate 41 starts at 302° tropical (2° Aquarius)
      final activation = DegreeToGateMapper.mapDegreeToGate(302.0);

      expect(activation.gate, 41, reason: '302° (2° Aquarius) should be Gate 41');
    });

    test('180° tropical (0° Libra) should map to Gate 46', () {
      // Earth at 180° when Sun is at 0°
      // Should be opposite of Gate 25 = Gate 46
      final activation = DegreeToGateMapper.mapDegreeToGate(180.0);

      expect(activation.gate, 46, reason: '180° should be Gate 46');
    });

    test('March 20, 1985 birth - Conscious Sun should be Gate 25', () {
      // Sun at ~0° on March 20 (spring equinox)
      // From our debug output: 0.0485°
      final activation = DegreeToGateMapper.mapDegreeToGate(0.0485);

      expect(activation.gate, 25, reason: 'Conscious Sun should be Gate 25');
      expect(activation.line, 2, reason: 'Line should be 2 for profile 2/5');
    });

    test('Design Sun at 272° should be Gate 10', () {
      // From humdes.com reference: Design Sun is Gate 10
      // Our debug showed 272.0485°
      final activation = DegreeToGateMapper.mapDegreeToGate(272.0485);

      expect(activation.gate, 10, reason: 'Design Sun should be Gate 10');
      expect(activation.line, 5, reason: 'Line should be 5 for profile 2/5');
    });

    test('Earth positions match Incarnation Cross', () {
      // Incarnation Cross: 25/46 | 10/15
      // Conscious Earth (opposite Sun) = Gate 46
      final consciousEarth = DegreeToGateMapper.mapDegreeToGate(180.0485);
      expect(consciousEarth.gate, 46, reason: 'Conscious Earth should be Gate 46');

      // Unconscious Earth (opposite Design Sun) = Gate 15
      final unconsciousEarth = DegreeToGateMapper.mapDegreeToGate(92.0485);
      expect(unconsciousEarth.gate, 15, reason: 'Unconscious Earth should be Gate 15');
    });

    test('Gate 1 position check', () {
      // Gate 1 should be around 281-287° in the HD wheel
      // After offset: index 51 in wheel sequence = Gate 1
      // HD position 51 * 5.625 = 286.875°
      // Tropical = 286.875 - 58 = 228.875° (roughly 18° Scorpio)

      // Verify by finding where Gate 1 maps from
      final gate1Start = DegreeToGateMapper.gateToDegree(1);

      // Now verify that degree maps back to Gate 1
      final activation = DegreeToGateMapper.mapDegreeToGate(gate1Start);
      expect(activation.gate, 1, reason: 'gateToDegree should round-trip correctly');
    });

    test('All 64 gates are reachable', () {
      // Verify every gate can be reached by some degree
      final Set<int> foundGates = {};

      for (double deg = 0; deg < 360; deg += 5.625) {
        final activation = DegreeToGateMapper.mapDegreeToGate(deg);
        foundGates.add(activation.gate);
      }

      expect(foundGates.length, 64, reason: 'All 64 gates should be reachable');

      // Verify all gates 1-64 are present
      for (int gate = 1; gate <= 64; gate++) {
        expect(foundGates.contains(gate), true, reason: 'Gate $gate should be reachable');
      }
    });

    test('Line calculations are correct (1-6)', () {
      // Each gate spans 5.625°, with 6 lines of 0.9375° each
      // After 58° offset: 0° tropical becomes 58° HD wheel position
      // 58° / 5.625° = 10.31, so we're in gate index 10 (Gate 25)
      // Position in gate: 58° - (10 * 5.625°) = 58° - 56.25° = 1.75°
      // Line: 1.75° / 0.9375° = 1.87 → Line 2

      // So 0° tropical is actually in Line 2 of Gate 25, which matches humdes.com!
      final line2 = DegreeToGateMapper.mapDegreeToGate(0.0485);
      expect(line2.gate, 25);
      expect(line2.line, 2, reason: 'March 20, 1985 Sun should be Line 2');

      // All lines should be between 1 and 6
      for (double deg = 0; deg < 360; deg += 1.0) {
        final activation = DegreeToGateMapper.mapDegreeToGate(deg);
        expect(activation.line, greaterThanOrEqualTo(1), reason: 'Line should be >= 1 at $deg°');
        expect(activation.line, lessThanOrEqualTo(6), reason: 'Line should be <= 6 at $deg°');
      }
    });
  });
}
