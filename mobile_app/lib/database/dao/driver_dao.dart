import 'package:sqflite/sqflite.dart';

import '../../models/driver_model.dart';
import '../database_helper.dart';
import '../tables/driver_table.dart';

class DriverDao {
  DriverDao._();

  static final DriverDao instance =
      DriverDao._();

  Future<Database> get _db async =>
      DatabaseHelper.instance.database;

  //==========================================================
  // INSERT
  //==========================================================

  Future<int> insert(
    DriverModel driver,
  ) async {
    final db = await _db;

    return await db.insert(
      DriverTable.tableName,
      driver.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  //==========================================================
  // REGISTER DRIVER
  //==========================================================

  Future<int> registerDriver(
    DriverModel driver,
  ) async {
    final driverId =
        await generateDriverId();

    final newDriver =
        driver.copyWith(
      driverId: driverId,
    );

    return await insert(
      newDriver,
    );
  }

  //==========================================================
  // UPDATE
  //==========================================================

  Future<int> update(
    DriverModel driver,
  ) async {
    final db = await _db;

    return await db.update(
      DriverTable.tableName,
      driver.toMap(),
      where:
          '${DriverTable.id} = ?',
      whereArgs: [
        driver.id,
      ],
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
      DriverTable.tableName,
      where:
          '${DriverTable.id} = ?',
      whereArgs: [id],
    );
  }

  //==========================================================
  // GET BY ID
  //==========================================================

  Future<DriverModel?> getById(
    int id,
  ) async {
    final db = await _db;

    final result = await db.query(
      DriverTable.tableName,
      where:
          '${DriverTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return DriverModel.fromMap(
      result.first,
    );
  }

  //==========================================================
  // GET BY DRIVER ID
  //==========================================================

  Future<DriverModel?>
      getByDriverId(
    String driverId,
  ) async {
    final db = await _db;

    final result = await db.query(
      DriverTable.tableName,
      where:
          '${DriverTable.driverId} = ?',
      whereArgs: [
        driverId,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return DriverModel.fromMap(
      result.first,
    );
  }
    //==========================================================
  // GENERATE DRIVER ID
  //==========================================================

  Future<String> generateDriverId() async {
    final db = await _db;

    final result = await db.rawQuery('''
SELECT ${DriverTable.driverId}
FROM ${DriverTable.tableName}
ORDER BY ${DriverTable.id} DESC
LIMIT 1
''');

    if (result.isEmpty) {
      return "DRV001";
    }

    final lastDriverId =
        result.first[DriverTable.driverId]
            .toString();

    final number = int.parse(
      lastDriverId.replaceAll(
        "DRV",
        "",
      ),
    );

    final next = number + 1;

    return "DRV${next.toString().padLeft(3, '0')}";
  }

  //==========================================================
  // DRIVER ID EXISTS
  //==========================================================

  Future<bool> driverIdExists(
    String driverId,
  ) async {
    final driver =
        await getByDriverId(driverId);

    return driver != null;
  }

  //==========================================================
  // EMAIL EXISTS
  //==========================================================

  Future<bool> emailExists(
    String email,
  ) async {
    final db = await _db;

    final result = await db.query(
      DriverTable.tableName,
      where:
          '${DriverTable.email} = ?',
      whereArgs: [email],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  //==========================================================
  // MOBILE EXISTS
  //==========================================================

  Future<bool> mobileExists(
    String mobile,
  ) async {
    final db = await _db;

    final result = await db.query(
      DriverTable.tableName,
      where:
          '${DriverTable.mobile} = ?',
      whereArgs: [mobile],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  //==========================================================
  // GET ALL
  //==========================================================

  Future<List<DriverModel>>
      getAll() async {
    final db = await _db;

    final result = await db.query(
      DriverTable.tableName,
      orderBy:
          '${DriverTable.name} ASC',
    );

    return result
        .map(
          (e) =>
              DriverModel.fromMap(e),
        )
        .toList();
  }
    //==========================================================
  // AVAILABLE DRIVERS
  //==========================================================

  Future<List<DriverModel>>
      getAvailableDrivers() async {
    final db = await _db;

    final result = await db.query(
      DriverTable.tableName,
      where:
          '${DriverTable.isAvailable}=1 AND ${DriverTable.isActive}=1',
      orderBy:
          '${DriverTable.name} ASC',
    );

    return result
        .map(
          (e) =>
              DriverModel.fromMap(e),
        )
        .toList();
  }

  //==========================================================
  // SEARCH DRIVER
  //==========================================================

  Future<List<DriverModel>> search(
    String keyword,
  ) async {
    final db = await _db;

    final result = await db.query(
      DriverTable.tableName,
      where: '''
${DriverTable.name} LIKE ?
OR ${DriverTable.driverId} LIKE ?
OR ${DriverTable.mobile} LIKE ?
OR ${DriverTable.email} LIKE ?
OR ${DriverTable.licenseNumber} LIKE ?
''',
      whereArgs: List.filled(
        5,
        '%$keyword%',
      ),
      orderBy:
          '${DriverTable.name} ASC',
    );

    return result
        .map(
          (e) =>
              DriverModel.fromMap(e),
        )
        .toList();
  }

  //==========================================================
  // UPDATE AVAILABILITY
  //==========================================================

  Future<int> updateAvailability({
    required int id,
    required bool available,
  }) async {
    final db = await _db;

    return await db.update(
      DriverTable.tableName,
      {
        DriverTable.isAvailable:
            available ? 1 : 0,
      },
      where:
          '${DriverTable.id} = ?',
      whereArgs: [id],
    );
  }

  //==========================================================
  // COUNT
  //==========================================================

  Future<int> count() async {
    final db = await _db;

    final result =
        await db.rawQuery(
      'SELECT COUNT(*) FROM ${DriverTable.tableName}',
    );

    return Sqflite.firstIntValue(
          result,
        ) ??
        0;
  }

  //==========================================================
  // AVAILABLE COUNT
  //==========================================================

  Future<int> availableCount() async {
    final db = await _db;

    final result =
        await db.rawQuery('''
SELECT COUNT(*)
FROM ${DriverTable.tableName}
WHERE ${DriverTable.isAvailable}=1
AND ${DriverTable.isActive}=1
''');

    return Sqflite.firstIntValue(
          result,
        ) ??
        0;
  }
    //==========================================================
  // GET ACTIVE DRIVERS
  //==========================================================

  Future<List<DriverModel>>
      getActiveDrivers() async {
    final db = await _db;

    final result = await db.query(
      DriverTable.tableName,
      where: '${DriverTable.isActive} = ?',
      whereArgs: [1],
      orderBy: '${DriverTable.name} ASC',
    );

    return result
        .map(
          (e) => DriverModel.fromMap(e),
        )
        .toList();
  }

  //==========================================================
  // GET INACTIVE DRIVERS
  //==========================================================

  Future<List<DriverModel>>
      getInactiveDrivers() async {
    final db = await _db;

    final result = await db.query(
      DriverTable.tableName,
      where: '${DriverTable.isActive} = ?',
      whereArgs: [0],
      orderBy: '${DriverTable.name} ASC',
    );

    return result
        .map(
          (e) => DriverModel.fromMap(e),
        )
        .toList();
  }

  //==========================================================
  // LICENSE EXISTS
  //==========================================================

  Future<bool> licenseExists(
    String licenseNumber,
  ) async {
    final db = await _db;

    final result = await db.query(
      DriverTable.tableName,
      where:
          '${DriverTable.licenseNumber} = ?',
      whereArgs: [licenseNumber],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  //==========================================================
  // CHANGE DRIVER STATUS
  //==========================================================

  Future<int> changeDriverStatus({
    required int id,
    required bool isActive,
  }) async {
    final db = await _db;

    return await db.update(
      DriverTable.tableName,
      {
        DriverTable.isActive:
            isActive ? 1 : 0,
      },
      where: '${DriverTable.id} = ?',
      whereArgs: [id],
    );
  }

  //==========================================================
  // DELETE BY DRIVER ID
  //==========================================================

  Future<int> deleteByDriverId(
    String driverId,
  ) async {
    final db = await _db;

    return await db.delete(
      DriverTable.tableName,
      where:
          '${DriverTable.driverId} = ?',
      whereArgs: [driverId],
    );
  }

  //==========================================================
  // DELETE ALL
  //==========================================================

  Future<void> deleteAll() async {
    final db = await _db;

    await db.delete(
      DriverTable.tableName,
    );
  }
}