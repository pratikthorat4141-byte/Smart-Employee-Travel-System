import 'package:sqflite/sqflite.dart';

import '../core/constants/app_constants.dart';

import '../models/user_model.dart';
import '../models/employee_model.dart';
import '../models/driver_model.dart';
import '../models/vehicle_model.dart';

import 'tables/user_table.dart';
import 'tables/employee_table.dart';
import 'tables/driver_table.dart';
import 'tables/vehicle_table.dart';

class SeedData {
  SeedData._();

  static Future<void> insertDefaultData(
    Database db,
  ) async {
    await _insertAdmin(db);

    await _insertEmployees(db);

    await _insertDrivers(db);

    await _insertVehicles(db);

    await _insertPayments(db);
  }

  //==========================================================
  // ADMIN
  //==========================================================

  static Future<void> _insertAdmin(
    Database db,
  ) async {
    final result = await db.query(
      UserTable.tableName,
      where: '${UserTable.email}=?',
      whereArgs: [
        AppConstants.defaultAdminEmail,
      ],
    );

    if (result.isNotEmpty) return;

    final admin = UserModel(
      name: AppConstants.defaultAdminName,
      email: AppConstants.defaultAdminEmail,
      mobile: "9999999999",
      password:
          AppConstants.defaultAdminPassword,
      role: AppConstants.adminRole,
    );

    await db.insert(
      UserTable.tableName,
      admin.toMap(),
    );
  }
    //==========================================================
  // EMPLOYEES
  //==========================================================

