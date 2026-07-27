import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/driver_model.dart';
import '../../../models/employee_model.dart';
import '../../../models/trip_model.dart';
import '../../../models/vehicle_model.dart';

import '../../../providers/driver_provider.dart';
import '../../../providers/employee_provider.dart';
import '../../../providers/trip_provider.dart';
import '../../../providers/vehicle_provider.dart';

import 'add_trip_screen.dart';
import 'trip_details_screen.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() =>
      _TripListScreenState();
}

class _TripListScreenState
    extends State<TripListScreen> {
  final TextEditingController
      _searchController =
      TextEditingController();

  String _search = "";
  String _statusFilter = "All";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) async {
      await context
          .read<EmployeeProvider>()
          .loadEmployees();

      await context
          .read<DriverProvider>()
          .loadDrivers();

      await context
          .read<VehicleProvider>()
          .loadVehicles();

      await context
          .read<TripProvider>()
          .loadTrips();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //----------------------------------------------------------
  // STATUS COLOR
  //----------------------------------------------------------

  Color _statusColor(
    String status,
  ) {
    switch (status) {
      case "Pending":
        return Colors.orange;

      case "Assigned":
        return Colors.blue;

      case "Started":
        return Colors.deepPurple;

      case "Completed":
        return Colors.green;

      case "Cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  //----------------------------------------------------------
  // STATUS ICON
  //----------------------------------------------------------

  IconData _statusIcon(
    String status,
  ) {
    switch (status) {
      case "Pending":
        return Icons.pending_actions;

      case "Assigned":
        return Icons.assignment;

      case "Started":
        return Icons.play_circle_fill;

      case "Completed":
        return Icons.check_circle;

      case "Cancelled":
        return Icons.cancel;

      default:
        return Icons.help;
    }
  }

  //----------------------------------------------------------
  // DELETE TRIP
  //----------------------------------------------------------

  Future<void> _deleteTrip(
    TripModel trip,
  ) async {
    final provider =
        context.read<TripProvider>();

    final confirm =
        await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text(
                  "Delete Trip",
                ),
                content: Text(
                  "Delete ${trip.tripId} ?",
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(
                      context,
                      false,
                    ),
                    child: const Text(
                      "Cancel",
                    ),
                  ),
                  FilledButton(
                    onPressed: () =>
                        Navigator.pop(
                      context,
                      true,
                    ),
                    child: const Text(
                      "Delete",
                    ),
                  ),
                ],
              ),
            ) ??
            false;

    if (!confirm) return;

    await context
        .read<DriverProvider>()
        .updateAvailability(
          trip.driverId,
          true,
        );

    await context
        .read<VehicleProvider>()
        .updateAvailability(
          trip.vehicleId,
          true,
        );

    await provider.deleteTrip(
      trip.id!,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Trip Deleted Successfully",
        ),
      ),
    );
  }
    //----------------------------------------------------------
  // COMPLETE TRIP (FIXED)
  //----------------------------------------------------------

  Future<void> _completeTrip(
    TripModel trip,
  ) async {
    final provider =
        context.read<TripProvider>();

    final success =
        await provider.updateStatus(
      trip.id!,
      "Completed",
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Trip Completed Successfully",
          ),
        ),
      );

      await provider.loadTrips();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                "Unable to complete trip.",
          ),
        ),
      );
    }
  }

  //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer4<
        TripProvider,
        EmployeeProvider,
        DriverProvider,
        VehicleProvider>(
      builder: (
        context,
        tripProvider,
        employeeProvider,
        driverProvider,
        vehicleProvider,
        child,
      ) {
        List<TripModel> trips =
            List.from(
          tripProvider.trips,
        );

        //--------------------------------------------------
        // SEARCH
        //--------------------------------------------------

        if (_search.isNotEmpty) {
          trips = trips.where(
            (trip) {
              return trip.tripId
                      .toLowerCase()
                      .contains(
                        _search
                            .toLowerCase(),
                      ) ||
                  trip.pickupLocation
                      .toLowerCase()
                      .contains(
                        _search
                            .toLowerCase(),
                      ) ||
                  trip.destination
                      .toLowerCase()
                      .contains(
                        _search
                            .toLowerCase(),
                      );
            },
          ).toList();
        }

        //--------------------------------------------------
        // STATUS FILTER
        //--------------------------------------------------

        if (_statusFilter !=
            "All") {
          trips = trips
              .where(
                (trip) =>
                    trip.status ==
                    _statusFilter,
              )
              .toList();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Trip Management",
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                ),
                onPressed: () async {
                  await tripProvider
                      .refresh();
                },
              ),
            ],
          ),

          floatingActionButton:
              FloatingActionButton
                  .extended(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const AddTripScreen(),
                ),
              );

              if (!mounted) {
                return;
              }

              await tripProvider
                  .loadTrips();
            },
            icon: const Icon(
              Icons.add,
            ),
            label: const Text(
              "Add Trip",
            ),
          ),
                    body: RefreshIndicator(
            onRefresh: () async {
              await tripProvider.loadTrips();
            },
            child: Column(
              children: [
                //--------------------------------------------------
                // SEARCH
                //--------------------------------------------------

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search Trip...",
                      prefixIcon:
                          const Icon(Icons.search),
                      suffixIcon: _search.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(
                                Icons.clear,
                              ),
                              onPressed: () {
                                _searchController.clear();

                                setState(() {
                                  _search = "";
                                });
                              },
                            ),
                      border:
                          const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _search = value;
                      });
                    },
                  ),
                ),

                //--------------------------------------------------
                // STATUS FILTER
                //--------------------------------------------------

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _statusFilter,
                    decoration:
                        const InputDecoration(
                      labelText: "Status Filter",
                      border:
                          OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "All",
                        child: Text("All"),
                      ),
                      DropdownMenuItem(
                        value: "Pending",
                        child: Text("Pending"),
                      ),
                      DropdownMenuItem(
                        value: "Assigned",
                        child: Text("Assigned"),
                      ),
                      DropdownMenuItem(
                        value: "Started",
                        child: Text("Started"),
                      ),
                      DropdownMenuItem(
                        value: "Completed",
                        child: Text("Completed"),
                      ),
                      DropdownMenuItem(
                        value: "Cancelled",
                        child: Text("Cancelled"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _statusFilter =
                            value ?? "All";
                      });
                    },
                  ),
                ),

                const SizedBox(height: 12),

                //--------------------------------------------------
                // TRIP LIST
                //--------------------------------------------------

                Expanded(
                  child: trips.isEmpty
                      ? const Center(
                          child: Text(
                            "No Trips Found",
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              trips.length,
                          itemBuilder:
                              (context, index) {
                            final trip =
                                trips[index];

                            final EmployeeModel?
                                employee =
                                employeeProvider
                                    .getEmployeeById(
                              trip.employeeId,
                            );

                            final DriverModel?
                                driver =
                                driverProvider
                                    .getDriverById(
                              trip.driverId,
                            );

                            final VehicleModel?
                                vehicle =
                                vehicleProvider
                                    .getVehicleById(
                              trip.vehicleId,
                            );

                            return Card(
                              margin:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                                                            child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      _statusColor(
                                    trip.status,
                                  ),
                                  child: Icon(
                                    _statusIcon(
                                      trip.status,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),

                                title: Text(
                                  trip.tripId,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    const SizedBox(
                                      height: 6,
                                    ),

                                    Text(
                                      "Employee : ${employee?.name ?? '-'}",
                                    ),

                                    Text(
                                      "Driver : ${driver?.name ?? '-'}",
                                    ),

                                    Text(
                                      "Vehicle : ${vehicle?.vehicleNumber ?? '-'}",
                                    ),

                                    Text(
                                      "Pickup : ${trip.pickupLocation}",
                                    ),

                                    Text(
                                      "Destination : ${trip.destination}",
                                    ),

                                    Text(
                                      "Status : ${trip.status}",
                                      style: TextStyle(
                                        color:
                                            _statusColor(
                                          trip.status,
                                        ),
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                trailing:
                                    PopupMenuButton<
                                        String>(
                                  onSelected:
                                      (value) async {
                                    switch (value) {
                                      case "view":
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                TripDetailsScreen(
                                              trip:
                                                  trip,
                                            ),
                                          ),
                                        );
                                        break;

                                      case "edit":
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                AddTripScreen(
                                              trip:
                                                  trip,
                                            ),
                                          ),
                                        );

                                        if (mounted) {
                                          await tripProvider
                                              .loadTrips();
                                        }
                                        break;

                                      case "complete":
                                        await _completeTrip(
                                          trip,
                                        );
                                        break;

                                      case "delete":
                                        await _deleteTrip(
                                          trip,
                                        );
                                        break;
                                    }
                                  },
                                  itemBuilder:
                                      (context) => const [
                                    PopupMenuItem(
                                      value:
                                          "view",
                                      child: ListTile(
                                        leading:
                                            Icon(Icons
                                                .visibility),
                                        title: Text(
                                            "View"),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value:
                                          "edit",
                                      child: ListTile(
                                        leading:
                                            Icon(Icons
                                                .edit),
                                        title: Text(
                                            "Edit"),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value:
                                          "complete",
                                      child: ListTile(
                                        leading:
                                            Icon(Icons
                                                .check_circle),
                                        title: Text(
                                            "Complete"),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value:
                                          "delete",
                                      child: ListTile(
                                        leading:
                                            Icon(Icons
                                                .delete),
                                        title: Text(
                                            "Delete"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}