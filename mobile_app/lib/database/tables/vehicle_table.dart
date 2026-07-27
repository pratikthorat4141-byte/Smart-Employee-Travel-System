class VehicleTable {
  VehicleTable._();

  static const String tableName = 'vehicles';

  static const String id = 'id';
  static const String vehicleNumber = 'vehicleNumber';
  static const String vehicleName = 'vehicleName';
  static const String vehicleType = 'vehicleType';
  static const String seatingCapacity = 'seatingCapacity';
  static const String fuelType = 'fuelType';
  static const String registrationDate = 'registrationDate';
  static const String insuranceExpiry = 'insuranceExpiry';
  static const String isAvailable = 'isAvailable';
  static const String isActive = 'isActive';

  static const String createTable = '''
CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT,
  $vehicleNumber TEXT NOT NULL UNIQUE,
  $vehicleName TEXT NOT NULL,
  $vehicleType TEXT NOT NULL,
  $seatingCapacity INTEGER NOT NULL,
  $fuelType TEXT,
  $registrationDate TEXT,
  $insuranceExpiry TEXT,
  $isAvailable INTEGER NOT NULL DEFAULT 1,
  $isActive INTEGER NOT NULL DEFAULT 1
);
''';
}