import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteProvider extends ChangeNotifier {
  bool _isLoading = false;

  List<LatLng> _routePoints = [];

  double _distance = 0;

  double _duration = 0;

  String? _error;

  bool get isLoading => _isLoading;

  List<LatLng> get routePoints =>
      List.unmodifiable(_routePoints);

  double get distance => _distance;

  double get duration => _duration;

  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }
    //==========================================================
  // LOAD ROUTE FROM OSRM
  //==========================================================

  Future<void> loadRoute({
    required LatLng start,
    required LatLng end,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      _routePoints.clear();

      final url = Uri.parse(
        "https://router.project-osrm.org/route/v1/driving/"
        "${start.longitude},${start.latitude};"
        "${end.longitude},${end.latitude}"
        "?overview=full&geometries=geojson",
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception("Unable to load route.");
      }

      final json =
          jsonDecode(response.body);

      final routes = json["routes"];

      if (routes == null || routes.isEmpty) {
        throw Exception("No route found.");
      }

      final route = routes.first;

      _distance =
          (route["distance"] ?? 0) / 1000;

      _duration =
          (route["duration"] ?? 0) / 60;

      final coordinates =
          route["geometry"]["coordinates"];

      for (final point in coordinates) {
        _routePoints.add(
          LatLng(
            point[1].toDouble(),
            point[0].toDouble(),
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
    //==========================================================
  // CLEAR ROUTE
  //==========================================================

  void clearRoute() {
    _routePoints.clear();
    _distance = 0;
    _duration = 0;
    _error = null;

    notifyListeners();
  }

  //==========================================================
  // REFRESH ROUTE
  //==========================================================

  Future<void> refresh({
    required LatLng start,
    required LatLng end,
  }) async {
    await loadRoute(
      start: start,
      end: end,
    );
  }

  //==========================================================
  // GETTERS
  //==========================================================

  bool get hasRoute => _routePoints.isNotEmpty;

  String get distanceText =>
      "${_distance.toStringAsFixed(2)} km";

  String get durationText =>
      "${_duration.toStringAsFixed(0)} min";

  //==========================================================
  // DISPOSE
  //==========================================================

  @override
  void dispose() {
    _routePoints.clear();
    super.dispose();
  }
}