import 'package:sqflite/sqflite.dart';

import '../../models/password_reset_otp_model.dart';
import '../database_helper.dart';
import '../tables/password_reset_otp_table.dart';

class PasswordResetOtpDao {
  PasswordResetOtpDao._();

  static final PasswordResetOtpDao instance =
      PasswordResetOtpDao._();

  Future<Database> get _db async =>
      DatabaseHelper.instance.database;

  //==========================================================
  // INSERT OTP
  //==========================================================

  Future<int> insert(
    PasswordResetOtpModel otp,
  ) async {
    final db = await _db;

    return await db.insert(
      PasswordResetOtpTable.tableName,
      otp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //==========================================================
  // UPDATE
  //==========================================================

  Future<int> update(
    PasswordResetOtpModel otp,
  ) async {
    final db = await _db;

    return await db.update(
      PasswordResetOtpTable.tableName,
      otp.toMap(),
      where:
          '${PasswordResetOtpTable.id}=?',
      whereArgs: [otp.id],
    );
  }

  //==========================================================
  // GET LATEST OTP
  //==========================================================

  Future<PasswordResetOtpModel?>
      getLatestOtp(
    String email,
  ) async {
    final db = await _db;

    final result = await db.query(
      PasswordResetOtpTable.tableName,
      where:
          '${PasswordResetOtpTable.email}=?',
      whereArgs: [email],
      orderBy:
          '${PasswordResetOtpTable.generatedAt} DESC',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return PasswordResetOtpModel.fromMap(
      result.first,
    );
  }

  //==========================================================
  // VERIFY OTP
  //==========================================================

  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final latest =
        await getLatestOtp(email);

    if (latest == null) {
      return false;
    }

    if (latest.verified) {
      return false;
    }

    if (latest.otp != otp) {
      return false;
    }

    final expiry = DateTime.parse(
      latest.expiresAt,
    );

    if (DateTime.now().isAfter(expiry)) {
      return false;
    }

    await update(
      latest.copyWith(
        verified: true,
      ),
    );

    return true;
  }

  //==========================================================
  // DELETE EXPIRED OTP
  //==========================================================

  Future<void> deleteExpiredOtp()
      async {
    final db = await _db;

    await db.delete(
      PasswordResetOtpTable.tableName,
      where:
          '${PasswordResetOtpTable.expiresAt} < ?',
      whereArgs: [
        DateTime.now().toIso8601String(),
      ],
    );
  }

  //==========================================================
  // DELETE BY EMAIL
  //==========================================================

  Future<void> deleteByEmail(
    String email,
  ) async {
    final db = await _db;

    await db.delete(
      PasswordResetOtpTable.tableName,
      where:
          '${PasswordResetOtpTable.email}=?',
      whereArgs: [email],
    );
  }

  //==========================================================
  // DELETE ALL
  //==========================================================

  Future<void> deleteAll() async {
    final db = await _db;

    await db.delete(
      PasswordResetOtpTable.tableName,
    );
  }

  //==========================================================
  // COUNT
  //==========================================================

  Future<int> count() async {
    final db = await _db;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${PasswordResetOtpTable.tableName}',
    );

    return Sqflite.firstIntValue(result) ??
        0;
  }
}