import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/trip_provider.dart';
import '../../screens/otp/otp_screen.dart';
import '../../routes/app_router.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() =>
      _DriverDashboardState();
}

class _DriverDashboardState
    extends State<DriverDashboard> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {

      final auth =
          context.read<AuthProvider>();

      if (auth.currentUser != null) {

        await context
            .read<TripProvider>()
            .loadDriverTrips(
              auth.currentUser!.id!,
            );

      }

    });
  }

  @override
  Widget build(BuildContext context) {

    final auth =
        context.watch<AuthProvider>();

    final provider =
        context.watch<TripProvider>();

    final trips =
        provider.trips;

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Driver Dashboard",
        ),
        centerTitle: true,
      ),

      body: RefreshIndicator(

        onRefresh: () async {

          await provider.loadDriverTrips(
            auth.currentUser!.id!,
          );

        },

        child: ListView(

          padding:
              const EdgeInsets.all(16),

          children: [

            Card(
              child: ListTile(
                leading:
                    const CircleAvatar(
                  radius: 28,
                  child: Icon(
                    Icons.person,
                  ),
                ),
                title: Text(
                  auth.currentUser?.name ??
                      "",
                ),
                subtitle: Text(
                  auth.currentUser?.email ??
                      "",
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Assigned Trips",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(height: 15),
                        if (trips.isEmpty)

              const Card(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text(
                      "No Trips Assigned",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )

            else

              ...trips.map((trip) {

                return Card(

                  margin: const EdgeInsets.only(
                    bottom: 15,
                  ),

                  child: Padding(

                    padding: const EdgeInsets.all(
                      15,
                    ),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Row(

                          children: [

                            Expanded(

                              child: Text(

                                trip.tripId,

                                style:
                                    const TextStyle(

                                  fontSize: 18,

                                  fontWeight:
                                      FontWeight.bold,

                                ),

                              ),

                            ),

                            Chip(
                              label: Text(
                                trip.status,
                              ),
                            ),

                          ],

                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Pickup : ${trip.pickupLocation}",
                        ),

                        Text(
                          "Destination : ${trip.destination}",
                        ),

                        Text(
                          "Date : ${trip.tripDate}",
                        ),

                        Text(
                          "Time : ${trip.tripTime}",
                        ),

                        const SizedBox(height: 15),

                        Row(

                          children: [

                            Expanded(

                              child:
                                  ElevatedButton.icon(

                                icon: const Icon(
                                  Icons.lock_open,
                                ),

                                label: const Text(
                                  "Verify OTP",
                                ),

                                onPressed: () {

                                  Navigator.push(

                                    context,

                                    MaterialPageRoute(

                                      builder: (_) =>
                                          OtpScreen(

                                        tripId:
                                            trip.tripId,

                                        employeeId:
                                            trip.employeeId,

                                        driverId:
                                            trip.driverId,

                                      ),

                                    ),

                                  );

                                },

                              ),

                            ),
                                                        const SizedBox(
                              width: 10,
                            ),

                            Expanded(

                              child:
                                  OutlinedButton.icon(

                                icon: const Icon(
                                  Icons.play_arrow,
                                ),

                                label: Text(

                                  trip.status ==
                                          "Started"
                                      ? "Complete Trip"
                                      : "Start Trip",

                                ),

                                onPressed: () async {

                                  bool success;

                                  if (trip.status ==
                                      "Started") {

                                    success =
                                        await provider
                                            .completeTrip(
                                      trip,
                                    );

                                  } else {

                                    success =
                                        await provider
                                            .startTrip(
                                      trip,
                                    );

                                  }

                                  if (!context.mounted) {
                                    return;
                                  }

                                  ScaffoldMessenger.of(
                                          context)
                                      .showSnackBar(

                                    SnackBar(

                                      content: Text(

                                        success
                                            ? "Trip Updated Successfully"
                                            : "Failed",

                                      ),

                                    ),

                                  );

                                },

                              ),

                            ),

                          ],

                        ),

                      ],

                    ),

                  ),

                );

              }).toList(),

              const SizedBox(height: 20),
                          Card(
              child: ListTile(
                leading: const Icon(
                  Icons.route,
                  color: Colors.blue,
                ),
                title: const Text(
                  "Total Trips",
                ),
                trailing: Text(
                  provider.totalTrips.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.assignment,
                  color: Colors.orange,
                ),
                title: const Text(
                  "Assigned Trips",
                ),
                trailing: Text(
                  provider.assignedTrips.length
                      .toString(),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.blue,
                ),
                title: const Text(
                  "Started Trips",
                ),
                trailing: Text(
                  provider.startedTrips.length
                      .toString(),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                title: const Text(
                  "Completed Trips",
                ),
                trailing: Text(
                  provider.completedTrips.length
                      .toString(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              value: true,
              onChanged: (value) {
                // TODO:
                // Driver Availability
              },
              secondary: const Icon(
                Icons.online_prediction,
              ),
              title: const Text(
                "Available for Trips",
              ),
            ),

            const SizedBox(height: 20),
                        FilledButton.icon(
              onPressed: () async {

                await provider.loadDriverTrips(
                  auth.currentUser!.id!,
                );

              },
              icon: const Icon(
                Icons.refresh,
              ),
              label: const Text(
                "Refresh Trips",
              ),
            ),

            const SizedBox(height: 15),

            OutlinedButton.icon(
              onPressed: () async {

                await context
                    .read<AuthProvider>()
                    .logout();

                if (!context.mounted) {
                  return;
                }

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.login,
                  (_) => false,
                );

              },
              icon: const Icon(
                Icons.logout,
              ),
              label: const Text(
                "Logout",
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}