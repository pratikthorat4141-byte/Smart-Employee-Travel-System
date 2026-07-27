import 'package:flutter/material.dart';

import '../database/dao/live_tracking_dao.dart';
import '../models/driver_live_location_model.dart';
import '../models/live_location_model.dart';
import '../services/location_service.dart';

class LiveTrackingProvider extends ChangeNotifier {
  final LiveTrackingDao _trackingDao =
      LiveTrackingDao.instance;

  LiveLocationModel? _currentLocation;

  List<DriverLiveLocationModel> _route = [];

  bool _isTracking = false;

  bool _isLoading = false;

  String? _error;

  DateTime? _lastUpdated;

  //==========================================================
  // GETTERS
  //==========================================================

  LiveLocationModel? get currentLocation =>
      _currentLocation;

  List<DriverLiveLocationModel> get route =>
      List.unmodifiable(_route);

  bool get isTracking => _isTracking;

  bool get isLoading => _isLoading;

  String? get error => _error;

  DateTime? get lastUpdated =>
      _lastUpdated;

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
  // LOAD CURRENT LOCATION
  //==========================================================

  Future<void> loadCurrentLocation() async {
    try {
      _setLoading(true);

      final location =
          await LocationService.getCurrentLocation();

      if (location != null) {
        _currentLocation = location;
        _lastUpdated = DateTime.now();
      }

      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // START LIVE TRACKING
  //==========================================================

  Future<void> startTracking({
    required String driverId,
    int? tripId,
  }) async {
    try {
      _setLoading(true);

      final permission =
          await LocationService.requestPermission();

      if (!permission) {
        _setError("Location permission denied.");
        return;
      }

      _isTracking = true;

      LocationService.startTracking(
        driverId: driverId,
        tripId: tripId,
        onUpdate: (location) async {
          _currentLocation = location;
          _lastUpdated = DateTime.now();

          if (tripId != null) {
            _route =
                await _trackingDao.getTripRoute(
              tripId,
            );
          }

          notifyListeners();
        },
      );

      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
    //==========================================================
  // STOP TRACKING
  //==========================================================

  void stopTracking() {
    LocationService.stopTracking();

    _isTracking = false;

    notifyListeners();
  }

  //==========================================================
  // LOAD TRIP ROUTE
  //==========================================================

  Future<void> loadTripRoute(
    int tripId,
  ) async {
    try {
      _setLoading(true);

      _route = await _trackingDao.getTripRoute(
        tripId,
      );

      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // LOAD DRIVER HISTORY
  //==========================================================

  Future<void> loadDriverHistory(
    String driverId,
  ) async {
    try {
      _setLoading(true);

      _route = await _trackingDao.getDriverHistory(
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
  // GET LATEST DRIVER LOCATION
  //==========================================================

  Future<DriverLiveLocationModel?>
      getLatestDriverLocation(
    String driverId,
  ) async {
    try {
      return await _trackingDao.getLatestLocation(
        driverId,
      );
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  //==========================================================
  // CLEAR ROUTE
  //==========================================================

  void clearRoute() {
    _route.clear();
    notifyListeners();
  }

  //==========================================================
  // DELETE TRIP HISTORY
  //==========================================================

  Future<void> deleteTripHistory(
    int tripId,
  ) async {
    try {
      _setLoading(true);

      await _trackingDao.deleteTripHistory(
        tripId,
      );

      _route.clear();

      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // DELETE DRIVER HISTORY
  //==========================================================

  Future<void> deleteDriverHistory(
    String driverId,
  ) async {
    try {
      _setLoading(true);

      await _trackingDao.deleteDriverHistory(
        driverId,
      );

      _route.clear();

      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
    //==========================================================
  // DISTANCE
  //==========================================================

  double distanceTo({
    required double latitude,
    required double longitude,
  }) {
    if (_currentLocation == null) {
      return 0;
    }

    return LocationService.calculateDistance(
      startLat: _currentLocation!.latitude,
      startLng: _currentLocation!.longitude,
      endLat: latitude,
      endLng: longitude,
    );
  }

  //==========================================================
  // REFRESH
  //==========================================================

  Future<void> refresh() async {
    await loadCurrentLocation();
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
    _currentLocation = null;
    _route.clear();
    _isTracking = false;
    _error = null;
    _lastUpdated = null;

    notifyListeners();
  }

  //==========================================================
  // DISPOSE
  //==========================================================

  @override
  void dispose() {
    LocationService.stopTracking();
    super.dispose();
  }
}