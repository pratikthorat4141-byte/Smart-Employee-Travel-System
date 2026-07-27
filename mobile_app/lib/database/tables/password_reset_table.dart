class PasswordResetTable {
  PasswordResetTable._();

  static const String tableName = "password_reset";

  static const String id = "id";

  static const String email = "email";

  static const String otp = "otp";

  static const String expiry = "expiry";

  static const String verified = "verified";

  static const String createdAt = "createdAt";

  static const String createTable = '''
CREATE TABLE $tableName(

$id INTEGER PRIMARY KEY AUTOINCREMENT,

$email TEXT NOT NULL,

$otp TEXT NOT NULL,

$expiry TEXT NOT NULL,

$verified INTEGER NOT NULL DEFAULT 0,

$createdAt TEXT NOT NULL

)
''';
}