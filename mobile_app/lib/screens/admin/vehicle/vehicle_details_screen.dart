import 'package:flutter/material.dart';

import '../../../models/vehicle_model.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicle,
  });

  Widget buildTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.directions_car,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              vehicle.vehicleName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            buildTile(
              Icons.confirmation_number,
              "Vehicle Number",
              vehicle.vehicleNumber,
            ),

            buildTile(
              Icons.drive_eta,
              "Vehicle Name",
              vehicle.vehicleName,
            ),

            buildTile(
              Icons.category,
              "Vehicle Type",
              vehicle.vehicleType,
            ),

            buildTile(
              Icons.event_seat,
              "Seating Capacity",
              vehicle.seatingCapacity.toString(),
            ),

            buildTile(
              Icons.local_gas_station,
              "Fuel Type",
              vehicle.fuelType,
            ),

            buildTile(
              Icons.calendar_today,
              "Registration Date",
              vehicle.registrationDate,
            ),

            buildTile(
              Icons.calendar_month,
              "Insurance Expiry",
              vehicle.insuranceExpiry,
            ),

            buildTile(
              vehicle.isAvailable
                  ? Icons.check_circle
                  : Icons.cancel,
              "Availability",
              vehicle.isAvailable
                  ? "Available"
                  : "Unavailable",
            ),

            buildTile(
              vehicle.isActive
                  ? Icons.verified
                  : Icons.block,
              "Status",
              vehicle.isActive
                  ? "Active"
                  : "Inactive",
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}