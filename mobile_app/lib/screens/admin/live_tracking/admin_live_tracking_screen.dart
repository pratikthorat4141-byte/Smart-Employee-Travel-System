import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/live_tracking_provider.dart';
import '../../../providers/trip_provider.dart';
import '../../../widgets/live_map_widget.dart';

class AdminLiveTrackingScreen extends StatefulWidget {
  const AdminLiveTrackingScreen({super.key});

  @override
  State<AdminLiveTrackingScreen> createState() =>
      _AdminLiveTrackingScreenState();
}

class _AdminLiveTrackingScreenState
    extends State<AdminLiveTrackingScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {

      await context
          .read<TripProvider>()
          .loadTrips();

      await context
          .read<LiveTrackingProvider>()
          .loadCurrentLocation();

    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer2<
        TripProvider,
        LiveTrackingProvider>(
      builder: (
        context,
        tripProvider,
        tracking,
        child,
      ) {

        return Scaffold(

          appBar: AppBar(
            title: const Text(
              "Admin Live Tracking",
            ),
            centerTitle: true,
          ),

          body: SingleChildScrollView(

            padding:
                const EdgeInsets.all(16),

            child: Column(
              children: [
                                //==================================================
                // SUMMARY CARDS
                //==================================================

                Row(
                  children: [

                    Expanded(
                      child: Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(16),
                          child: Column(
                            children: [

                              const Icon(
                                Icons.route,
                                color: Colors.blue,
                                size: 35,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "${tripProvider.totalTrips}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const Text(
                                "Total Trips",
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(16),
                          child: Column(
                            children: [

                              const Icon(
                                Icons.play_circle_fill,
                                color: Colors.green,
                                size: 35,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "${tripProvider.startedTripCount}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const Text(
                                "Running",
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [

                    Expanded(
                      child: Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(16),
                          child: Column(
                            children: [

                              const Icon(
                                Icons.check_circle,
                                color: Colors.indigo,
                                size: 35,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "${tripProvider.completedTripCount}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const Text(
                                "Completed",
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(16),
                          child: Column(
                            children: [

                              Icon(
                                tracking.isTracking
                                    ? Icons.gps_fixed
                                    : Icons.gps_off,
                                color:
                                    tracking.isTracking
                                        ? Colors.green
                                        : Colors.red,
                                size: 35,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                tracking.isTracking
                                    ? "ON"
                                    : "OFF",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const Text(
                                "Tracking",
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {

                      await tripProvider.refresh();

                      await tracking.refresh();

                    },
                    icon: const Icon(
                      Icons.refresh,
                    ),
                    label: const Text(
                      "Refresh Dashboard",
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                                //==================================================
                // LIVE MAP
                //==================================================

                const SizedBox(
                  height: 400,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: LiveMapWidget(),
                  ),
                ),

                const SizedBox(height: 20),

                //==================================================
                // DRIVER LIVE LOCATION
                //==================================================

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Driver Live Location",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const Divider(),

                        ListTile(
                          leading: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                          ),
                          title: Text(
                            tracking.currentLocation == null
                                ? "--"
                                : tracking.currentLocation!
                                    .latitude
                                    .toStringAsFixed(6),
                          ),
                          subtitle: const Text(
                            "Latitude",
                          ),
                        ),

                        ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          title: Text(
                            tracking.currentLocation == null
                                ? "--"
                                : tracking.currentLocation!
                                    .longitude
                                    .toStringAsFixed(6),
                          ),
                          subtitle: const Text(
                            "Longitude",
                          ),
                        ),

                        ListTile(
                          leading: const Icon(
                            Icons.speed,
                            color: Colors.orange,
                          ),
                          title: Text(
                            tracking.currentLocation == null
                                ? "0 m/s"
                                : tracking.currentLocation!
                                    .speed
                                    .toStringAsFixed(2),
                          ),
                          subtitle: const Text(
                            "Speed",
                          ),
                        ),

                        ListTile(
                          leading: const Icon(
                            Icons.gps_fixed,
                            color: Colors.green,
                          ),
                          title: Text(
                            tracking.currentLocation == null
                                ? "--"
                                : "${tracking.currentLocation!.accuracy.toStringAsFixed(2)} m",
                          ),
                          subtitle: const Text(
                            "GPS Accuracy",
                          ),
                        ),

                        ListTile(
                          leading: Icon(
                            tracking.isTracking
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: tracking.isTracking
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(
                            tracking.isTracking
                                ? "Tracking Running"
                                : "Tracking Stopped",
                          ),
                          subtitle: const Text(
                            "Tracking Status",
                          ),
                        ),

                        if (tracking.lastUpdated != null)
                          ListTile(
                            leading: const Icon(
                              Icons.update,
                            ),
                            title: Text(
                              tracking.lastUpdated
                                  .toString(),
                            ),
                            subtitle: const Text(
                              "Last Updated",
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                                //==================================================
                // RUNNING TRIPS
                //==================================================

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Running Trips",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                if (tripProvider.startedTrips.isEmpty)

                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          "No Running Trips",
                        ),
                      ),
                    ),
                  )

                else

                  ...tripProvider.startedTrips.map(

                    (trip) => Card(
                      margin:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: ListTile(

                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.local_taxi,
                          ),
                        ),

                        title: Text(
                          trip.tripId,
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Pickup : ${trip.pickupLocation}",
                            ),

                            Text(
                              "Destination : ${trip.destination}",
                            ),

                            Text(
                              "Distance : ${trip.totalDistance.toStringAsFixed(2)} km",
                            ),

                          ],
                        ),

                        trailing: Chip(
                          backgroundColor:
                              Colors.green.shade100,
                          label: Text(
                            trip.status,
                          ),
                        ),
                      ),
                    ),

                  ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {

                      await tripProvider.refresh();

                      await tracking.refresh();

                    },
                    icon: const Icon(
                      Icons.refresh,
                    ),
                    label: const Text(
                      "Refresh",
                    ),
                  ),
                ),

                const SizedBox(height: 30),

              ],
            ),
          ),
        );
      },
    );
  }
}