import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "smart_employee_travel.db");

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // ================= USERS =================

    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    // Default Admin
    await db.insert("users", {
      "name": "Pratik Thorat",
      "email": "admin@travel.com",
      "password": "admin123",
      "role": "Admin",
    });

    // ================= EMPLOYEES =================

    await db.execute('''
      CREATE TABLE employees(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        department TEXT NOT NULL
      )
    ''');

    // ================= DRIVERS =================

    await db.execute('''
      CREATE TABLE drivers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        licenseNo TEXT NOT NULL
      )
    ''');

    // ================= VEHICLES =================

    await db.execute('''
      CREATE TABLE vehicles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicleNo TEXT NOT NULL,
        type TEXT NOT NULL,
        capacity INTEGER NOT NULL
      )
    ''');

    // ================= TRIPS =================

    await db.execute('''
      CREATE TABLE trips(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employee TEXT NOT NULL,
        driver TEXT NOT NULL,
        vehicle TEXT NOT NULL,
        source TEXT NOT NULL,
        destination TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  // ======================================================
  // AUTH
  // ======================================================

  Future<int> registerUser(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert("users", data);
  }

  Future<Map<String, dynamic>?> loginUser(
    String email,
    String password,
  ) async {
    final db = await database;

    final result = await db.query(
      "users",
      where: "email=? AND password=?",
      whereArgs: [email, password],
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // ======================================================
  // EMPLOYEE
  // ======================================================

  Future<int> insertEmployee(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert("employees", data);
  }

  Future<List<Map<String, dynamic>>> getEmployees() async {
    final db = await database;
    return await db.query("employees");
  }

  Future<int> updateEmployee(Map<String, dynamic> data) async {
    final db = await database;

    return await db.update(
      "employees",
      data,
      where: "id=?",
      whereArgs: [data["id"]],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;

    return await db.delete(
      "employees",
      where: "id=?",
      whereArgs: [id],
    );
  }

  // ======================================================
  // DRIVER
  // ======================================================

  Future<int> insertDriver(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert("drivers", data);
  }

  Future<List<Map<String, dynamic>>> getDrivers() async {
    final db = await database;
    return await db.query("drivers");
  }

  Future<int> updateDriver(Map<String, dynamic> data) async {
    final db = await database;

    return await db.update(
      "drivers",
      data,
      where: "id=?",
      whereArgs: [data["id"]],
    );
  }

  Future<int> deleteDriver(int id) async {
    final db = await database;

    return await db.delete(
      "drivers",
      where: "id=?",
      whereArgs: [id],
    );
  }

  // ======================================================
  // VEHICLE
  // ======================================================

  Future<int> insertVehicle(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert("vehicles", data);
  }

  Future<List<Map<String, dynamic>>> getVehicles() async {
    final db = await database;
    return await db.query("vehicles");
  }

  Future<int> updateVehicle(Map<String, dynamic> data) async {
    final db = await database;

    return await db.update(
      "vehicles",
      data,
      where: "id=?",
      whereArgs: [data["id"]],
    );
  }

  Future<int> deleteVehicle(int id) async {
    final db = await database;

    return await db.delete(
      "vehicles",
      where: "id=?",
      whereArgs: [id],
    );
  }

  // ======================================================
  // TRIP
  // ======================================================

  Future<int> insertTrip(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert("trips", data);
  }

  Future<List<Map<String, dynamic>>> getTrips() async {
    final db = await database;
    return await db.query("trips");
  }

  Future<int> updateTrip(Map<String, dynamic> data) async {
    final db = await database;

    return await db.update(
      "trips",
      data,
      where: "id=?",
      whereArgs: [data["id"]],
    );
  }

  Future<int> deleteTrip(int id) async {
    final db = await database;

    return await db.delete(
      "trips",
      where: "id=?",
      whereArgs: [id],
    );
  }
}