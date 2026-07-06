import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/trip_model.dart';
import '../../providers/trip_provider.dart';
import 'edit_trip_screen.dart';

class TripDetailsScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailsScreen({
    super.key,
    required this.trip,
  });

  Color statusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Ongoing":
        return Colors.orange;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget infoTile(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Details"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.all(25),

                child: Column(
                  children: [

                    CircleAvatar(
                      radius: 45,
                      backgroundColor:
                          statusColor(trip.status),

                      child: const Icon(
                        Icons.route,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "${trip.source} → ${trip.destination}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor(
                          trip.status,
                        ).withOpacity(.15),
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: Text(
                        trip.status,
                        style: TextStyle(
                          color: statusColor(
                            trip.status,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            infoTile(
              Icons.person,
              "Employee",
              trip.employee,
              Colors.blue,
            ),

            infoTile(
              Icons.drive_eta,
              "Driver",
              trip.driver,
              Colors.green,
            ),

            infoTile(
              Icons.directions_car,
              "Vehicle",
              trip.vehicle,
              Colors.orange,
            ),

            infoTile(
              Icons.location_on,
              "Source",
              trip.source,
              Colors.red,
            ),

            infoTile(
              Icons.flag,
              "Destination",
              trip.destination,
              Colors.purple,
            ),

            const SizedBox(height: 25),
                        SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text(
                  "EDIT TRIP",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditTripScreen(
                        trip: trip,
                      ),
                    ),
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text(
                  "DELETE TRIP",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                      title: const Text("Delete Trip"),
                      content: Text(
                        "Are you sure you want to delete this trip?\n\n${trip.source} → ${trip.destination}",
                      ),
                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {

                            await context
                                .read<TripProvider>()
                                .deleteTrip(trip.id!);

                            if (!context.mounted) return;

                            Navigator.pop(context);
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "Trip Deleted Successfully",
                                ),
                              ),
                            );
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      statusColor(trip.status),
                  child: const Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Trip Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(trip.status),
                trailing: Icon(
                  Icons.check_circle,
                  color: statusColor(trip.status),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(
                    Icons.assignment,
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
                  "Trip ID : ${trip.id}",
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}