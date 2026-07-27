class OtpTable {
  OtpTable._();

  static const String tableName = 'otp';

  //==========================================================
  // Columns
  //==========================================================

  static const String id = 'id';

  static const String tripId = 'tripId';

  static const String employeeId = 'employeeId';

  static const String driverId = 'driverId';

  static const String otp = 'otp';

  // START / END
  static const String otpType = 'otpType';

  // 0 = false
  // 1 = true
  static const String isVerified = 'isVerified';

  static const String generatedAt = 'generatedAt';

  static const String verifiedAt = 'verifiedAt';

  static const String expiresAt = 'expiresAt';

  //==========================================================
  // Create Table
  //==========================================================

  static const String createTable = '''
CREATE TABLE $tableName(

$id INTEGER PRIMARY KEY AUTOINCREMENT,

$tripId TEXT NOT NULL,

$employeeId INTEGER NOT NULL,

$driverId INTEGER NOT NULL,

$otp TEXT NOT NULL,

$otpType TEXT NOT NULL,

$isVerified INTEGER NOT NULL DEFAULT 0,

$generatedAt TEXT NOT NULL,

$verifiedAt TEXT,

$expiresAt TEXT NOT NULL

);
''';
}
