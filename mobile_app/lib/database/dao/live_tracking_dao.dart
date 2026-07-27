import 'package:sqflite/sqflite.dart';

import '../../models/driver_live_location_model.dart';
import '../database_helper.dart';
import '../tables/live_tracking_table.dart';

class LiveTrackingDao {
  LiveTrackingDao._();

  static final LiveTrackingDao instance =
      LiveTrackingDao._();

  Future<Database> get _db async =>
      DatabaseHelper.instance.database;

  //==========================================================
  // INSERT LOCATION
  //==========================================================

  Future<int> insert(
    DriverLiveLocationModel location,
  ) async {
    final db = await _db;

    return await db.insert(
      LiveTrackingTable.tableName,
      location.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  //==========================================================
  // LATEST DRIVER LOCATION
  //==========================================================

  Future<DriverLiveLocationModel?>
      getLatestLocation(
    String driverId,
  ) async {
    final db = await _db;

    final result = await db.query(
      LiveTrackingTable.tableName,
      where:
          '${LiveTrackingTable.driverId}=?',
      whereArgs: [driverId],
      orderBy:
          '${LiveTrackingTable.createdAt} DESC',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return DriverLiveLocationModel.fromMap(
      result.first,
    );
  }

  //==========================================================
  // TRIP ROUTE
  //==========================================================

  Future<List<DriverLiveLocationModel>>
      getTripRoute(
    int tripId,
  ) async {
    final db = await _db;

    final result = await db.query(
      LiveTrackingTable.tableName,
      where:
          '${LiveTrackingTable.tripId}=?',
      whereArgs: [tripId],
      orderBy:
          '${LiveTrackingTable.createdAt} ASC',
    );

    return result
        .map(
          (e) =>
              DriverLiveLocationModel.fromMap(
            e,
          ),
        )
        .toList();
  }

  //==========================================================
  // DRIVER HISTORY
  //==========================================================

  Future<List<DriverLiveLocationModel>>
      getDriverHistory(
    String driverId,
  ) async {
    final db = await _db;

    final result = await db.query(
      LiveTrackingTable.tableName,
      where:
          '${LiveTrackingTable.driverId}=?',
      whereArgs: [driverId],
      orderBy:
          '${LiveTrackingTable.createdAt} DESC',
    );

    return result
        .map(
          (e) =>
              DriverLiveLocationModel.fromMap(
            e,
          ),
        )
        .toList();
  }

  //==========================================================
  // DELETE TRIP HISTORY
  //==========================================================

  Future<int> deleteTripHistory(
    int tripId,
  ) async {
    final db = await _db;

    return await db.delete(
      LiveTrackingTable.tableName,
      where:
          '${LiveTrackingTable.tripId}=?',
      whereArgs: [tripId],
    );
  }

  //==========================================================
  // DELETE DRIVER HISTORY
  //==========================================================

  Future<int> deleteDriverHistory(
    String driverId,
  ) async {
    final db = await _db;

    return await db.delete(
      LiveTrackingTable.tableName,
      where:
          '${LiveTrackingTable.driverId}=?',
      whereArgs: [driverId],
    );
  }

  //==========================================================
  // DELETE ALL
  //==========================================================

  Future<void> deleteAll() async {
    final db = await _db;

    await db.delete(
      LiveTrackingTable.tableName,
    );
  }

  //==========================================================
  // COUNT
  //==========================================================

  Future<int> count() async {
    final db = await _db;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${LiveTrackingTable.tableName}',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
}