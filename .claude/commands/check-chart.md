# Check Chart Calculation

Verify Human Design chart calculations for accuracy against known reference data.

## Instructions

When the user provides birth data: `$ARGUMENTS`

Parse: date (YYYY-MM-DD), time (HH:MM), location (city or lat/lon).

### Step 1: Run existing tests as baseline

```bash
flutter test test/gate_wheel_offset_test.dart
flutter test test/timezone_fix_test.dart
```

If these fail, the core calculation logic has a bug — investigate before proceeding.

### Step 2: Read the calculation chain

Read these files to understand the current implementation:
- `lib/features/ephemeris/data/ephemeris_service.dart` — planetary position calculation
- `lib/features/ephemeris/mappers/degree_to_gate_mapper.dart` — degree-to-gate mapping
- `lib/features/chart/domain/usecases/calculate_chart.dart` — type/authority/profile logic
- `lib/core/constants/human_design_constants.dart` — gate/channel/center definitions

### Step 3: Validate the 58-degree offset

Confirm in `degree_to_gate_mapper.dart` that the HD wheel offset is applied:
```dart
static const double _hdWheelOffset = 58.0;
double hdWheelPosition = (tropicalLongitude + _hdWheelOffset) % 360;
```

This is the most critical calculation — without it, all gates are wrong by ~10 positions.

### Step 4: Trace the calculation for the given birth data

Walk through the calculation:
1. **Input**: Birth datetime + location → UTC conversion
2. **Julian Day**: datetime → JD number
3. **Planetary positions**: Sun, Earth (Sun + 180°), Moon, North Node, South Node, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto
4. **Conscious activations**: Tropical longitude + 58° → HD wheel position → gate (÷ 5.625) → line (remainder ÷ 0.9375 + 1)
5. **Prenatal date**: Birth Sun position - 88° → find date when Sun was at that position
6. **Unconscious activations**: Same mapping for prenatal positions
7. **Channels**: Both gates of a channel activated → channel active
8. **Centers**: Active channel → both connected centers defined
9. **Type**: Based on defined centers (Sacral, Throat, motor connections)
10. **Authority**: Hierarchy based on defined centers
11. **Profile**: Conscious Sun line / Unconscious Sun line
12. **Definition**: How defined centers connect (single, split, triple, quad)

### Step 5: Cross-reference against humdes.com

If possible, fetch the chart from humdes.com for the same birth data using WebFetch and compare:
- Conscious Sun gate and line
- Conscious Earth gate and line
- Unconscious (Design) Sun gate and line
- Type
- Authority
- Profile
- Definition type
- Incarnation Cross name (based on Sun/Earth gates)

### Step 6: Report findings

```
Chart Validation Report
=======================
Birth Data: <date> <time> <location>

Test Suite: ✓ PASS / ✗ FAIL
58° Offset: ✓ Applied / ✗ Missing

Component          | Calculated | Expected  | Status
-------------------|-----------|-----------|-------
Conscious Sun      | Gate X.Y  | Gate X.Y  | ✓/✗
Conscious Earth    | Gate X.Y  | Gate X.Y  | ✓/✗
Design Sun         | Gate X.Y  | Gate X.Y  | ✓/✗
Design Earth       | Gate X.Y  | Gate X.Y  | ✓/✗
Type               | ...       | ...       | ✓/✗
Authority          | ...       | ...       | ✓/✗
Profile            | X/Y       | X/Y       | ✓/✗
Definition         | ...       | ...       | ✓/✗
Incarnation Cross  | ...       | ...       | ✓/✗

Discrepancies: <count>
Details: <explanation of any mismatches>
```

Example usage:
- `/check-chart 1985-03-15 14:30 New York`
- `/check-chart 1990-07-22 08:00 London`
- `/check-chart 2000-12-01 23:45 Kyiv`
