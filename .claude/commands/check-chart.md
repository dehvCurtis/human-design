# Check Chart Calculation

Verify Human Design chart calculations against known data.

## Instructions

When the user provides birth data: `$ARGUMENTS`

1. Parse birth data (date, time, location) from arguments
2. Review the chart calculation logic in:
   - `lib/features/ephemeris/data/ephemeris_service.dart`
   - `lib/features/ephemeris/mappers/degree_to_gate_mapper.dart`
   - `lib/features/chart/domain/usecases/calculate_chart.dart`

3. Trace through the calculation:
   - Birth datetime → Julian Day conversion
   - Planetary position calculations
   - Degree → Gate → Line mapping
   - Channel activation detection
   - Center definition
   - Type, Authority, Profile determination

4. Compare against reference sites like humdes.com if possible

5. Report:
   - Expected planetary positions
   - Expected gate activations
   - Expected type/authority/profile
   - Any discrepancies found

Example usage:
- `/check-chart 1985-03-15 14:30 New York` - Verifies chart for this birth data
