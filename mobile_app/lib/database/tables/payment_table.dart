class PaymentTable {
  PaymentTable._();

  static const String tableName = 'payments';

  static const String id = 'id';

  static const String paymentId = 'paymentId';
  static const String tripId = 'tripId';

  static const String employeeId = 'employeeId';
  static const String employeeName = 'employeeName';

  static const String driverId = 'driverId';
  static const String vehicleId = 'vehicleId';

  static const String amount = 'amount';
  static const String gst = 'gst';
  static const String totalAmount = 'totalAmount';

  static const String paymentMethod = 'paymentMethod';
  static const String paymentStatus = 'paymentStatus';

  static const String transactionId = 'transactionId';

  static const String razorpayOrderId =
      'razorpayOrderId';

  static const String razorpayPaymentId =
      'razorpayPaymentId';

  static const String razorpaySignature =
      'razorpaySignature';

  static const String invoiceNumber =
      'invoiceNumber';

  static const String paymentDate =
      'paymentDate';

  static const String createdAt =
      'createdAt';

  static const String updatedAt =
      'updatedAt';

  static const String remarks =
      'remarks';

  static const String createTable = '''
CREATE TABLE $tableName(

$id INTEGER PRIMARY KEY AUTOINCREMENT,

$paymentId TEXT NOT NULL UNIQUE,

$tripId TEXT NOT NULL,

$employeeId INTEGER NOT NULL,

$employeeName TEXT NOT NULL,

$driverId INTEGER NOT NULL,

$vehicleId INTEGER NOT NULL,

$amount REAL NOT NULL,

$gst REAL NOT NULL,

$totalAmount REAL NOT NULL,

$paymentMethod TEXT NOT NULL,

$paymentStatus TEXT NOT NULL,

$transactionId TEXT,

$razorpayOrderId TEXT,

$razorpayPaymentId TEXT,

$razorpaySignature TEXT,

$invoiceNumber TEXT,

$paymentDate TEXT NOT NULL,

$createdAt TEXT NOT NULL,

$updatedAt TEXT NOT NULL,

$remarks TEXT,

FOREIGN KEY($employeeId)
REFERENCES employees(id)
ON DELETE CASCADE,

FOREIGN KEY($driverId)
REFERENCES drivers(id)
ON DELETE CASCADE,

FOREIGN KEY($vehicleId)
REFERENCES vehicles(id)
ON DELETE CASCADE

);
''';
}