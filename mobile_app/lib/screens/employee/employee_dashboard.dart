import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/trip_provider.dart';
import '../../routes/app_router.dart';
import '../otp/otp_screen.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() =>
      _EmployeeDashboardState();
}

class _EmployeeDashboardState
    extends State<EmployeeDashboard> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final auth =
          context.read<AuthProvider>();

      if (auth.currentUser != null) {
        await context
            .read<TripProvider>()
            .loadEmployeeTrips(
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

    final employeeTrips =
        provider.trips;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Employee Dashboard",
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {

          await provider.loadEmployeeTrips(
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
              "My Trips",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(height: 15),
                        if (employeeTrips.isEmpty)

              const Card(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text(
                      "No Trips Assigned",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )

            else

              ...employeeTrips.map(
                (trip) {

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 15,
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        15,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
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

                          const SizedBox(
                            height: 10,
                          ),

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

                          const SizedBox(
                            height: 15,
                          ),

                          Row(
                            children: [

                              Expanded(
                                child:
                                    ElevatedButton.icon(
                                  icon:
                                      const Icon(
                                    Icons.lock,
                                  ),
                                  label:
                                      const Text(
                                    "Start OTP",
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
                                  icon:
                                      const Icon(
                                    Icons.flag,
                                  ),
                                  label:
                                      const Text(
                                    "End OTP",
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

                            ],
                          ),

                        ],
                      ),
                    ),
                  );

                },
              ).toList(),

            const SizedBox(
              height: 20,
            ),
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
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.pending_actions,
                  color: Colors.orange,
                ),
                title: const Text(
                  "Pending Trips",
                ),
                trailing: Text(
                  provider.pendingTrips.length
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

            const SizedBox(
              height: 20,
            ),
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

            const SizedBox(
              height: 20,
            ),

          ],
        ),
      ),
    );
  }
}