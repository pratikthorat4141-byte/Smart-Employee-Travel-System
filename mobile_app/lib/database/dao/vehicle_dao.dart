import 'package:sqflite/sqflite.dart';

import '../../models/vehicle_model.dart';
import '../database_helper.dart';
import '../tables/vehicle_table.dart';

class VehicleDao {
  VehicleDao._();

  static final VehicleDao instance = VehicleDao._();

  Future<Database> get _db async => DatabaseHelper.instance.database;

  //==========================================================================
  // INSERT
  //==========================================================================

  Future<int> insert(VehicleModel vehicle) async {
    final db = await _db;

    return await db.insert(
      VehicleTable.tableName,
      vehicle.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //==========================================================================
  // UPDATE
  //==========================================================================

  Future<int> update(VehicleModel vehicle) async {
    final db = await _db;

    return await db.update(
      VehicleTable.tableName,
      vehicle.toMap(),
      where: '${VehicleTable.id} = ?',
      whereArgs: [vehicle.id],
    );
  }

  //==========================================================================
  // DELETE
  //==========================================================================

  Future<int> delete(int id) async {
    final db = await _db;

    return await db.delete(
      VehicleTable.tableName,
      where: '${VehicleTable.id} = ?',
      whereArgs: [id],
    );
  }

  //==========================================================================
  // GET BY ID
  //==========================================================================

  Future<VehicleModel?> getById(int id) async {
    final db = await _db;

    final result = await db.query(
      VehicleTable.tableName,
      where: '${VehicleTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return VehicleModel.fromMap(result.first);
  }

  //==========================================================================
  // GET BY VEHICLE NUMBER
  //==========================================================================

  Future<VehicleModel?> getByVehicleNumber(String vehicleNumber) async {
    final db = await _db;

    final result = await db.query(
      VehicleTable.tableName,
      where: '${VehicleTable.vehicleNumber} = ?',
      whereArgs: [vehicleNumber],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return VehicleModel.fromMap(result.first);
  }

  //==========================================================================
  // GET ALL
  //==========================================================================

  Future<List<VehicleModel>> getAll() async {
    final db = await _db;

    final result = await db.query(
      VehicleTable.tableName,
      orderBy: '${VehicleTable.vehicleName} ASC',
    );

    return result.map(VehicleModel.fromMap).toList();
  }

  //==========================================================================
  // AVAILABLE VEHICLES
  //==========================================================================

  Future<List<VehicleModel>> getAvailableVehicles() async {
    final db = await _db;

    final result = await db.query(
      VehicleTable.tableName,
      where:
          '${VehicleTable.isAvailable}=1 AND ${VehicleTable.isActive}=1',
      orderBy: '${VehicleTable.vehicleName} ASC',
    );

    return result.map(VehicleModel.fromMap).toList();
  }

  //==========================================================================
  // SEARCH
  //==========================================================================

  Future<List<VehicleModel>> search(String keyword) async {
    final db = await _db;

    final result = await db.query(
      VehicleTable.tableName,
      where: '''
${VehicleTable.vehicleName} LIKE ?
OR ${VehicleTable.vehicleNumber} LIKE ?
OR ${VehicleTable.vehicleType} LIKE ?
OR ${VehicleTable.fuelType} LIKE ?
''',
      whereArgs: [
        '%$keyword%',
        '%$keyword%',
        '%$keyword%',
        '%$keyword%',
      ],
      orderBy: '${VehicleTable.vehicleName} ASC',
    );

    return result.map(VehicleModel.fromMap).toList();
  }

  //==========================================================================
  // UPDATE AVAILABILITY
  //==========================================================================

  Future<int> updateAvailability(
    int id,
    bool available,
  ) async {
    final db = await _db;

    return await db.update(
      VehicleTable.tableName,
      {
        VehicleTable.isAvailable: available ? 1 : 0,
      },
      where: '${VehicleTable.id} = ?',
      whereArgs: [id],
    );
  }

  //==========================================================================
  // COUNT
  //==========================================================================

  Future<int> count() async {
    final db = await _db;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${VehicleTable.tableName}',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  //==========================================================================
  // AVAILABLE COUNT
  //==========================================================================

  Future<int> availableCount() async {
    final db = await _db;

    final result = await db.rawQuery('''
SELECT COUNT(*)
FROM ${VehicleTable.tableName}
WHERE ${VehicleTable.isAvailable}=1
AND ${VehicleTable.isActive}=1
''');

    return Sqflite.firstIntValue(result) ?? 0;
  }

  //==========================================================================
  // DELETE ALL
  //==========================================================================

  Future<void> deleteAll() async {
    final db = await _db;

    await db.delete(VehicleTable.tableName);
  }
}