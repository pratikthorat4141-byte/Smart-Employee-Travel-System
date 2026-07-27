import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../database/dao/live_tracking_dao.dart';
import '../models/driver_live_location_model.dart';
import '../models/live_location_model.dart';

class LocationService {
  LocationService._();

  static StreamSubscription<Position>? _subscription;

  static Future<bool> requestPermission() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission ==
            LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<LiveLocationModel?>
      getCurrentLocation() async {
    final allowed =
        await requestPermission();

    if (!allowed) {
      return null;
    }

    final position =
        await Geolocator.getCurrentPosition(
      desiredAccuracy:
          LocationAccuracy.best,
    );

    return LiveLocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      speed: position.speed,
      heading: position.heading,
      accuracy: position.accuracy,
      timestamp: DateTime.now(),
    );
  }
    //==========================================================
  // START LIVE TRACKING
  //==========================================================

  static void startTracking({
    required String driverId,
    int? tripId,
    required Function(LiveLocationModel location) onUpdate,
  }) {
    stopTracking();

    _subscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      ),
    ).listen((position) async {
      final liveLocation = LiveLocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        speed: position.speed,
        heading: position.heading,
        accuracy: position.accuracy,
        timestamp: DateTime.now(),
      );

      onUpdate(liveLocation);

      try {
        await LiveTrackingDao.instance.insert(
          DriverLiveLocationModel(
            driverId: driverId,
            tripId: tripId,
            latitude: position.latitude,
            longitude: position.longitude,
            speed: position.speed,
            heading: position.heading,
            accuracy: position.accuracy,
            createdAt: DateTime.now(),
          ),
        );
      } catch (_) {
        // Ignore database write errors
      }
    });
  }
    //==========================================================
  // STOP TRACKING
  //==========================================================

  static void stopTracking() {
    _subscription?.cancel();
    _subscription = null;
  }

  //==========================================================
  // CALCULATE DISTANCE
  //==========================================================

  static double calculateDistance({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.distanceBetween(
      startLat,
      startLng,
      endLat,
      endLng,
    );
  }

  //==========================================================
  // CHECK LOCATION SERVICE
  //==========================================================

  static Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  //==========================================================
  // OPEN LOCATION SETTINGS
  //==========================================================

  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  //==========================================================
  // OPEN APP SETTINGS
  //==========================================================

  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}