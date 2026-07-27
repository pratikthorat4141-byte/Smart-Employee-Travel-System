import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/trip_model.dart';

import '../../providers/auth_provider.dart';
import '../../providers/trip_provider.dart';
import '../../providers/live_tracking_provider.dart';

import '../../screens/otp/otp_screen.dart';
import '../../widgets/live_map_widget.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({
    super.key,
  });

  @override
  State<DriverDashboardScreen> createState() =>
      _DriverDashboardScreenState();
}

class _DriverDashboardScreenState
    extends State<DriverDashboardScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context
          .read<TripProvider>()
          .loadTrips();
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    final auth =
        context.watch<AuthProvider>();

    final tripProvider =
        context.watch<TripProvider>();

    final tracking =
        context.watch<
            LiveTrackingProvider>();

    final driver =
        auth.currentUser;

    if (driver == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Driver not found",
          ),
        ),
      );
    }

    final trips =
        tripProvider.getTripsByDriver(
      driver.id!,
    );

    TripModel? currentTrip;

    if (trips.isNotEmpty) {
      currentTrip = trips.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Driver Dashboard",
        ),
        centerTitle: true,
      ),
            body: currentTrip == null
          ? const Center(
              child: Text(
                "No Trip Assigned",
              ),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(16),
              child: Column(
                children: [

                  //==================================================
                  // DRIVER INFORMATION
                  //==================================================

                  Card(
                    elevation: 3,
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 28,
                        child: Icon(
                          Icons.person,
                        ),
                      ),
                      title: Text(
                        driver.name,
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        driver.email,
                      ),
                      trailing: Chip(
                        backgroundColor:
                            Colors.blue.shade100,
                        label: Text(
                          currentTrip.status,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  //==================================================
                  // TRIP DETAILS
                  //==================================================

                  Card(
                    elevation: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Assigned Trip",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const Divider(),

                          ListTile(
                            leading: const Icon(
                              Icons.confirmation_number,
                            ),
                            title: Text(
                              currentTrip.tripId,
                            ),
                            subtitle:
                                const Text(
                              "Trip ID",
                            ),
                          ),

                          ListTile(
                            leading: const Icon(
                              Icons.location_on,
                            ),
                            title: Text(
                              currentTrip
                                  .pickupLocation,
                            ),
                            subtitle:
                                const Text(
                              "Pickup Location",
                            ),
                          ),

                          ListTile(
                            leading:
                                const Icon(
                              Icons.flag,
                            ),
                            title: Text(
                              currentTrip
                                  .destination,
                            ),
                            subtitle:
                                const Text(
                              "Destination",
                            ),
                          ),

                          ListTile(
                            leading:
                                const Icon(
                              Icons.calendar_today,
                            ),
                            title: Text(
                              currentTrip.tripDate,
                            ),
                            subtitle:
                                const Text(
                              "Trip Date",
                            ),
                          ),

                          ListTile(
                            leading:
                                const Icon(
                              Icons.access_time,
                            ),
                            title: Text(
                              currentTrip.tripTime,
                            ),
                            subtitle:
                                const Text(
                              "Trip Time",
                            ),
                          ),

                          ListTile(
                            leading:
                                const Icon(
                              Icons.route,
                            ),
                            title: Text(
                              "${currentTrip.totalDistance.toStringAsFixed(2)} km",
                            ),
                            subtitle:
                                const Text(
                              "Distance",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                                    //==================================================
                  // ACTION BUTTONS
                  //==================================================

                  Row(
                    children: [

                      //------------------------------------------------
                      // GENERATE START OTP
                      //------------------------------------------------

                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(
                            Icons.lock_open,
                          ),
                          label: const Text(
                            "Start OTP",
                          ),
                          onPressed: currentTrip.status ==
                                  "Assigned"
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          OtpScreen(
                                        tripId: currentTrip!.tripId,
                                        employeeId:
                                            currentTrip.employeeId,
                                        driverId:
                                            currentTrip.driverId,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ),

                      const SizedBox(width: 12),

                      //------------------------------------------------
                      // GENERATE END OTP
                      //------------------------------------------------

                      Expanded(
                        child: FilledButton.icon(
                          style:
                              FilledButton.styleFrom(
                            backgroundColor:
                                Colors.red,
                          ),
                          icon: const Icon(
                            Icons.flag,
                          ),
                          label: const Text(
                            "End OTP",
                          ),
                          onPressed: currentTrip.status ==
                                  "Started"
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          OtpScreen(
                                        tripId: currentTrip!.tripId,
                                        employeeId:
                                            currentTrip.employeeId,
                                        driverId:
                                            currentTrip.driverId,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  //------------------------------------------------
                  // REFRESH
                  //------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(
                        Icons.refresh,
                      ),
                      label: const Text(
                        "Refresh Trip",
                      ),
                      onPressed: () async {
                        await tripProvider
                            .loadTrips();
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                                    //==================================================
                  // LIVE TRACKING
                  //==================================================

                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Live Tracking",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [

                              Expanded(
                                child: FilledButton.icon(
                                  icon: const Icon(
                                    Icons.play_arrow,
                                  ),
                                  label: const Text(
                                    "Start Tracking",
                                  ),
                                  onPressed: () async {
                                    await tracking
                                        .startTracking();
                                  },
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: FilledButton.icon(
                                  style:
                                      FilledButton.styleFrom(
                                    backgroundColor:
                                        Colors.red,
                                  ),
                                  icon: const Icon(
                                    Icons.stop,
                                  ),
                                  label: const Text(
                                    "Stop Tracking",
                                  ),
                                  onPressed: () async {
                                    await tracking
                                        .stopTracking();
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          const SizedBox(
                            height: 350,
                            child: Card(
                              clipBehavior:
                                  Clip.antiAlias,
                              child:
                                  LiveMapWidget(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //==================================================
                  // REMARKS
                  //==================================================

                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.note,
                      ),
                      title: const Text(
                        "Remarks",
                      ),
                      subtitle: Text(
                        currentTrip.remarks.isEmpty
                            ? "No remarks available."
                            : currentTrip.remarks,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}