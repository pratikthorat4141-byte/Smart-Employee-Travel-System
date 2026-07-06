import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../driver/models/driver_model.dart';

class DriverProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Driver> _drivers = [];

  List<Driver> get drivers => _drivers;

  DriverProvider() {
    loadDrivers();
  }

  Future<void> loadDrivers() async {
    final data = await _db.getDrivers();

    _drivers = data.map((e) => Driver.fromMap(e)).toList();

    notifyListeners();
  }

  Future<void> addDriver(Driver driver) async {
    await _db.insertDriver(driver.toMap());
    await loadDrivers();
  }

  Future<void> updateDriver(Driver driver) async {
    await _db.updateDriver(driver.toMap());
    await loadDrivers();
  }

  Future<void> deleteDriver(int id) async {
    await _db.deleteDriver(id);
    await loadDrivers();
  }

  Future<void> searchDriver(String keyword) async {
    final data = await _db.getDrivers();

    _drivers = data.map((e) => Driver.fromMap(e)).toList();

    if (keyword.trim().isNotEmpty) {
      _drivers = _drivers.where((driver) {
        return driver.name
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            driver.phone.contains(keyword) ||
            driver.licenseNo
                .toLowerCase()
                .contains(keyword.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }
}