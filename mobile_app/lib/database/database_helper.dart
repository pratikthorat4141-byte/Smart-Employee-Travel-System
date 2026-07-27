import 'seed_data.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../core/constants/app_constants.dart';

import 'tables/user_table.dart';
import 'tables/employee_table.dart';
import 'tables/driver_table.dart';
import 'tables/vehicle_table.dart';
import 'tables/trip_table.dart';
import 'tables/live_tracking_table.dart';
import 'tables/otp_table.dart';
import 'tables/password_reset_otp_table.dart';
import 'tables/payment_table.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance =
      DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();

    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final dbPath =
        await getDatabasesPath();

    final path = join(
      dbPath,
      AppConstants.databaseName,
    );

    return await openDatabase(
      path,
      version:
          AppConstants.databaseVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: _onOpen,
    );
  }

  //==========================================================
  // CONFIGURE DATABASE
  //==========================================================

  Future<void> _onConfigure(
    Database db,
  ) async {
    await db.execute(
      'PRAGMA foreign_keys = ON',
    );
  }

  //==========================================================
  // DATABASE OPEN
  //==========================================================

  Future<void> _onOpen(
    Database db,
  ) async {}

  //==========================================================
  // DATABASE CREATE
  //==========================================================

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
        //-----------------------------------------
    // USERS
    //-----------------------------------------

    await db.execute(
      UserTable.createTable,
    );

    //-----------------------------------------
    // EMPLOYEES
    //-----------------------------------------

    await db.execute(
      EmployeeTable.createTable,
    );

    //-----------------------------------------
    // DRIVERS
    //-----------------------------------------

    await db.execute(
      DriverTable.createTable,
    );

    //-----------------------------------------
    // VEHICLES
    //-----------------------------------------

    await db.execute(
      VehicleTable.createTable,
    );

    //-----------------------------------------
    // TRIPS
    //-----------------------------------------

    await db.execute(
      TripTable.createTable,
    );

    //-----------------------------------------
    // LIVE TRACKING
    //-----------------------------------------

    await db.execute(
      LiveTrackingTable.createTable,
    );

    //-----------------------------------------
    // OTP
    //-----------------------------------------

    await db.execute(
      OtpTable.createTable,
    );

    //-----------------------------------------
    // PASSWORD RESET OTP
    //-----------------------------------------

    await db.execute(
      PasswordResetOtpTable.createTable,
    );

    //-----------------------------------------
    // PAYMENTS
    //-----------------------------------------

    await db.execute(
      PaymentTable.createTable,
    );

    //-----------------------------------------
    // DEFAULT DATA
    //-----------------------------------------

    await SeedData.insertDefaultData(
      db,
    );
  }

  //==========================================================
  // DATABASE UPGRADE
  //==========================================================

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
        //-----------------------------------------
    // VERSION 2
    //-----------------------------------------

    if (oldVersion < 2) {
      await db.execute(
        LiveTrackingTable.createTable,
      );
    }

    //-----------------------------------------
    // VERSION 3
    //-----------------------------------------

    if (oldVersion < 3) {
      await db.execute(
        OtpTable.createTable,
      );
    }

    //-----------------------------------------
    // VERSION 4
    //-----------------------------------------

    if (oldVersion < 4) {
      await db.execute('''
ALTER TABLE ${UserTable.tableName}
ADD COLUMN ${UserTable.mobile} TEXT
''');
    }

    //-----------------------------------------
    // VERSION 5
    //-----------------------------------------

    if (oldVersion < 5) {
      await db.execute(
        PasswordResetOtpTable.createTable,
      );
    }

    //-----------------------------------------
    // VERSION 6
    //-----------------------------------------

    if (oldVersion < 6) {
      await db.execute(
        PaymentTable.createTable,
      );
    }
  }

  //==========================================================
  // CLOSE DATABASE
  //==========================================================

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  //==========================================================
  // DELETE DATABASE
  //==========================================================

  Future<void> deleteDatabaseFile() async {
    final dbPath =
        await getDatabasesPath();

    final path = join(
      dbPath,
      AppConstants.databaseName,
    );

    await deleteDatabase(path);

    _database = null;
  }
    //==========================================================
  // CLEAR TABLE
  //==========================================================

  Future<void> clearTable(
    String tableName,
  ) async {
    final db = await database;

    await db.delete(tableName);
  }

  //==========================================================
  // CLEAR ALL TABLES
  //==========================================================

  Future<void> clearAllTables() async {
    final db = await database;

    await db.transaction((txn) async {

      await txn.delete(
        TripTable.tableName,
      );

      await txn.delete(
        LiveTrackingTable.tableName,
      );

      await txn.delete(
        OtpTable.tableName,
      );

      await txn.delete(
        PasswordResetOtpTable.tableName,
      );

      await txn.delete(
        PaymentTable.tableName,
      );

      await txn.delete(
        EmployeeTable.tableName,
      );

      await txn.delete(
        DriverTable.tableName,
      );

      await txn.delete(
        VehicleTable.tableName,
      );

      await txn.delete(
        UserTable.tableName,
      );
    });
  }

  //==========================================================
  // ROW COUNT
  //==========================================================

  Future<int> getRowCount(
    String tableName,
  ) async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM $tableName',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  //==========================================================
  // TABLE EXISTS
  //==========================================================

  Future<bool> tableExists(
    String tableName,
  ) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
SELECT name
FROM sqlite_master
WHERE type='table'
AND name=?
''',
      [tableName],
    );

    return result.isNotEmpty;
  }

  //==========================================================
  // RAW EXECUTE
  //==========================================================

  Future<void> executeRawQuery(
    String sql,
  ) async {
    final db = await database;

    await db.execute(sql);
  }

  //==========================================================
  // RAW QUERY
  //==========================================================

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await database;

    return await db.rawQuery(
      sql,
      arguments,
    );
  }

  //==========================================================
  // RAW INSERT
  //==========================================================

  Future<int> rawInsert(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await database;

    return await db.rawInsert(
      sql,
      arguments,
    );
  }

  //==========================================================
  // RAW UPDATE
  //==========================================================

  Future<int> rawUpdate(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await database;

    return await db.rawUpdate(
      sql,
      arguments,
    );
  }

  //==========================================================
  // RAW DELETE
  //==========================================================

  Future<int> rawDelete(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await database;

    return await db.rawDelete(
      sql,
      arguments,
    );
  }

  //==========================================================
  // TRANSACTION
  //==========================================================

  Future<T> transaction<T>(
    Future<T> Function(Transaction txn) action,
  ) async {
    final db = await database;

    return await db.transaction(
      action,
    );
  }
}