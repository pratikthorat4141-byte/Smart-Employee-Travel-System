import 'package:sqflite/sqflite.dart';

import '../../models/password_reset_model.dart';
import '../database_helper.dart';
import '../tables/password_reset_table.dart';

class PasswordResetDao {
  PasswordResetDao._();

  static final PasswordResetDao instance =
      PasswordResetDao._();

  Future<Database> get _db async =>
      DatabaseHelper.instance.database;

  //--------------------------------------------------------------------
  // INSERT OTP
  //--------------------------------------------------------------------

  Future<int> insert(
    PasswordResetModel model,
  ) async {
    final db = await _db;

    return db.insert(
      PasswordResetTable.tableName,
      model.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  //--------------------------------------------------------------------
  // GET LATEST OTP
  //--------------------------------------------------------------------

  Future<PasswordResetModel?> getLatestOtp(
    String email,
  ) async {
    final db = await _db;

    final result = await db.query(
      PasswordResetTable.tableName,
      where:
          '${PasswordResetTable.email}=?',
      whereArgs: [email],
      orderBy:
          '${PasswordResetTable.id} DESC',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return PasswordResetModel.fromMap(
      result.first,
    );
  }

  //--------------------------------------------------------------------
  // VERIFY OTP
  //--------------------------------------------------------------------

  Future<void> verifyOtp(
    int id,
  ) async {
    final db = await _db;

    await db.update(
      PasswordResetTable.tableName,
      {
        PasswordResetTable.verified: 1,
      },
      where:
          '${PasswordResetTable.id}=?',
      whereArgs: [id],
    );
  }

  //--------------------------------------------------------------------
  // DELETE USER OTP
  //--------------------------------------------------------------------

  Future<void> deleteOtp(
    String email,
  ) async {
    final db = await _db;

    await db.delete(
      PasswordResetTable.tableName,
      where:
          '${PasswordResetTable.email}=?',
      whereArgs: [email],
    );
  }

  //--------------------------------------------------------------------
  // DELETE ALL
  //--------------------------------------------------------------------

  Future<void> deleteAll() async {
    final db = await _db;

    await db.delete(
      PasswordResetTable.tableName,
    );
  }
}