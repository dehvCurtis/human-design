import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(() {
    // Initialize timezone database
    tz.initializeTimeZones();
  });

  group('Timezone Conversion Tests', () {
    test('Salt Lake City timezone conversion - March 20, 1985, 10:24 AM', () {
      // This is the test case from the bug report
      // Birth time: March 20, 1985, 10:24 AM local time in Salt Lake City
      // Salt Lake City uses America/Denver timezone
      // In March 1985, UTC offset was -7 (MST, no DST yet)

      final birthDateTime = DateTime(1985, 3, 20, 10, 24, 0);
      const timezone = 'America/Denver';

      // Convert using the same logic as dateTimeToJulianDay
      final location = tz.getLocation(timezone);
      final localTime = tz.TZDateTime(
        location,
        birthDateTime.year,
        birthDateTime.month,
        birthDateTime.day,
        birthDateTime.hour,
        birthDateTime.minute,
        birthDateTime.second,
      );
      final utcDateTime = localTime.toUtc();

      print('Input local time: $birthDateTime');
      print('Timezone: $timezone');
      print('TZDateTime in $timezone: $localTime');
      print('Converted to UTC: $utcDateTime');
      print('UTC offset applied: ${localTime.timeZoneOffset}');

      // Expected: 10:24 AM MST (UTC-7) = 17:24 UTC
      expect(utcDateTime.hour, 17, reason: '10:24 AM MST should be 17:24 UTC');
      expect(utcDateTime.minute, 24);
      expect(utcDateTime.year, 1985);
      expect(utcDateTime.month, 3);
      expect(utcDateTime.day, 20);
    });

    test('New York timezone conversion - respects DST', () {
      // Test a date during DST (July)
      final birthDateTime = DateTime(1990, 7, 15, 14, 30, 0);
      const timezone = 'America/New_York';

      final location = tz.getLocation(timezone);
      final localTime = tz.TZDateTime(
        location,
        birthDateTime.year,
        birthDateTime.month,
        birthDateTime.day,
        birthDateTime.hour,
        birthDateTime.minute,
        birthDateTime.second,
      );
      final utcDateTime = localTime.toUtc();

      print('\nNew York Summer (DST):');
      print('Input local time: $birthDateTime');
      print('TZDateTime: $localTime');
      print('Converted to UTC: $utcDateTime');
      print('UTC offset: ${localTime.timeZoneOffset}');

      // EDT (Eastern Daylight Time) is UTC-4
      // 14:30 EDT = 18:30 UTC
      expect(utcDateTime.hour, 18, reason: '14:30 EDT should be 18:30 UTC');
    });

    test('London timezone - UTC+0 in winter', () {
      final birthDateTime = DateTime(1988, 1, 30, 5, 0, 0);
      const timezone = 'Europe/London';

      final location = tz.getLocation(timezone);
      final localTime = tz.TZDateTime(
        location,
        birthDateTime.year,
        birthDateTime.month,
        birthDateTime.day,
        birthDateTime.hour,
        birthDateTime.minute,
        birthDateTime.second,
      );
      final utcDateTime = localTime.toUtc();

      print('\nLondon Winter:');
      print('Input local time: $birthDateTime');
      print('Converted to UTC: $utcDateTime');

      // London in January is GMT (UTC+0)
      expect(utcDateTime.hour, 5, reason: 'London winter time should be same as UTC');
    });

    test('Sydney timezone - ahead of UTC', () {
      final birthDateTime = DateTime(1995, 9, 12, 11, 20, 0);
      const timezone = 'Australia/Sydney';

      final location = tz.getLocation(timezone);
      final localTime = tz.TZDateTime(
        location,
        birthDateTime.year,
        birthDateTime.month,
        birthDateTime.day,
        birthDateTime.hour,
        birthDateTime.minute,
        birthDateTime.second,
      );
      final utcDateTime = localTime.toUtc();

      print('\nSydney:');
      print('Input local time: $birthDateTime');
      print('Converted to UTC: $utcDateTime');
      print('UTC offset: ${localTime.timeZoneOffset}');

      // Sydney in September (winter/spring) is AEST (UTC+10)
      // 11:20 AEST = 01:20 UTC
      expect(utcDateTime.hour, 1, reason: '11:20 AEST should be 01:20 UTC');
    });

    test('Seoul timezone - UTC+9', () {
      final birthDateTime = DateTime(1991, 12, 3, 9, 30, 0);
      const timezone = 'Asia/Seoul';

      final location = tz.getLocation(timezone);
      final localTime = tz.TZDateTime(
        location,
        birthDateTime.year,
        birthDateTime.month,
        birthDateTime.day,
        birthDateTime.hour,
        birthDateTime.minute,
        birthDateTime.second,
      );
      final utcDateTime = localTime.toUtc();

      print('\nSeoul:');
      print('Input local time: $birthDateTime');
      print('Converted to UTC: $utcDateTime');

      // Seoul is KST (UTC+9)
      // 9:30 KST = 00:30 UTC
      expect(utcDateTime.hour, 0, reason: '9:30 KST should be 00:30 UTC');
    });
  });
}
