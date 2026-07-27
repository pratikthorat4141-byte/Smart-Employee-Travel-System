import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/driver_model.dart';
import '../../models/employee_model.dart';
import '../../models/trip_model.dart';
import '../../models/vehicle_model.dart';

import '../../providers/assignment_provider.dart';

class AssignTripScreen extends StatefulWidget {
  final TripModel? trip;

  final List<EmployeeModel> employees;

  final List<DriverModel> drivers;

  final List<VehicleModel> vehicles;

  const AssignTripScreen({
    super.key,
    this.trip,
    required this.employees,
    required this.drivers,
    required this.vehicles,
  });

  @override
  State<AssignTripScreen> createState() =>
      _AssignTripScreenState();
}

class _AssignTripScreenState
    extends State<AssignTripScreen> {
  DriverModel? selectedDriver;

  VehicleModel? selectedVehicle;

  final List<EmployeeModel> selectedEmployees = [];

  @override
  Widget build(BuildContext context) {
    final provider =
        context.read<AssignmentProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Trip"),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Text(
              "Driver",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<
                DriverModel>(
              value: selectedDriver,
              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),
              ),
              items: widget.drivers
                  .map(
                    (driver) =>
                        DropdownMenuItem(
                      value: driver,
                      child:
                          Text(driver.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDriver =
                      value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Vehicle",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<
                VehicleModel>(
              value: selectedVehicle,
              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),
              ),
              items: widget.vehicles
                  .map(
                    (vehicle) =>
                        DropdownMenuItem(
                      value: vehicle,
                      child: Text(
                        vehicle
                            .vehicleNumber,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedVehicle =
                      value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Employees",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...widget.employees.map(
              (employee) {
                final selected =
                    selectedEmployees
                        .contains(
                            employee);

                return CheckboxListTile(
                  title:
                      Text(employee.name),
                  subtitle: Text(
                      employee.department),
                  value: selected,
                  onChanged: (value) {
                    setState(() {
                      if (value ==
                          true) {
                        selectedEmployees
                            .add(
                                employee);
                      } else {
                        selectedEmployees
                            .remove(
                                employee);
                      }
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child:
                  FilledButton.icon(
                icon: const Icon(
                  Icons.save,
                ),
                label: const Text(
                  "Assign Trip",
                ),
                onPressed: () async {
                  if (widget.trip ==
                          null ||
                      selectedDriver ==
                          null ||
                      selectedVehicle ==
                          null ||
                      selectedEmployees
                          .isEmpty) {
                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Select all required fields.",
                        ),
                      ),
                    );
                    return;
                  }

                  await provider
                      .assignTrip(
                    trip: widget.trip!,
                    driver:
                        selectedDriver!,
                    vehicle:
                        selectedVehicle!,
                    employees:
                        selectedEmployees,
                  );

                  if (!mounted) return;

                  Navigator.pop(
                      context);

                  ScaffoldMessenger.of(
                          context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Trip Assigned Successfully",
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
  }
}