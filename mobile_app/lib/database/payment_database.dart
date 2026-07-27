import 'package:sqflite/sqflite.dart';

import '../models/payment_model.dart';

class PaymentDatabase {
  PaymentDatabase._();

  static const String tableName =
      'payments';

  //--------------------------------------------------
  // CREATE TABLE
  //--------------------------------------------------

  static Future<void> createTable(
    Database db,
  ) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName(

        id INTEGER PRIMARY KEY AUTOINCREMENT,

        paymentId TEXT NOT NULL,

        tripId TEXT NOT NULL,

        employeeId INTEGER NOT NULL,

        driverId INTEGER NOT NULL,

        amount REAL NOT NULL,

        gst REAL NOT NULL,

        totalAmount REAL NOT NULL,

        paymentMethod TEXT NOT NULL,

        paymentStatus TEXT NOT NULL,

        transactionId TEXT,

        paymentDate TEXT NOT NULL,

        remarks TEXT,

        createdAt TEXT NOT NULL

      )
    ''');
  }

  //--------------------------------------------------
  // INSERT
  //--------------------------------------------------

  static Future<int> insert(
    Database db,
    PaymentModel payment,
  ) async {
    return await db.insert(
      tableName,
      payment.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  //--------------------------------------------------
  // UPDATE
  //--------------------------------------------------

  static Future<int> update(
    Database db,
    PaymentModel payment,
  ) async {
    return await db.update(
      tableName,
      payment.toMap(),
      where: 'paymentId = ?',
      whereArgs: [
        payment.paymentId,
      ],
    );
  }
    //--------------------------------------------------
  // DELETE
  //--------------------------------------------------

  static Future<int> delete(
    Database db,
    String paymentId,
  ) async {
    return await db.delete(
      tableName,
      where: 'paymentId = ?',
      whereArgs: [
        paymentId,
      ],
    );
  }

  //--------------------------------------------------
  // GET ALL PAYMENTS
  //--------------------------------------------------

  static Future<List<PaymentModel>>
      getAllPayments(
    Database db,
  ) async {
    final result = await db.query(
      tableName,
      orderBy: 'createdAt DESC',
    );

    return result
        .map(
          (e) => PaymentModel.fromMap(e),
        )
        .toList();
  }

  //--------------------------------------------------
  // GET PAYMENT BY ID
  //--------------------------------------------------

  static Future<PaymentModel?>
      getPaymentById(
    Database db,
    String paymentId,
  ) async {
    final result = await db.query(
      tableName,
      where: 'paymentId = ?',
      whereArgs: [
        paymentId,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return PaymentModel.fromMap(
      result.first,
    );
  }

  //--------------------------------------------------
  // SEARCH PAYMENTS
  //--------------------------------------------------

  static Future<List<PaymentModel>>
      searchPayments(
    Database db,
    String keyword,
  ) async {
    final result = await db.query(
      tableName,
      where:
          '''
paymentId LIKE ?
OR tripId LIKE ?
OR transactionId LIKE ?
''',
      whereArgs: [
        '%$keyword%',
        '%$keyword%',
        '%$keyword%',
      ],
      orderBy: 'createdAt DESC',
    );

    return result
        .map(
          (e) => PaymentModel.fromMap(e),
        )
        .toList();
  }

  //--------------------------------------------------
  // GET BY STATUS
  //--------------------------------------------------

  static Future<List<PaymentModel>>
      getPaymentsByStatus(
    Database db,
    String status,
  ) async {
    final result = await db.query(
      tableName,
      where: 'paymentStatus = ?',
      whereArgs: [
        status,
      ],
      orderBy: 'createdAt DESC',
    );

    return result
        .map(
          (e) => PaymentModel.fromMap(e),
        )
        .toList();
  }
    //--------------------------------------------------
  // TOTAL REVENUE
  //--------------------------------------------------

  static Future<double> getTotalRevenue(
    Database db,
  ) async {
    final result = await db.rawQuery(
      '''
      SELECT SUM(totalAmount) AS revenue
      FROM $tableName
      WHERE paymentStatus = 'Paid'
      ''',
    );

    return (result.first['revenue'] as num?)
            ?.toDouble() ??
        0.0;
  }

  //--------------------------------------------------
  // TOTAL GST
  //--------------------------------------------------

  static Future<double> getTotalGST(
    Database db,
  ) async {
    final result = await db.rawQuery(
      '''
      SELECT SUM(gst) AS gst
      FROM $tableName
      WHERE paymentStatus = 'Paid'
      ''',
    );

    return (result.first['gst'] as num?)
            ?.toDouble() ??
        0.0;
  }

  //--------------------------------------------------
  // TODAY REVENUE
  //--------------------------------------------------

  static Future<double> getTodayRevenue(
    Database db,
  ) async {
    final today =
        DateTime.now()
            .toIso8601String()
            .split('T')
            .first;

    final result = await db.rawQuery(
      '''
      SELECT SUM(totalAmount) AS revenue
      FROM $tableName
      WHERE paymentStatus='Paid'
      AND paymentDate LIKE ?
      ''',
      ['$today%'],
    );

    return (result.first['revenue'] as num?)
            ?.toDouble() ??
        0.0;
  }

  //--------------------------------------------------
  // MONTHLY REVENUE
  //--------------------------------------------------

  static Future<double> getMonthlyRevenue(
    Database db,
    int month,
    int year,
  ) async {
    final monthString =
        month.toString().padLeft(2, '0');

    final result = await db.rawQuery(
      '''
      SELECT SUM(totalAmount) AS revenue
      FROM $tableName
      WHERE paymentStatus='Paid'
      AND strftime('%m', paymentDate)=?
      AND strftime('%Y', paymentDate)=?
      ''',
      [
        monthString,
        year.toString(),
      ],
    );

    return (result.first['revenue'] as num?)
            ?.toDouble() ??
        0.0;
  }

  //--------------------------------------------------
  // PAYMENT COUNTS
  //--------------------------------------------------

  static Future<int> getPaymentCount(
    Database db,
  ) async {
    final result = Sqflite.firstIntValue(
      await db.rawQuery(
        '''
        SELECT COUNT(*) FROM $tableName
        ''',
      ),
    );

    return result ?? 0;
  }

  //--------------------------------------------------
  // PAID COUNT
  //--------------------------------------------------

  static Future<int> getPaidCount(
    Database db,
  ) async {
    final result = Sqflite.firstIntValue(
      await db.rawQuery(
        '''
        SELECT COUNT(*)
        FROM $tableName
        WHERE paymentStatus='Paid'
        ''',
      ),
    );

    return result ?? 0;
  }

  //--------------------------------------------------
  // PENDING COUNT
  //--------------------------------------------------

  static Future<int> getPendingCount(
    Database db,
  ) async {
    final result = Sqflite.firstIntValue(
      await db.rawQuery(
        '''
        SELECT COUNT(*)
        FROM $tableName
        WHERE paymentStatus='Pending'
        ''',
      ),
    );

    return result ?? 0;
  }

  //--------------------------------------------------
  // FAILED COUNT
  //--------------------------------------------------

  static Future<int> getFailedCount(
    Database db,
  ) async {
    final result = Sqflite.firstIntValue(
      await db.rawQuery(
        '''
        SELECT COUNT(*)
        FROM $tableName
        WHERE paymentStatus='Failed'
        ''',
      ),
    );

    return result ?? 0;
  }
    //--------------------------------------------------
  // PAYMENT METHOD COUNT
  //--------------------------------------------------

  static Future<int> getPaymentMethodCount(
    Database db,
    String method,
  ) async {
    final result = Sqflite.firstIntValue(
      await db.rawQuery(
        '''
        SELECT COUNT(*)
        FROM $tableName
        WHERE paymentMethod = ?
        ''',
        [method],
      ),
    );

    return result ?? 0;
  }

  //--------------------------------------------------
  // PAYMENT METHOD REVENUE
  //--------------------------------------------------

  static Future<double> getPaymentMethodRevenue(
    Database db,
    String method,
  ) async {
    final result = await db.rawQuery(
      '''
      SELECT SUM(totalAmount) AS revenue
      FROM $tableName
      WHERE paymentStatus='Paid'
      AND paymentMethod = ?
      ''',
      [method],
    );

    return (result.first['revenue'] as num?)
            ?.toDouble() ??
        0.0;
  }

  //--------------------------------------------------
  // DELETE ALL PAYMENTS
  //--------------------------------------------------

  static Future<int> deleteAll(
    Database db,
  ) async {
    return await db.delete(
      tableName,
    );
  }

  //--------------------------------------------------
  // DROP TABLE
  //--------------------------------------------------

  static Future<void> dropTable(
    Database db,
  ) async {
    await db.execute(
      'DROP TABLE IF EXISTS $tableName',
    );
  }

  //--------------------------------------------------
  // CLOSE
  //--------------------------------------------------
}