  static Future<void> _insertEmployees(
    Database db,
  ) async {
    final count = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM ${EmployeeTable.tableName}',
          ),
        ) ??
        0;

    if (count > 0) return;

    final employees = [
      EmployeeModel(
        employeeId: 'EMP001',
        name: 'Rahul Sharma',
        department: 'IT',
        designation: 'Software Engineer',
        mobile: '9876543210',
        email: 'rahul@company.com',
        address: 'Pune',
        gender: 'Male',
        joiningDate: DateTime.now().toIso8601String(),
      ),

      EmployeeModel(
        employeeId: 'EMP002',
        name: 'Priya Patil',
        department: 'HR',
        designation: 'HR Executive',
        mobile: '9876543211',
        email: 'priya@company.com',
        address: 'Mumbai',
        gender: 'Female',
        joiningDate: DateTime.now().toIso8601String(),
      ),
    ];

    for (final employee in employees) {
      await db.insert(
        EmployeeTable.tableName,
        employee.toMap(),
      );
    }
  }
    //==========================================================
  // DRIVERS
  //==========================================================

  static Future<void> _insertDrivers(
    Database db,
  ) async {
    final count = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM ${DriverTable.tableName}',
          ),
        ) ??
        0;

    if (count > 0) return;

    final drivers = [
      DriverModel(
        driverId: 'DRV001',
        name: 'Suresh Patil',
        mobile: '9999999991',
        email: 'driver1@company.com',
        licenseNumber: 'MH1420200001',
        address: 'Pune',
        gender: 'Male',
        joiningDate: DateTime.now().toIso8601String(),
      ),

      DriverModel(
        driverId: 'DRV002',
        name: 'Mahesh Jadhav',
        mobile: '9999999992',
        email: 'driver2@company.com',
        licenseNumber: 'MH1420200002',
        address: 'Pune',
        gender: 'Male',
        joiningDate: DateTime.now().toIso8601String(),
      ),
    ];

    for (final driver in drivers) {
      await db.insert(
        DriverTable.tableName,
        driver.toMap(),
      );
    }
  }
    //==========================================================
  // VEHICLES
  //==========================================================

  static Future<void> _insertVehicles(
    Database db,
  ) async {
    final count = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM ${VehicleTable.tableName}',
          ),
        ) ??
        0;

    if (count > 0) return;

    final vehicles = [
      VehicleModel(
        vehicleNumber: 'MH12AB1234',
        vehicleName: 'Swift Dzire',
        vehicleType: 'Sedan',
        seatingCapacity: 4,
        fuelType: 'Petrol',
        registrationDate:
            DateTime.now().toIso8601String(),
        insuranceExpiry:
            DateTime.now()
                .add(
                  const Duration(days: 365),
                )
                .toIso8601String(),
      ),

      VehicleModel(
        vehicleNumber: 'MH12CD5678',
        vehicleName: 'Ertiga',
        vehicleType: 'SUV',
        seatingCapacity: 6,
        fuelType: 'Diesel',
        registrationDate:
            DateTime.now().toIso8601String(),
        insuranceExpiry:
            DateTime.now()
                .add(
                  const Duration(days: 365),
                )
                .toIso8601String(),
      ),
    ];

    for (final vehicle in vehicles) {
      await db.insert(
        VehicleTable.tableName,
        vehicle.toMap(),
      );
    }
  }
    //==========================================================
  // PAYMENTS
  //==========================================================

  static Future<void> _insertPayments(
    Database db,
  ) async {
    final count = Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM payments',
          ),
        ) ??
        0;

    if (count > 0) return;

    final now = DateTime.now().toIso8601String();

    final payments = [
      {
        "paymentId": "PAY001",
        "tripId": "TRIP001",

        "employeeId": 1,
        "employeeName": "Rahul Sharma",

        "driverId": 1,
        "vehicleId": 1,

        "amount": 500.0,
        "gst": 90.0,
        "totalAmount": 590.0,

        "paymentMethod": "UPI",
        "paymentStatus": "Paid",

        "razorpayPaymentId": "",
        "razorpayOrderId": "",
        "razorpaySignature": "",

        "transactionId": "TXN100001",
        "invoiceNumber": "INV100001",

        "paymentDate": now,
        "createdAt": now,
        "updatedAt": now,

        "remarks": "Trip Payment",
      },

      {
        "paymentId": "PAY002",
        "tripId": "TRIP002",

        "employeeId": 2,
        "employeeName": "Priya Patil",

        "driverId": 2,
        "vehicleId": 2,

        "amount": 650.0,
        "gst": 117.0,
        "totalAmount": 767.0,

        "paymentMethod": "Card",
        "paymentStatus": "Pending",

        "razorpayPaymentId": "",
        "razorpayOrderId": "",
        "razorpaySignature": "",

        "transactionId": "",
        "invoiceNumber": "INV100002",

        "paymentDate": now,
        "createdAt": now,
        "updatedAt": now,

        "remarks": "Waiting for Payment",
      },

      {
        "paymentId": "PAY003",
        "tripId": "TRIP003",

        "employeeId": 1,
        "employeeName": "Rahul Sharma",

        "driverId": 1,
        "vehicleId": 1,

        "amount": 720.0,
        "gst": 129.6,
        "totalAmount": 849.6,

        "paymentMethod": "Wallet",
        "paymentStatus": "Failed",

        "razorpayPaymentId": "",
        "razorpayOrderId": "",
        "razorpaySignature": "",

        "transactionId": "",
        "invoiceNumber": "INV100003",

        "paymentDate": now,
        "createdAt": now,
        "updatedAt": now,

        "remarks": "Payment Failed",
      },

      {
        "paymentId": "PAY004",
        "tripId": "TRIP004",

        "employeeId": 2,
        "employeeName": "Priya Patil",

        "driverId": 2,
        "vehicleId": 2,

        "amount": 900.0,
        "gst": 162.0,
        "totalAmount": 1062.0,

        "paymentMethod": "Net Banking",
        "paymentStatus": "Paid",

        "razorpayPaymentId": "",
        "razorpayOrderId": "",
        "razorpaySignature": "",

        "transactionId": "TXN100004",
        "invoiceNumber": "INV100004",

        "paymentDate": now,
        "createdAt": now,
        "updatedAt": now,

        "remarks": "Trip Completed",
      },
    ];

    for (final payment in payments) {
      await db.insert(
        "payments",
        payment,
      );
    }
  }
}