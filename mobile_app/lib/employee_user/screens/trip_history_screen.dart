import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/trip_provider.dart';
import '../../trip/screens/trip_details_screen.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  Color statusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    final trips = context
        .watch<TripProvider>()
        .trips
        .where(
          (trip) =>
              trip.status == "Completed" ||
              trip.status == "Cancelled",
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip History"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: trips.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.history,
                    size: 90,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "No Trip History",
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
                  margin:
                      const EdgeInsets.only(bottom: 15),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),

                  child: ListTile(

                    leading: CircleAvatar(
                      backgroundColor:
                          statusColor(trip.status),
                      child: Icon(
                        trip.status == "Completed"
                            ? Icons.check
                            : Icons.cancel,
                        color: Colors.white,
                      ),
                    ),

                    title: Text(
                      "${trip.source} → ${trip.destination}",
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
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
                                BorderRadius.circular(
                                    20),
                          ),
                          child: Text(
                            trip.status,
                            style: TextStyle(
                              color: statusColor(
                                  trip.status),
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
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              },
            ),
    );
  }
}