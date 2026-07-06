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

class EditTripScreen extends StatefulWidget {
  final Trip trip;

  const EditTripScreen({
    super.key,
    required this.trip,
  });

  @override
  State<EditTripScreen> createState() => _EditTripScreenState();
}

class _EditTripScreenState extends State<EditTripScreen> {
  final _formKey = GlobalKey<FormState>();

  late String employee;
  late String driver;
  late String vehicle;

  late TextEditingController sourceController;
  late TextEditingController destinationController;

  late String status;

  final List<String> statusList = [
    "Pending",
    "Ongoing",
    "Completed",
    "Cancelled",
  ];

  @override
  void initState() {
    super.initState();

    employee = widget.trip.employee;
    driver = widget.trip.driver;
    vehicle = widget.trip.vehicle;
    status = widget.trip.status;

    sourceController =
        TextEditingController(text: widget.trip.source);

    destinationController =
        TextEditingController(text: widget.trip.destination);
  }

  @override
  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  Future<void> updateTrip() async {
    if (!_formKey.currentState!.validate()) return;

    final trip = widget.trip.copyWith(
      employee: employee,
      driver: driver,
      vehicle: vehicle,
      source: sourceController.text.trim(),
      destination: destinationController.text.trim(),
      status: status,
    );

    await context.read<TripProvider>().updateTrip(trip);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Trip Updated Successfully"),
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
        title: const Text("Edit Trip"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor:
                    Colors.deepPurple.withOpacity(.15),
                child: const Icon(
                  Icons.edit_road,
                  size: 45,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 25),

              DropdownButtonFormField<String>(
                value: employee,
                decoration: const InputDecoration(
                  labelText: "Employee",
                  border: OutlineInputBorder(),
                ),
                items: employees
                    .map<DropdownMenuItem<String>>(
                      (Employee e) =>
                          DropdownMenuItem<String>(
                        value: e.name,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    employee = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: driver,
                decoration: const InputDecoration(
                  labelText: "Driver",
                  border: OutlineInputBorder(),
                ),
                items: drivers
                    .map<DropdownMenuItem<String>>(
                      (Driver d) =>
                          DropdownMenuItem<String>(
                        value: d.name,
                        child: Text(d.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    driver = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: vehicle,
                decoration: const InputDecoration(
                  labelText: "Vehicle",
                  border: OutlineInputBorder(),
                ),
                items: vehicles
                    .map<DropdownMenuItem<String>>(
                      (Vehicle v) =>
                          DropdownMenuItem<String>(
                        value: v.vehicleNo,
                        child: Text(v.vehicleNo),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    vehicle = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: sourceController,
                decoration: const InputDecoration(
                  labelText: "Source",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? "Enter Source"
                        : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: destinationController,
                decoration: const InputDecoration(
                  labelText: "Destination",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? "Enter Destination"
                        : null,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(
                  labelText: "Trip Status",
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

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: updateTrip,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "UPDATE TRIP",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text("CANCEL"),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    "Trip Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Trip ID : ${widget.trip.id}",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}