import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/trip_provider.dart';
import '../../trip/screens/trip_details_screen.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TripProvider>();
    final trips = provider.trips;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Trips"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: trips.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.route_outlined,
                    size: 90,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No Trips Assigned",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: trips.length,
              itemBuilder: (context, index) {

                final trip = trips[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          statusColor(trip.status),
                      child: const Icon(
                        Icons.route,
                        color: Colors.white,
                      ),
                    ),

                    title: Text(
                      "${trip.source} → ${trip.destination}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        const SizedBox(height: 5),

                        Text(
                          "Driver : ${trip.driver}",
                        ),

                        Text(
                          "Vehicle : ${trip.vehicle}",
                        ),

                        const SizedBox(height: 5),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor(
                              trip.status,
                            ).withOpacity(.15),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            trip.status,
                            style: TextStyle(
                              color: statusColor(
                                trip.status,
                              ),
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    isThreeLine: true,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TripDetailsScreen(
                            trip: trip,
                          ),
                        ),
                      );
                    },
                                        trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                  ),
                );
              },
            ),
    );
  }
}