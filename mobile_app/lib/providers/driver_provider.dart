import 'package:flutter/material.dart';

import '../database/dao/driver_dao.dart';
import '../models/driver_model.dart';

class DriverProvider extends ChangeNotifier {
  final DriverDao _driverDao = DriverDao.instance;

  List<DriverModel> _drivers = [];

  bool _isLoading = false;

  String? _errorMessage;

  List<DriverModel> get drivers => List.unmodifiable(_drivers);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get totalDrivers => _drivers.length;

  List<DriverModel> get availableDrivers =>
      _drivers.where((driver) => driver.isAvailable).toList();

  //==========================================================================
  // PRIVATE
  //==========================================================================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  //==========================================================================
  // LOAD
  //==========================================================================

  Future<void> loadDrivers() async {
    try {
      _setLoading(true);

      _drivers = await _driverDao.getAll();

      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // INSERT
  //==========================================================================

  Future<bool> addDriver(DriverModel driver) async {
    try {
      _setLoading(true);

      final existing =
          await _driverDao.getByDriverId(driver.driverId);

      if (existing != null) {
        _setError("Driver ID already exists");
        return false;
      }

      await _driverDao.insert(driver);

      await loadDrivers();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // UPDATE
  //==========================================================================

  Future<bool> updateDriver(DriverModel driver) async {
    try {
      _setLoading(true);

      await _driverDao.update(driver);

      await loadDrivers();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // DELETE
  //==========================================================================

  Future<void> deleteDriver(int id) async {
    try {
      _setLoading(true);

      await _driverDao.delete(id);

      await loadDrivers();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // SEARCH
  //==========================================================================

  Future<void> searchDrivers(String keyword) async {
    try {
      _setLoading(true);

      if (keyword.trim().isEmpty) {
        await loadDrivers();
        return;
      }

      _drivers = await _driverDao.search(keyword);

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // UPDATE AVAILABILITY
  //==========================================================================

  Future<void> updateAvailability(
    int id,
    bool available,
  ) async {
    try {
      _setLoading(true);

      await _driverDao.updateAvailability(
  id: id,
  available: available,
);

      await loadDrivers();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // REFRESH
  //==========================================================================

  Future<void> refresh() async {
    await loadDrivers();
  }

  //==========================================================================
  // CLEAR ERROR
  //==========================================================================

  void clearError() {
    _errorMessage = null;

    notifyListeners();
  }

//==========================================================================
// GET DRIVER
//==========================================================================

DriverModel? getDriver(int id) {
  try {
    return _drivers.firstWhere(
      (driver) => driver.id == id,
    );
  } catch (_) {
    return null;
  }
}

//==========================================================================
// GET DRIVER BY ID (Compatibility)
//==========================================================================

DriverModel? getDriverById(int id) {
  return getDriver(id);
}
}