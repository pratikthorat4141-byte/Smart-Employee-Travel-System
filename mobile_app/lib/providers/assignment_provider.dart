import 'package:flutter/material.dart';

import '../models/assignment_model.dart';
import '../models/driver_model.dart';
import '../models/employee_model.dart';
import '../models/trip_model.dart';
import '../models/vehicle_model.dart';
import '../services/grouping_service.dart';

class AssignmentProvider extends ChangeNotifier {
  final List<AssignmentModel> _assignments = [];

  bool _isLoading = false;

  List<AssignmentModel> get assignments => _assignments;

  bool get isLoading => _isLoading;

  //======================================================
  // Load Assignments
  //======================================================

  Future<void> loadAssignments() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    _isLoading = false;
    notifyListeners();
  }

  //======================================================
  // Create Assignment
  //======================================================

  Future<void> assignTrip({
    required TripModel trip,
    required DriverModel driver,
    required VehicleModel vehicle,
    required List<EmployeeModel> employees,
  }) async {
    final groups = GroupingService.createGroups(
      employees,
      groupSize: 4,
    );

    for (final group in groups) {
      final assignment = AssignmentModel(
        id: DateTime.now()
            .millisecondsSinceEpoch,
        assignmentId:
            "ASG-${DateTime.now().millisecondsSinceEpoch}",
        tripId: trip.id ?? 0,
        driverId: driver.id ?? 0,
        vehicleId: vehicle.id ?? 0,
        employeeIds:
            group.map((e) => e.id ?? 0).toList(),
        assignmentDate:
            DateTime.now()
                .toIso8601String(),
        status: "Assigned",
      );

      _assignments.add(assignment);
    }

    notifyListeners();
  }

  //======================================================
  // Delete
  //======================================================

  Future<void> deleteAssignment(
      int id) async {
    _assignments.removeWhere(
      (e) => e.id == id,
    );

    notifyListeners();
  }

  //======================================================
  // Update Status
  //======================================================

  Future<void> updateStatus({
    required int id,
    required String status,
  }) async {
    final index = _assignments.indexWhere(
      (e) => e.id == id,
    );

    if (index == -1) return;

    _assignments[index] =
        _assignments[index].copyWith(
      status: status,
    );

    notifyListeners();
  }

  //======================================================
  // Refresh
  //======================================================

  Future<void> refresh() async {
    await loadAssignments();
  }

  void clear() {
    _assignments.clear();
    notifyListeners();
  }
}