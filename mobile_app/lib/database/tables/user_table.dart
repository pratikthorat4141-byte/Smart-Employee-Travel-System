class UserTable {
  UserTable._();

  static const String tableName = 'users';

  static const String id = 'id';
  static const String name = 'name';
  static const String email = 'email';
  static const String mobile = 'mobile';
  static const String password = 'password';
  static const String role = 'role';

  static const String createTable = '''
CREATE TABLE $tableName(

$id INTEGER PRIMARY KEY AUTOINCREMENT,

$name TEXT NOT NULL,

$email TEXT NOT NULL UNIQUE,

$mobile TEXT NOT NULL UNIQUE,

$password TEXT NOT NULL,

$role TEXT NOT NULL

)
''';
}