class DriverTable {
  DriverTable._();

  static const String tableName = 'drivers';

  static const String id = 'id';
  static const String driverId = 'driverId';
  static const String name = 'name';
  static const String mobile = 'mobile';
  static const String email = 'email';
  static const String licenseNumber = 'licenseNumber';
  static const String address = 'address';
  static const String gender = 'gender';
  static const String joiningDate = 'joiningDate';
  static const String isAvailable = 'isAvailable';
  static const String isActive = 'isActive';

  static const String createTable = '''
CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT,
  $driverId TEXT NOT NULL UNIQUE,
  $name TEXT NOT NULL,
  $mobile TEXT NOT NULL,
  $email TEXT NOT NULL,
  $licenseNumber TEXT NOT NULL,
  $address TEXT,
  $gender TEXT,
  $joiningDate TEXT,
  $isAvailable INTEGER NOT NULL DEFAULT 1,
  $isActive INTEGER NOT NULL DEFAULT 1
);
''';
}