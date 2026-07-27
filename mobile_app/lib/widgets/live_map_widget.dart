import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/live_tracking_provider.dart';
import '../providers/route_provider.dart';

class LiveMapWidget extends StatefulWidget {
  const LiveMapWidget({
    super.key,
  });

  @override
  State<LiveMapWidget> createState() =>
      _LiveMapWidgetState();
}

class _LiveMapWidgetState
    extends State<LiveMapWidget> {

  final MapController _mapController =
      MapController();

  static const LatLng office =
      LatLng(
    18.520430,
    73.856743,
  );

  final List<LatLng> employees = const [

    LatLng(
      18.521420,
      73.857500,
    ),

    LatLng(
      18.523000,
      73.858900,
    ),

    LatLng(
      18.519500,
      73.854900,
    ),

    LatLng(
      18.517800,
      73.859500,
    ),

  ];

  @override
  Widget build(BuildContext context) {

    return Consumer2<
        LiveTrackingProvider,
        RouteProvider>(
      builder: (
        context,
        tracking,
        routeProvider,
        child,
      ) {

        final current =
            tracking.currentLocation;

        if (current == null) {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        final driver = LatLng(
          current.latitude,
          current.longitude,
        );

        WidgetsBinding.instance
            .addPostFrameCallback((_) {

          if (mounted) {
            _mapController.move(
              driver,
              16,
            );
          }

        });

        return Stack(
          children: [
                        FlutterMap(
              mapController: _mapController,

              options: MapOptions(
                initialCenter: driver,
                initialZoom: 16,
                interactionOptions:
                    const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),

              children: [

                //==========================================
                // OPEN STREET MAP
                //==========================================

                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.smart.employee.travel',
                ),

                //==========================================
                // ROUTE
                //==========================================

                PolylineLayer(
                  polylines: [

                    if (routeProvider.routePoints.isNotEmpty)

                      Polyline(
                        points:
                            routeProvider.routePoints,
                        strokeWidth: 5,
                        color: Colors.blue,
                      )

                    else

                      Polyline(
                        points: [
                          office,
                          ...employees,
                          driver,
                        ],
                        strokeWidth: 4,
                        color: Colors.grey,
                      ),

                  ],
                ),
                                //==========================================
                // MARKERS
                //==========================================

                MarkerLayer(
                  markers: [

                    //----------------------------------------
                    // OFFICE
                    //----------------------------------------

                    Marker(
                      point: office,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.business,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),

                    //----------------------------------------
                    // DRIVER
                    //----------------------------------------

                    Marker(
                      point: driver,
                      width: 70,
                      height: 70,
                      child: Transform.rotate(
                        angle: current.heading *
                            (3.141592653589793 / 180),
                        child: const Icon(
                          Icons.local_taxi,
                          color: Colors.green,
                          size: 45,
                        ),
                      ),
                    ),

                    //----------------------------------------
                    // EMPLOYEES
                    //----------------------------------------

                    ...employees.map(
                      (employee) => Marker(
                        point: employee,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.orange,
                          size: 35,
                        ),
                      ),
                    ),

                  ],
                ),

                //==========================================
                // MAP ATTRIBUTION
                //==========================================

                RichAttributionWidget(
                  attributions: const [
                    TextSourceAttribution(
                      '© OpenStreetMap contributors',
                    ),
                  ],
                ),

              ],
            ),
                        //==========================================
            // LIVE INFO CARD
            //==========================================

            Positioned(
              top: 15,
              right: 15,
              child: Card(
                elevation: 6,
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const Text(
                        "Live Tracking",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Divider(),

                      Row(
                        children: [
                          const Icon(
                            Icons.route,
                            size: 18,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Distance : ${routeProvider.distanceText}",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            size: 18,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "ETA : ${routeProvider.durationText}",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.speed,
                            size: 18,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Speed : ${current.speed.toStringAsFixed(1)} m/s",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.gps_fixed,
                            size: 18,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Accuracy : ${current.accuracy.toStringAsFixed(1)} m",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 18,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${current.latitude.toStringAsFixed(5)}, ${current.longitude.toStringAsFixed(5)}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: tracking.isTracking
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            tracking.isTracking
                                ? "Tracking Running"
                                : "Tracking Stopped",
                            style: TextStyle(
                              color: tracking.isTracking
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
                        //==================================================
            // MY LOCATION BUTTON
            //==================================================

            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                heroTag: "my_location",
                mini: true,
                onPressed: () {
                  _mapController.move(
                    driver,
                    16,
                  );
                },
                child: const Icon(
                  Icons.my_location,
                ),
              ),
            ),

            //==================================================
            // REFRESH ROUTE BUTTON
            //==================================================

            Positioned(
              bottom: 90,
              right: 20,
              child: FloatingActionButton(
                heroTag: "refresh_route",
                mini: true,
                onPressed: () {
                  routeProvider.loadRoute(
                    start: office,
                    end: driver,
                  );
                },
                child: const Icon(
                  Icons.route,
                ),
              ),
            ),

          ],
        );
      },
    );
  }
}