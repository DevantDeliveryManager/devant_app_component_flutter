import 'package:timezone/data/latest_10y.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Where a session's times are read when its service gives no zone.
const String defaultSessionTimezone = 'Asia/Kolkata';

bool _zonesLoaded = false;

/// The IANA zone named [name]; [defaultSessionTimezone] when it's missing or
/// unknown. Loads the zone database on first use.
tz.Location _zone(String? name) {
  if (!_zonesLoaded) {
    tz_data.initializeTimeZones();
    _zonesLoaded = true;
  }
  final id = (name?.trim().isNotEmpty ?? false) ? name!.trim() : null;
  try {
    return tz.getLocation(id ?? defaultSessionTimezone);
  } on tz.LocationNotFoundException {
    return tz.getLocation(defaultSessionTimezone);
  }
}

/// When a session starts, as a local [DateTime].
///
/// [date] is the session's calendar day, sent as midnight UTC (only the
/// `YYYY-MM-DD` part counts), and [time] is `HH:mm` on the wall clock of
/// [timezone]. Returns `null` when either is missing or malformed.
DateTime? sessionStartLocal({
  required DateTime? date,
  required String time,
  String? timezone,
}) {
  final day = date?.toUtc();
  final parts = time.split(':');
  if (day == null || parts.length < 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;

  return tz.TZDateTime(
    _zone(timezone),
    day.year,
    day.month,
    day.day,
    hour,
    minute,
  ).toLocal();
}

/// The session's own clock, when it differs from the seeker's: `9:00 AM
/// IST` style parts — its wall time [time] and zone abbreviation — or `null`
/// when the seeker is in the same offset, so nothing extra needs showing.
({String time, String zone})? sessionZoneHint({
  required DateTime start,
  required String time,
  String? timezone,
}) {
  final zoned = tz.TZDateTime.from(start, _zone(timezone));
  if (zoned.timeZoneOffset == start.timeZoneOffset) return null;
  return (time: time, zone: zoned.timeZoneName);
}
