class PasswordResetOtpTable {
  PasswordResetOtpTable._();

  static const tableName = 'password_reset_otp';

  static const id = 'id';
  static const email = 'email';
  static const mobile = 'mobile';
  static const otp = 'otp';
  static const createdAt = 'createdAt';
  static const expiresAt = 'expiresAt';
  static const isVerified = 'isVerified';

  static const createTable = '''
CREATE TABLE $tableName(

$id INTEGER PRIMARY KEY AUTOINCREMENT,

$email TEXT,

$mobile TEXT,

$otp TEXT NOT NULL,

$createdAt TEXT NOT NULL,

$expiresAt TEXT NOT NULL,

$isVerified INTEGER NOT NULL DEFAULT 0

)
''';
}