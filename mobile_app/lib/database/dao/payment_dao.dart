import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../tables/payment_table.dart';
import '../../models/payment_model.dart';

class PaymentDao {
  PaymentDao._();

  static final PaymentDao instance = PaymentDao._();

  final DatabaseHelper _helper =
      DatabaseHelper.instance;

  //----------------------------------------------------------
  // INSERT
  //----------------------------------------------------------

  Future<int> insert(
    PaymentModel payment,
  ) async {
    final db = await _helper.database;

    return await db.insert(
      PaymentTable.tableName,
      payment.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  //----------------------------------------------------------
  // UPDATE
  //----------------------------------------------------------

  Future<int> update(
    PaymentModel payment,
  ) async {
    final db = await _helper.database;

    return await db.update(
      PaymentTable.tableName,
      payment.toMap(),
      where:
          '${PaymentTable.id}=?',
      whereArgs: [
        payment.id,
      ],
    );
  }

  //----------------------------------------------------------
  // DELETE
  //----------------------------------------------------------

  Future<int> delete(
    int id,
  ) async {
    final db = await _helper.database;

    return await db.delete(
      PaymentTable.tableName,
      where:
          '${PaymentTable.id}=?',
      whereArgs: [id],
    );
  }

  //----------------------------------------------------------
  // GET ALL
  //----------------------------------------------------------

  Future<List<PaymentModel>>
      getAll() async {
    final db = await _helper.database;

    final result =
        await db.query(
      PaymentTable.tableName,
      orderBy:
          '${PaymentTable.paymentDate} DESC',
    );

    return result
        .map(
          (e) =>
              PaymentModel.fromMap(
            e,
          ),
        )
        .toList();
  }
    //----------------------------------------------------------
  // GET BY ID
  //----------------------------------------------------------

  Future<PaymentModel?> getById(
    int id,
  ) async {
    final db = await _helper.database;

    final result = await db.query(
      PaymentTable.tableName,
      where: '${PaymentTable.id}=?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return PaymentModel.fromMap(
      result.first,
    );
  }

  //----------------------------------------------------------
  // GET BY PAYMENT ID
  //----------------------------------------------------------

  Future<PaymentModel?> getByPaymentId(
    String paymentId,
  ) async {
    final db = await _helper.database;

    final result = await db.query(
      PaymentTable.tableName,
      where: '${PaymentTable.paymentId}=?',
      whereArgs: [paymentId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return PaymentModel.fromMap(
      result.first,
    );
  }

  //----------------------------------------------------------
  // EMPLOYEE PAYMENTS
  //----------------------------------------------------------

  Future<List<PaymentModel>>
      getEmployeePayments(
    int employeeId,
  ) async {
    final db = await _helper.database;

    final result = await db.query(
      PaymentTable.tableName,
      where:
          '${PaymentTable.employeeId}=?',
      whereArgs: [employeeId],
      orderBy:
          '${PaymentTable.paymentDate} DESC',
    );

    return result
        .map(
          (e) =>
              PaymentModel.fromMap(e),
        )
        .toList();
  }

  //----------------------------------------------------------
  // TRIP PAYMENTS
  //----------------------------------------------------------

  Future<List<PaymentModel>>
      getTripPayments(
    String tripId,
  ) async {
    final db = await _helper.database;

    final result = await db.query(
      PaymentTable.tableName,
      where:
          '${PaymentTable.tripId}=?',
      whereArgs: [tripId],
      orderBy:
          '${PaymentTable.paymentDate} DESC',
    );

    return result
        .map(
          (e) =>
              PaymentModel.fromMap(e),
        )
        .toList();
  }

  //----------------------------------------------------------
  // STATUS PAYMENTS
  //----------------------------------------------------------

  Future<List<PaymentModel>>
      getByStatus(
    String status,
  ) async {
    final db = await _helper.database;

    final result = await db.query(
      PaymentTable.tableName,
      where:
          '${PaymentTable.paymentStatus}=?',
      whereArgs: [status],
      orderBy:
          '${PaymentTable.paymentDate} DESC',
    );

    return result
        .map(
          (e) =>
              PaymentModel.fromMap(e),
        )
        .toList();
  }
    //----------------------------------------------------------
  // UPDATE STATUS
  //----------------------------------------------------------

  Future<int> updateStatus({
    required int id,
    required String status,
    String? transactionId,
  }) async {
    final db = await _helper.database;

    final values = <String, dynamic>{
      PaymentTable.paymentStatus: status,
    };

    if (transactionId != null) {
      values[PaymentTable.transactionId] =
          transactionId;
    }

    return await db.update(
      PaymentTable.tableName,
      values,
      where: '${PaymentTable.id}=?',
      whereArgs: [id],
    );
  }

  //----------------------------------------------------------
  // GET ALL PAYMENTS
  //----------------------------------------------------------

  Future<List<PaymentModel>>
      getAllPayments() async {
    return await getAll();
  }

  //----------------------------------------------------------
  // TOTAL REVENUE
  //----------------------------------------------------------

  Future<double> getTotalRevenue() async {
    final db = await _helper.database;

    final result = await db.rawQuery('''
SELECT SUM(${PaymentTable.totalAmount}) total
FROM ${PaymentTable.tableName}
WHERE ${PaymentTable.paymentStatus}='Paid'
''');

    return ((result.first['total'] ?? 0) as num)
        .toDouble();
  }

  //----------------------------------------------------------
  // TOTAL GST
  //----------------------------------------------------------

  Future<double> getTotalGST() async {
    final db = await _helper.database;

    final result = await db.rawQuery('''
SELECT SUM(${PaymentTable.gst}) total
FROM ${PaymentTable.tableName}
''');

    return ((result.first['total'] ?? 0) as num)
        .toDouble();
  }

  //----------------------------------------------------------
  // TOTAL BASE AMOUNT
  //----------------------------------------------------------

  Future<double> getTotalBaseAmount() async {
    final db = await _helper.database;

    final result = await db.rawQuery('''
SELECT SUM(${PaymentTable.amount}) total
FROM ${PaymentTable.tableName}
''');

    return ((result.first['total'] ?? 0) as num)
        .toDouble();
  }

  //----------------------------------------------------------
  // TODAY REVENUE
  //----------------------------------------------------------

  Future<double> getTodayRevenue() async {
    final db = await _helper.database;

    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).toIso8601String();

    final end = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    ).toIso8601String();

    final result = await db.rawQuery('''
SELECT SUM(${PaymentTable.totalAmount}) total
FROM ${PaymentTable.tableName}
WHERE ${PaymentTable.paymentStatus}='Paid'
AND ${PaymentTable.paymentDate}
BETWEEN ? AND ?
''', [start, end]);

    return ((result.first['total'] ?? 0) as num)
        .toDouble();
  }

  //----------------------------------------------------------
  // COUNT
  //----------------------------------------------------------

  Future<int> getCount() async {
    final db = await _helper.database;

    final result = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM ${PaymentTable.tableName}',
      ),
    );

    return result ?? 0;
  }

  //----------------------------------------------------------
  // CLEAR
  //----------------------------------------------------------

  Future<void> clear() async {
    final db = await _helper.database;

    await db.delete(
      PaymentTable.tableName,
    );
  }
}