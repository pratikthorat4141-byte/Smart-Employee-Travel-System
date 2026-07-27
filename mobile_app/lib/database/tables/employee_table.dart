class EmployeeTable {
  EmployeeTable._();

  static const String tableName = 'employees';

  static const String id = 'id';
  static const String employeeId = 'employeeId';
  static const String name = 'name';
  static const String department = 'department';
  static const String designation = 'designation';
  static const String mobile = 'mobile';
  static const String email = 'email';
  static const String address = 'address';
  static const String gender = 'gender';
  static const String joiningDate = 'joiningDate';
  static const String isActive = 'isActive';

  static const String createTable = '''
CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT,
  $employeeId TEXT NOT NULL UNIQUE,
  $name TEXT NOT NULL,
  $department TEXT NOT NULL,
  $designation TEXT NOT NULL,
  $mobile TEXT NOT NULL,
  $email TEXT NOT NULL,
  $address TEXT,
  $gender TEXT,
  $joiningDate TEXT,
  $isActive INTEGER NOT NULL DEFAULT 1
);
''';
}