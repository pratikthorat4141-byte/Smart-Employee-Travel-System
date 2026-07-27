import 'package:flutter/material.dart';

import '../../../models/trip_model.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripModel trip;

  const TripDetailsScreen({
    super.key,
    required this.trip,
  });

  Widget buildTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ),
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
        title: const Text("Trip Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.route,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              trip.tripId,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            buildTile(
              Icons.confirmation_number,
              "Trip ID",
              trip.tripId,
            ),

            buildTile(
              Icons.person,
              "Employee ID",
              trip.employeeId.toString(),
            ),

            buildTile(
              Icons.badge,
              "Driver ID",
              trip.driverId.toString(),
            ),

            buildTile(
              Icons.directions_car,
              "Vehicle ID",
              trip.vehicleId.toString(),
            ),

            buildTile(
              Icons.place,
              "Pickup Location",
              trip.pickupLocation,
            ),

            buildTile(
              Icons.location_on,
              "Destination",
              trip.destination,
            ),

            buildTile(
              Icons.calendar_today,
              "Trip Date",
              trip.tripDate,
            ),

            buildTile(
              Icons.access_time,
              "Trip Time",
              trip.tripTime,
            ),

            buildTile(
              Icons.route,
              "Distance",
              "${trip.totalDistance} KM",
            ),

            buildTile(
              Icons.flag,
              "Status",
              trip.status,
            ),

            buildTile(
              Icons.note,
              "Remarks",
              trip.remarks.isEmpty
                  ? "No Remarks"
                  : trip.remarks,
            ),

            buildTile(
              Icons.schedule,
              "Created At",
              trip.createdAt,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}