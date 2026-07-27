import 'package:flutter/material.dart';

import '../database/dao/vehicle_dao.dart';
import '../models/vehicle_model.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleDao _vehicleDao = VehicleDao.instance;

  List<VehicleModel> _vehicles = [];

  bool _isLoading = false;

  String? _errorMessage;

  List<VehicleModel> get vehicles => List.unmodifiable(_vehicles);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get totalVehicles => _vehicles.length;

  List<VehicleModel> get availableVehicles =>
      _vehicles.where((v) => v.isAvailable).toList();

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

  Future<void> loadVehicles() async {
    try {
      _setLoading(true);

      _vehicles = await _vehicleDao.getAll();

      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // ADD
  //==========================================================================

  Future<bool> addVehicle(VehicleModel vehicle) async {
    try {
      _setLoading(true);

      final exists = await _vehicleDao.getByVehicleNumber(
        vehicle.vehicleNumber,
      );

      if (exists != null) {
        _setError("Vehicle number already exists.");
        return false;
      }

      await _vehicleDao.insert(vehicle);

      await loadVehicles();

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

  Future<bool> updateVehicle(VehicleModel vehicle) async {
    try {
      _setLoading(true);

      await _vehicleDao.update(vehicle);

      await loadVehicles();

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

  Future<void> deleteVehicle(int id) async {
    try {
      _setLoading(true);

      await _vehicleDao.delete(id);

      await loadVehicles();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // SEARCH
  //==========================================================================

  Future<void> searchVehicles(String keyword) async {
    try {
      _setLoading(true);

      if (keyword.trim().isEmpty) {
        await loadVehicles();
        return;
      }

      _vehicles = await _vehicleDao.search(keyword);

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

      await _vehicleDao.updateAvailability(
        id,
        available,
      );

      await loadVehicles();
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
    await loadVehicles();
  }

  //==========================================================================
// GET VEHICLE
//==========================================================================

VehicleModel? getVehicleById(int id) {
  try {
    return _vehicles.firstWhere(
      (vehicle) => vehicle.id == id,
    );
  } catch (_) {
    return null;
  }
}

VehicleModel? getVehicle(int id) {
  return getVehicleById(id);
}

  //==========================================================================
  // CLEAR ERROR
  //==========================================================================

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}