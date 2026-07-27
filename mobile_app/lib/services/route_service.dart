import 'package:latlong2/latlong.dart';

class RouteService {
  RouteService._();

  static final Distance _distance = const Distance();

  //==========================================================
  // Distance (Meters)
  //==========================================================

  static double distance({
    required LatLng start,
    required LatLng end,
  }) {
    return _distance.as(
      LengthUnit.Meter,
      start,
      end,
    );
  }

  //==========================================================
  // Distance (KM)
  //==========================================================

  static double distanceInKm({
    required LatLng start,
    required LatLng end,
  }) {
    return distance(
          start: start,
          end: end,
        ) /
        1000;
  }

  //==========================================================
  // Estimated Time
  //==========================================================

  static int estimateMinutes({
    required double distanceKm,
    double averageSpeed = 35,
  }) {
    if (distanceKm <= 0) {
      return 0;
    }

    return ((distanceKm / averageSpeed) * 60)
        .round();
  }

  //==========================================================
  // Straight Route
  //==========================================================

  static List<LatLng> createRoute({
    required LatLng start,
    required LatLng end,
  }) {
    return [
      start,
      end,
    ];
  }

  //==========================================================
  // Multi Stop Route
  //==========================================================

  static List<LatLng> createMultiStopRoute({
    required LatLng office,
    required List<LatLng> employees,
  }) {
    final route = <LatLng>[
      office,
    ];

    route.addAll(employees);

    route.add(office);

    return route;
  }

  //==========================================================
  // Total Distance
  //==========================================================

  static double totalDistance(
    List<LatLng> points,
  ) {
    if (points.length < 2) {
      return 0;
    }

    double total = 0;

    for (int i = 0; i < points.length - 1; i++) {
      total += distanceInKm(
        start: points[i],
        end: points[i + 1],
      );
    }

    return total;
  }
}