import 'package:sqflite/sqflite.dart';

import '../../models/employee_model.dart';
import '../database_helper.dart';
import '../tables/employee_table.dart';

class EmployeeDao {
  EmployeeDao._();

  static final EmployeeDao instance = EmployeeDao._();

  Future<Database> get _db async =>
      DatabaseHelper.instance.database;

  //==========================================================
  // INSERT EMPLOYEE
  //==========================================================

  Future<int> insert(
    EmployeeModel employee,
  ) async {
    final db = await _db;

    return db.insert(
      EmployeeTable.tableName,
      employee.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  //==========================================================
  // REGISTER EMPLOYEE
  //==========================================================

  Future<int> registerEmployee(
    EmployeeModel employee,
  ) async {
    final employeeId =
        await generateEmployeeId();

    final newEmployee =
        employee.copyWith(
      employeeId: employeeId,
    );

    return await insert(
      newEmployee,
    );
  }

  //==========================================================
  // UPDATE EMPLOYEE
  //==========================================================

  Future<int> update(
    EmployeeModel employee,
  ) async {
    final db = await _db;

    return db.update(
      EmployeeTable.tableName,
      employee.toMap(),
      where:
          '${EmployeeTable.id} = ?',
      whereArgs: [employee.id],
    );
  }

  //==========================================================
  // DELETE EMPLOYEE
  //==========================================================

  Future<int> delete(
    int id,
  ) async {
    final db = await _db;

    return db.delete(
      EmployeeTable.tableName,
      where:
          '${EmployeeTable.id} = ?',
      whereArgs: [id],
    );
  }

  //==========================================================
  // GET BY ID
  //==========================================================

  Future<EmployeeModel?> getById(
    int id,
  ) async {
    final db = await _db;

    final result = await db.query(
      EmployeeTable.tableName,
      where:
          '${EmployeeTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return EmployeeModel.fromMap(
      result.first,
    );
  }

  //==========================================================
  // GET BY EMPLOYEE ID
  //==========================================================

  Future<EmployeeModel?>
      getByEmployeeId(
    String employeeId,
  ) async {
    final db = await _db;

    final result = await db.query(
      EmployeeTable.tableName,
      where:
          '${EmployeeTable.employeeId} = ?',
      whereArgs: [employeeId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return EmployeeModel.fromMap(
      result.first,
    );
  }

  //==========================================================
  // GENERATE NEXT EMPLOYEE ID
  //==========================================================

  Future<String>
      generateEmployeeId() async {
    final db = await _db;

    final result =
        await db.rawQuery('''
SELECT ${EmployeeTable.employeeId}
FROM ${EmployeeTable.tableName}
ORDER BY ${EmployeeTable.id} DESC
LIMIT 1
''');

    if (result.isEmpty) {
      return "EMP001";
    }

    final lastId =
        result.first[
                EmployeeTable
                    .employeeId]
            .toString();

    final number = int.parse(
      lastId.replaceAll(
        "EMP",
        "",
      ),
    );

    final next = number + 1;

    return "EMP${next.toString().padLeft(3, '0')}";
  }

  //==========================================================
  // EMPLOYEE ID EXISTS
  //==========================================================

  Future<bool> employeeIdExists(
    String employeeId,
  ) async {
    final employee =
        await getByEmployeeId(
      employeeId,
    );

    return employee != null;
  }

  //==========================================================
  // EMAIL EXISTS
  //==========================================================

  Future<bool> emailExists(
    String email,
  ) async {
    final db = await _db;

    final result = await db.query(
      EmployeeTable.tableName,
      where:
          '${EmployeeTable.email}=?',
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
      EmployeeTable.tableName,
      where:
          '${EmployeeTable.mobile}=?',
      whereArgs: [mobile],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  //==========================================================
  // GET ALL EMPLOYEES
  //==========================================================

  Future<List<EmployeeModel>>
      getAll() async {
    final db = await _db;

    final result = await db.query(
      EmployeeTable.tableName,
      orderBy:
          '${EmployeeTable.name} ASC',
    );

    return result
        .map(
          EmployeeModel.fromMap,
        )
        .toList();
  }

  //==========================================================
  // SEARCH EMPLOYEE
  //==========================================================

  Future<List<EmployeeModel>>
      search(
    String keyword,
  ) async {
    final db = await _db;

    final result = await db.query(
      EmployeeTable.tableName,
      where: '''
${EmployeeTable.name} LIKE ?
OR ${EmployeeTable.employeeId} LIKE ?
OR ${EmployeeTable.department} LIKE ?
OR ${EmployeeTable.designation} LIKE ?
OR ${EmployeeTable.mobile} LIKE ?
OR ${EmployeeTable.email} LIKE ?
''',
      whereArgs:
          List.filled(
        6,
        '%$keyword%',
      ),
      orderBy:
          '${EmployeeTable.name} ASC',
    );

    return result
        .map(
          EmployeeModel.fromMap,
        )
        .toList();
  }

  //==========================================================
  // ACTIVE EMPLOYEES
  //==========================================================

  Future<List<EmployeeModel>>
      getActiveEmployees() async {
    final db = await _db;

    final result = await db.query(
      EmployeeTable.tableName,
      where:
          '${EmployeeTable.isActive}=1',
      orderBy:
          '${EmployeeTable.name} ASC',
    );

    return result
        .map(
          EmployeeModel.fromMap,
        )
        .toList();
  }

  //==========================================================
  // COUNT
  //==========================================================

  Future<int> count() async {
    final db = await _db;

    final result =
        await db.rawQuery(
      'SELECT COUNT(*) FROM ${EmployeeTable.tableName}',
    );

    return Sqflite.firstIntValue(
          result,
        ) ??
        0;
  }

  //==========================================================
  // DELETE ALL
  //==========================================================

  Future<void> deleteAll() async {
    final db = await _db;

    await db.delete(
      EmployeeTable.tableName,
    );
  }
}