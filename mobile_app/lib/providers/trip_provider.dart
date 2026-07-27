import 'package:flutter/material.dart';

import '../database/dao/trip_dao.dart';
import '../models/trip_model.dart';

class TripProvider extends ChangeNotifier {
  final TripDao _tripDao = TripDao.instance;

  List<TripModel> _trips = [];

  bool _isLoading = false;

  String? _error;

  TripModel? _selectedTrip;

  //==========================================================
  // GETTERS
  //==========================================================

  List<TripModel> get trips =>
      List.unmodifiable(_trips);

  TripModel? get selectedTrip =>
      _selectedTrip;

  bool get isLoading => _isLoading;

  String? get error => _error;

  String? get errorMessage => _error;

  //==========================================================
  // PRIVATE
  //==========================================================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  //==========================================================
  // LOAD ALL TRIPS
  //==========================================================

  Future<void> loadTrips() async {
    try {
      _setLoading(true);

      _trips = await _tripDao.getAll();

      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // LOAD EMPLOYEE TRIPS
  //==========================================================

  Future<void> loadEmployeeTrips(
    int employeeId,
  ) async {
    try {
      _setLoading(true);

      _trips = await _tripDao.getEmployeeTrips(
        employeeId,
      );

      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // LOAD DRIVER TRIPS
  //==========================================================

  Future<void> loadDriverTrips(
    int driverId,
  ) async {
    try {
      _setLoading(true);

      _trips = await _tripDao.getDriverTrips(
        driverId,
      );

      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // SELECT TRIP
  //==========================================================

  void selectTrip(
    TripModel trip,
  ) {
    _selectedTrip = trip;
    notifyListeners();
  }

  //==========================================================
  // CLEAR SELECTED TRIP
  //==========================================================

  void clearSelectedTrip() {
    _selectedTrip = null;
    notifyListeners();
  }
    //==========================================================
  // ADD TRIP
  //==========================================================

  Future<bool> addTrip(
    TripModel trip,
  ) async {
    try {
      _setLoading(true);

      await _tripDao.insert(trip);

      await loadTrips();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // UPDATE TRIP
  //==========================================================

  Future<bool> updateTrip(
    TripModel trip,
  ) async {
    try {
      _setLoading(true);

      await _tripDao.update(trip);

      await loadTrips();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // DELETE TRIP
  //==========================================================

  Future<bool> deleteTrip(
    int id,
  ) async {
    try {
      _setLoading(true);

      await _tripDao.delete(id);

      await loadTrips();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // START TRIP
  //==========================================================

  Future<bool> startTrip(
    TripModel trip,
  ) async {
    try {
      _setLoading(true);

      await _tripDao.startTrip(
        trip.id!,
      );

      await loadTrips();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // COMPLETE TRIP
  //==========================================================

  Future<bool> completeTrip(
    TripModel trip,
  ) async {
    try {
      _setLoading(true);

      await _tripDao.completeTrip(
        trip.id!,
      );

      await loadTrips();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // CANCEL TRIP
  //==========================================================

  Future<bool> cancelTrip(
    TripModel trip,
  ) async {
    try {
      _setLoading(true);

      await _tripDao.cancelTrip(
        trip.id!,
      );

      await loadTrips();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }
    //==========================================================
  // UPDATE STATUS
  //==========================================================

  Future<bool> updateStatus(
    int tripId,
    String status,
  ) async {
    try {
      _setLoading(true);

      await _tripDao.updateStatus(
        id: tripId,
        status: status,
      );

      await loadTrips();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // GET TRIP BY ID
  //==========================================================

  TripModel? getTripById(
    int id,
  ) {
    try {
      return _trips.firstWhere(
        (trip) => trip.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  //==========================================================
  // GET TRIPS BY EMPLOYEE
  //==========================================================

  List<TripModel> getTripsByEmployee(
    int employeeId,
  ) {
    return _trips.where(
      (trip) => trip.employeeId == employeeId,
    ).toList();
  }

  //==========================================================
  // GET TRIPS BY DRIVER
  //==========================================================

  List<TripModel> getTripsByDriver(
    int driverId,
  ) {
    return _trips.where(
      (trip) => trip.driverId == driverId,
    ).toList();
  }

  //==========================================================
  // FILTERED LISTS
  //==========================================================

  List<TripModel> get pendingTrips =>
      _trips.where(
        (trip) => trip.status == "Pending",
      ).toList();

  List<TripModel> get assignedTrips =>
      _trips.where(
        (trip) => trip.status == "Assigned",
      ).toList();

  List<TripModel> get startedTrips =>
      _trips.where(
        (trip) => trip.status == "Started",
      ).toList();

  List<TripModel> get completedTrips =>
      _trips.where(
        (trip) => trip.status == "Completed",
      ).toList();

  List<TripModel> get cancelledTrips =>
      _trips.where(
        (trip) => trip.status == "Cancelled",
      ).toList();
        //==========================================================
  // REFRESH
  //==========================================================

  Future<void> refresh() async {
    await loadTrips();
  }

  //==========================================================
  // CLEAR ERROR
  //==========================================================

  void clearError() {
    _error = null;
    notifyListeners();
  }

  //==========================================================
  // RESET
  //==========================================================

  void reset() {
    _trips.clear();

    _selectedTrip = null;

    _error = null;

    _isLoading = false;

    notifyListeners();
  }

  //==========================================================
  // DASHBOARD COUNTS
  //==========================================================

  int get totalTrips => _trips.length;

  int get pendingTripCount =>
      pendingTrips.length;

  int get assignedTripCount =>
      assignedTrips.length;

  int get startedTripCount =>
      startedTrips.length;

  int get completedTripCount =>
      completedTrips.length;

  int get cancelledTripCount =>
      cancelledTrips.length;

  //==========================================================
  // SEARCH TRIPS
  //==========================================================

  List<TripModel> searchTrips(
    String keyword,
  ) {
    if (keyword.trim().isEmpty) {
      return _trips;
    }

    final search = keyword.toLowerCase();

    return _trips.where((trip) {
      return trip.tripId
              .toLowerCase()
              .contains(search) ||
          trip.pickupLocation
              .toLowerCase()
              .contains(search) ||
          trip.destination
              .toLowerCase()
              .contains(search) ||
          trip.status
              .toLowerCase()
              .contains(search);
    }).toList();
  }

  //==========================================================
  // STATUS COUNTS
  //==========================================================

  int get pendingCount => pendingTrips.length;

  int get assignedCount => assignedTrips.length;

  int get startedCount => startedTrips.length;

  int get completedCount => completedTrips.length;

  int get cancelledCount => cancelledTrips.length;
    //==========================================================
  // DISPOSE
  //==========================================================

  @override
  void dispose() {
    super.dispose();
  }
}