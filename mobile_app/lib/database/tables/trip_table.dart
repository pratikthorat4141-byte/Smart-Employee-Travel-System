class TripTable {
  TripTable._();

  static const String tableName = 'trips';

  static const String id = 'id';
  static const String tripId = 'tripId';

  static const String employeeId = 'employeeId';
  static const String driverId = 'driverId';
  static const String vehicleId = 'vehicleId';

  static const String pickupLocation = 'pickupLocation';
  static const String destination = 'destination';

  static const String tripDate = 'tripDate';
  static const String tripTime = 'tripTime';

  static const String totalDistance = 'totalDistance';

  static const String status = 'status';

  static const String remarks = 'remarks';

  static const String createdAt = 'createdAt';

  static const String createTable = '''
CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT,
  $tripId TEXT NOT NULL UNIQUE,

  $employeeId INTEGER NOT NULL,
  $driverId INTEGER NOT NULL,
  $vehicleId INTEGER NOT NULL,

  $pickupLocation TEXT NOT NULL,
  $destination TEXT NOT NULL,

  $tripDate TEXT NOT NULL,
  $tripTime TEXT NOT NULL,

  $totalDistance REAL NOT NULL,

  $status TEXT NOT NULL,

  $remarks TEXT,

  $createdAt TEXT NOT NULL,

  FOREIGN KEY($employeeId) REFERENCES employees(id) ON DELETE CASCADE,
  FOREIGN KEY($driverId) REFERENCES drivers(id) ON DELETE CASCADE,
  FOREIGN KEY($vehicleId) REFERENCES vehicles(id) ON DELETE CASCADE
);
''';
}