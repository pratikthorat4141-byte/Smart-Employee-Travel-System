import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/trip_model.dart';
import '../../providers/trip_provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/driver_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../employee_user/models/employee_model.dart';
import '../../driver/models/driver_model.dart';
import '../../vehicle/models/vehicle_model.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();

  String? employee;
  String? driver;
  String? vehicle;

  final sourceController = TextEditingController();
  final destinationController = TextEditingController();

  String status = "Pending";

  final List<String> statusList = const [
    "Pending",
    "Ongoing",
    "Completed",
    "Cancelled",
  ];

  @override
  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  Future<void> saveTrip() async {
    if (!_formKey.currentState!.validate()) return;

    if (employee == null || driver == null || vehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Select Employee, Driver and Vehicle"),
        ),
      );
      return;
    }

    final trip = Trip(
      employee: employee!,
      driver: driver!,
      vehicle: vehicle!,
      source: sourceController.text.trim(),
      destination: destinationController.text.trim(),
      status: status,
    );

    await context.read<TripProvider>().addTrip(trip);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Trip Created Successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<Employee> employees =
        context.watch<EmployeeProvider>().employees;

    final List<Driver> drivers =
        context.watch<DriverProvider>().drivers;

    final List<Vehicle> vehicles =
        context.watch<VehicleProvider>().vehicles;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Trip"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              DropdownButtonFormField<String>(
                value: employee,
                decoration: const InputDecoration(
                  labelText: "Select Employee",
                  border: OutlineInputBorder(),
                ),
                items: employees
                    .map<DropdownMenuItem<String>>(
                      (Employee e) => DropdownMenuItem<String>(
                        value: e.name,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    employee = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: driver,
                decoration: const InputDecoration(
                  labelText: "Select Driver",
                  border: OutlineInputBorder(),
                ),
                items: drivers
                    .map<DropdownMenuItem<String>>(
                      (Driver d) => DropdownMenuItem<String>(
                        value: d.name,
                        child: Text(d.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    driver = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: vehicle,
                decoration: const InputDecoration(
                  labelText: "Select Vehicle",
                  border: OutlineInputBorder(),
                ),
                items: vehicles
                    .map<DropdownMenuItem<String>>(
                      (Vehicle v) => DropdownMenuItem<String>(
                        value: v.vehicleNo,
                        child: Text(v.vehicleNo),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    vehicle = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: sourceController,
                decoration: const InputDecoration(
                  labelText: "Source",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter Source" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: destinationController,
                decoration: const InputDecoration(
                  labelText: "Destination",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter Destination" : null,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: statusList
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveTrip,
                  child: const Text("CREATE TRIP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}