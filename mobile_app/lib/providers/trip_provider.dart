import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../trip/models/trip_model.dart';

class TripProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Trip> _trips = [];

  String _searchText = "";
  String _selectedStatus = "All";

  List<Trip> get trips {
    return _trips.where((trip) {
      final matchesSearch =
          trip.employee.toLowerCase().contains(_searchText.toLowerCase()) ||
          trip.driver.toLowerCase().contains(_searchText.toLowerCase()) ||
          trip.vehicle.toLowerCase().contains(_searchText.toLowerCase()) ||
          trip.source.toLowerCase().contains(_searchText.toLowerCase()) ||
          trip.destination.toLowerCase().contains(_searchText.toLowerCase());

      final matchesStatus =
          _selectedStatus == "All" || trip.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  String get selectedStatus => _selectedStatus;

  TripProvider() {
    loadTrips();
  }

  Future<void> loadTrips() async {
    final data = await _db.getTrips();
    _trips = data.map((e) => Trip.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addTrip(Trip trip) async {
    await _db.insertTrip(trip.toMap());
    await loadTrips();
  }

  Future<void> updateTrip(Trip trip) async {
    await _db.updateTrip(trip.toMap());
    await loadTrips();
  }

  Future<void> deleteTrip(int id) async {
    await _db.deleteTrip(id);
    await loadTrips();
  }

  Future<void> searchTrip(String value) async {
    _searchText = value;
    notifyListeners();
  }

  void filterTrip(String status) {
    _selectedStatus = status;
    notifyListeners();
  }
}