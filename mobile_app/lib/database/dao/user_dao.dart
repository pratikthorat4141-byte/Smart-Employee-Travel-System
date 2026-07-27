import 'package:sqflite/sqflite.dart';

import '../../models/user_model.dart';
import '../database_helper.dart';
import '../tables/user_table.dart';

class UserDao {
  UserDao._();

  static final UserDao instance = UserDao._();

  Future<Database> get _db async =>
      DatabaseHelper.instance.database;

  //==========================================================
  // INSERT USER
  //==========================================================

  Future<int> insert(UserModel user) async {
    final db = await _db;

    return await db.insert(
      UserTable.tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //==========================================================
  // UPDATE USER
  //==========================================================

  Future<int> update(UserModel user) async {
    final db = await _db;

    return await db.update(
      UserTable.tableName,
      user.toMap(),
      where: '${UserTable.id}=?',
      whereArgs: [user.id],
    );
  }

  //==========================================================
  // UPDATE PASSWORD
  //==========================================================

  Future<int> updatePassword({
    required String email,
    required String password,
  }) async {
    final db = await _db;

    return await db.update(
      UserTable.tableName,
      {
        UserTable.password: password,
      },
      where: '${UserTable.email}=?',
      whereArgs: [email],
    );
  }

  //==========================================================
  // DELETE USER
  //==========================================================

  Future<int> delete(int id) async {
    final db = await _db;

    return await db.delete(
      UserTable.tableName,
      where: '${UserTable.id}=?',
      whereArgs: [id],
    );
  }

  //==========================================================
  // GET USER BY ID
  //==========================================================

  Future<UserModel?> getById(int id) async {
    final db = await _db;

    final result = await db.query(
      UserTable.tableName,
      where: '${UserTable.id}=?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return UserModel.fromMap(result.first);
  }

  //==========================================================
  // GET USER BY EMAIL
  //==========================================================

  Future<UserModel?> getByEmail(
    String email,
  ) async {
    final db = await _db;

    final result = await db.query(
      UserTable.tableName,
      where: '${UserTable.email}=?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UserModel.fromMap(result.first);
  }

  //==========================================================
  // GET USER BY MOBILE
  //==========================================================

  Future<UserModel?> getByMobile(
    String mobile,
  ) async {
    final db = await _db;

    final result = await db.query(
      UserTable.tableName,
      where: '${UserTable.mobile}=?',
      whereArgs: [mobile],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return UserModel.fromMap(result.first);
  }

  //==========================================================
  // LOGIN
  //==========================================================

  Future<UserModel?> login(
    String email,
    String password,
    String role,
  ) async {
    final db = await _db;

    final result = await db.query(
      UserTable.tableName,
      where:
          '${UserTable.email}=? AND '
          '${UserTable.password}=? AND '
          '${UserTable.role}=?',
      whereArgs: [
        email,
        password,
        role,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UserModel.fromMap(result.first);
  }
    //==========================================================
  // GET ALL USERS
  //==========================================================

  Future<List<UserModel>> getAll() async {
    final db = await _db;

    final result = await db.query(
      UserTable.tableName,
      orderBy: UserTable.name,
    );

    return result
        .map((e) => UserModel.fromMap(e))
        .toList();
  }

  //==========================================================
  // SEARCH USERS
  //==========================================================

  Future<List<UserModel>> search(
    String keyword,
  ) async {
    final db = await _db;

    final result = await db.query(
      UserTable.tableName,
      where:
          '${UserTable.name} LIKE ? OR '
          '${UserTable.email} LIKE ? OR '
          '${UserTable.mobile} LIKE ?',
      whereArgs: [
        '%$keyword%',
        '%$keyword%',
        '%$keyword%',
      ],
      orderBy: UserTable.name,
    );

    return result
        .map((e) => UserModel.fromMap(e))
        .toList();
  }

  //==========================================================
  // COUNT USERS
  //==========================================================

  Future<int> count() async {
    final db = await _db;

    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${UserTable.tableName}',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  //==========================================================
  // EMAIL EXISTS
  //==========================================================

  Future<bool> emailExists(
    String email,
  ) async {
    final user = await getByEmail(email);

    return user != null;
  }

  //==========================================================
  // MOBILE EXISTS
  //==========================================================

  Future<bool> mobileExists(
    String mobile,
  ) async {
    final user = await getByMobile(mobile);

    return user != null;
  }

  //==========================================================
  // DELETE ALL USERS
  //==========================================================

  Future<void> deleteAll() async {
    final db = await _db;

    await db.delete(
      UserTable.tableName,
    );
  }
}