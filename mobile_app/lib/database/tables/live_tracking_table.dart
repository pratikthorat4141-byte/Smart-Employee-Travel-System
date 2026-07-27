class LiveTrackingTable {
  LiveTrackingTable._();

  static const String tableName = "live_tracking";

  static const String id = "id";
  static const String driverId = "driverId";
  static const String tripId = "tripId";

  static const String latitude = "latitude";
  static const String longitude = "longitude";

  static const String speed = "speed";
  static const String heading = "heading";
  static const String accuracy = "accuracy";

  static const String createdAt = "createdAt";

  static const String createTable = '''
CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT,
  $driverId TEXT NOT NULL,
  $tripId INTEGER,
  $latitude REAL NOT NULL,
  $longitude REAL NOT NULL,
  $speed REAL DEFAULT 0,
  $heading REAL DEFAULT 0,
  $accuracy REAL DEFAULT 0,
  $createdAt TEXT NOT NULL
);
''';
}