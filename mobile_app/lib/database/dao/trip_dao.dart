import 'package:sqflite/sqflite.dart';

import '../../models/trip_model.dart';
import '../database_helper.dart';
import '../tables/trip_table.dart';

class TripDao {
  TripDao._();

  static final TripDao instance = TripDao._();

  Future<Database> get _db async =>
      DatabaseHelper.instance.database;

  //==========================================================
  // INSERT
  //==========================================================

  Future<int> insert(
    TripModel trip,
  ) async {
    final db = await _db;

    return await db.insert(
      TripTable.tableName,
      trip.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  //==========================================================
  // UPDATE
  //==========================================================

  Future<int> update(
    TripModel trip,
  ) async {
    final db = await _db;

    return await db.update(
      TripTable.tableName,
      trip.toMap(),
      where: '${TripTable.id}=?',
      whereArgs: [trip.id],
    );
  }

  //==========================================================
  // DELETE
  //==========================================================

  Future<int> delete(
    int id,
  ) async {
    final db = await _db;

    return await db.delete(
      TripTable.tableName,
      where: '${TripTable.id}=?',
      whereArgs: [id],
    );
  }

  //==========================================================
  // GET BY ID
  //==========================================================

  Future<TripModel?> getById(
    int id,
  ) async {
    final db = await _db;

    final result = await db.query(
      TripTable.tableName,
      where: '${TripTable.id}=?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return TripModel.fromMap(
      result.first,
    );
  }

  //==========================================================
  // GET BY TRIP ID
  //==========================================================

  Future<TripModel?> getByTripId(
    String tripId,
  ) async {
    final db = await _db;

    final result = await db.query(
      TripTable.tableName,
      where: '${TripTable.tripId}=?',
      whereArgs: [tripId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return TripModel.fromMap(
      result.first,
    );
  }
    //==========================================================
  // GET ALL
  //==========================================================

  Future<List<TripModel>> getAll() async {
    final db = await _db;

    final result = await db.query(
      TripTable.tableName,
      orderBy:
          '${TripTable.tripDate} DESC, ${TripTable.tripTime} DESC',
    );

    return result
        .map((e) => TripModel.fromMap(e))
        .toList();
  }

  //==========================================================
  // GET EMPLOYEE TRIPS
  //==========================================================

  Future<List<TripModel>> getEmployeeTrips(
    int employeeId,
  ) async {
    final db = await _db;

    final result = await db.query(
      TripTable.tableName,
      where:
          '${TripTable.employeeId}=?',
      whereArgs: [employeeId],
      orderBy:
          '${TripTable.tripDate} DESC, ${TripTable.tripTime} DESC',
    );

    return result
        .map((e) => TripModel.fromMap(e))
        .toList();
  }

  //==========================================================
  // GET DRIVER TRIPS
  //==========================================================

  Future<List<TripModel>> getDriverTrips(
    int driverId,
  ) async {
    final db = await _db;

    final result = await db.query(
      TripTable.tableName,
      where:
          '${TripTable.driverId}=?',
      whereArgs: [driverId],
      orderBy:
          '${TripTable.tripDate} DESC, ${TripTable.tripTime} DESC',
    );

    return result
        .map((e) => TripModel.fromMap(e))
        .toList();
  }

  //==========================================================
  // GET BY STATUS
  //==========================================================

  Future<List<TripModel>> getByStatus(
    String status,
  ) async {
    final db = await _db;

    final result = await db.query(
      TripTable.tableName,
      where:
          '${TripTable.status}=?',
      whereArgs: [status],
      orderBy:
          '${TripTable.tripDate} DESC, ${TripTable.tripTime} DESC',
    );

    return result
        .map((e) => TripModel.fromMap(e))
        .toList();
  }
    //==========================================================
  // SEARCH TRIPS
  //==========================================================

  Future<List<TripModel>> search(
    String keyword,
  ) async {
    final db = await _db;

    final result = await db.query(
      TripTable.tableName,
      where: '''
${TripTable.tripId} LIKE ?
OR ${TripTable.pickupLocation} LIKE ?
OR ${TripTable.destination} LIKE ?
OR ${TripTable.status} LIKE ?
''',
      whereArgs: [
        '%$keyword%',
        '%$keyword%',
        '%$keyword%',
        '%$keyword%',
      ],
      orderBy:
          '${TripTable.tripDate} DESC, ${TripTable.tripTime} DESC',
    );

    return result
        .map((e) => TripModel.fromMap(e))
        .toList();
  }

  //==========================================================
  // UPDATE STATUS
  //==========================================================

  Future<int> updateStatus({
    required int id,
    required String status,
  }) async {
    final db = await _db;

    return await db.update(
      TripTable.tableName,
      {
        TripTable.status: status,
      },
      where: '${TripTable.id}=?',
      whereArgs: [id],
    );
  }

  //==========================================================
  // START TRIP
  //==========================================================

  Future<int> startTrip(
    int id,
  ) async {
    return await updateStatus(
      id: id,
      status: "Started",
    );
  }

  //==========================================================
  // COMPLETE TRIP
  //==========================================================

  Future<int> completeTrip(
    int id,
  ) async {
    return await updateStatus(
      id: id,
      status: "Completed",
    );
  }

  //==========================================================
  // CANCEL TRIP
  //==========================================================

  Future<int> cancelTrip(
    int id,
  ) async {
    return await updateStatus(
      id: id,
      status: "Cancelled",
    );
  }
    //==========================================================
  // COUNT
  //==========================================================

  Future<int> count() async {
    final db = await _db;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${TripTable.tableName}',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  //==========================================================
  // DELETE ALL
  //==========================================================

  Future<void> deleteAll() async {
    final db = await _db;

    await db.delete(
      TripTable.tableName,
    );
  }
}
