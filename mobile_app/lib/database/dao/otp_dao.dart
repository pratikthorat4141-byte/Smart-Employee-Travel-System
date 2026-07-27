import 'package:sqflite/sqflite.dart';

import '../../models/otp_model.dart';
import '../database_helper.dart';
import '../tables/otp_table.dart';

class OtpDao {
  OtpDao._();

  static final OtpDao instance = OtpDao._();

  Future<Database> get _db async =>
      DatabaseHelper.instance.database;

  //==========================================================
  // INSERT OTP
  //==========================================================

  Future<int> insert(
    OtpModel otp,
  ) async {
    final db = await _db;

    return await db.insert(
      OtpTable.tableName,
      otp.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  //==========================================================
  // UPDATE OTP
  //==========================================================

  Future<int> update(
    OtpModel otp,
  ) async {
    final db = await _db;

    return await db.update(
      OtpTable.tableName,
      otp.toMap(),
      where: '${OtpTable.id}=?',
      whereArgs: [otp.id],
    );
  }

  //==========================================================
  // DELETE OTP
  //==========================================================

  Future<int> delete(
    int id,
  ) async {
    final db = await _db;

    return await db.delete(
      OtpTable.tableName,
      where: '${OtpTable.id}=?',
      whereArgs: [id],
    );
  }

  //==========================================================
  // GET BY ID
  //==========================================================

  Future<OtpModel?> getById(
    int id,
  ) async {
    final db = await _db;

    final result = await db.query(
      OtpTable.tableName,
      where: '${OtpTable.id}=?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return OtpModel.fromMap(
      result.first,
    );
  }

  //==========================================================
  // GET ALL
  //==========================================================

  Future<List<OtpModel>> getAll() async {
    final db = await _db;

    final result = await db.query(
      OtpTable.tableName,
      orderBy:
          '${OtpTable.generatedAt} DESC',
    );

    return result
        .map(OtpModel.fromMap)
        .toList();
  }

  //==========================================================
  // GET LATEST OTP
  //==========================================================

  Future<OtpModel?> getLatestOtp(
    String tripId,
    String otpType,
  ) async {
    final db = await _db;

    final result = await db.query(
      OtpTable.tableName,
      where:
          '${OtpTable.tripId}=? AND ${OtpTable.otpType}=?',
      whereArgs: [
        tripId,
        otpType,
      ],
      orderBy:
          '${OtpTable.generatedAt} DESC',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return OtpModel.fromMap(
      result.first,
    );
  }

  //==========================================================
  // VERIFY OTP
  //==========================================================

  Future<bool> verifyOtp({
    required String tripId,
    required String otp,
    required String otpType,
  }) async {
    final latest =
        await getLatestOtp(
      tripId,
      otpType,
    );

    if (latest == null) {
      return false;
    }

    if (latest.isVerified) {
      return false;
    }

    if (latest.otp != otp) {
      return false;
    }

    final now =
        DateTime.now();

    final expiry =
        DateTime.parse(
      latest.expiresAt,
    );

    if (now.isAfter(expiry)) {
      return false;
    }

    final updated =
        latest.copyWith(
      isVerified: true,
      verifiedAt:
          now.toIso8601String(),
    );

    await update(updated);

    return true;
  }

  //==========================================================
  // DELETE EXPIRED OTP
  //==========================================================

  Future<void> deleteExpiredOtp()
  async {
    final db = await _db;

    await db.delete(
      OtpTable.tableName,
      where:
          '${OtpTable.expiresAt}<?',
      whereArgs: [
        DateTime.now()
            .toIso8601String()
      ],
    );
  }

  //==========================================================
  // DELETE ALL
  //==========================================================

  Future<void> deleteAll()
  async {
    final db = await _db;

    await db.delete(
      OtpTable.tableName,
    );
  }

  //==========================================================
  // COUNT
  //==========================================================

  Future<int> count() async {
    final db = await _db;

    final result =
        await db.rawQuery(
      'SELECT COUNT(*) FROM ${OtpTable.tableName}',
    );

    return Sqflite.firstIntValue(
          result,
        ) ??
        0;
  }
}
