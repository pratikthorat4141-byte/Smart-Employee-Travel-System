import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../vehicle/models/vehicle_model.dart';

class VehicleProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  VehicleProvider() {
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    final data = await _db.getVehicles();

    _vehicles = data.map((e) => Vehicle.fromMap(e)).toList();

    notifyListeners();
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    await _db.insertVehicle(vehicle.toMap());

    await loadVehicles();
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _db.updateVehicle(vehicle.toMap());

    await loadVehicles();
  }

  Future<void> deleteVehicle(int id) async {
    await _db.deleteVehicle(id);

    await loadVehicles();
  }

  Future<void> searchVehicle(String keyword) async {
    await loadVehicles();

    if (keyword.trim().isEmpty) return;

    _vehicles = _vehicles.where((vehicle) {
      return vehicle.vehicleNo
              .toLowerCase()
              .contains(keyword.toLowerCase()) ||
          vehicle.type
              .toLowerCase()
              .contains(keyword.toLowerCase()) ||
          vehicle.capacity
              .toString()
              .contains(keyword);
    }).toList();

    notifyListeners();
  }
}