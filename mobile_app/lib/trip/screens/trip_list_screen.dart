import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/trip_provider.dart';
import 'add_trip_screen.dart';
import 'edit_trip_screen.dart';
import 'trip_details_screen.dart';

class TripListScreen extends StatelessWidget {
  const TripListScreen({super.key});

  Widget statsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title),
            ],
          ),
        ],
      ),
    );
  }

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
    return Consumer<TripProvider>(
      builder: (context, provider, child) {
        final trips = provider.trips;

        return Scaffold(
          appBar: AppBar(
            title: Text("Trips (${trips.length})"),
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),

          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text("New Trip"),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddTripScreen(),
                ),
              );

              if (context.mounted) {
                provider.loadTrips();
              }
            },
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              await provider.loadTrips();
            },

            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(15),
                  child: statsCard(
                    "Total Trips",
                    trips.length.toString(),
                    Icons.route,
                    Colors.deepPurple,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    onChanged: (value) async {
                      await provider.searchTrip(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Search Trip...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: trips.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 160),
                            Icon(
                              Icons.route_outlined,
                              size: 90,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 15),
                            Center(
                              child: Text(
                                "No Trips Found",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: trips.length,
                          itemBuilder: (context, index) {

                            final trip = trips[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
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
                                      "Employee : ${trip.employee}",
                                    ),

                                    Text(
                                      "Driver : ${trip.driver}",
                                    ),

                                    Text(
                                      "Vehicle : ${trip.vehicle}",
                                    ),

                                    const SizedBox(height: 6),

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor(
                                                trip.status)
                                            .withOpacity(.15),
                                        borderRadius:
                                            BorderRadius.circular(20),
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
                                                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == "view") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              TripDetailsScreen(
                                            trip: trip,
                                          ),
                                        ),
                                      );
                                    }

                                    if (value == "edit") {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EditTripScreen(
                                            trip: trip,
                                          ),
                                        ),
                                      );

                                      if (context.mounted) {
                                        provider.loadTrips();
                                      }
                                    }

                                    if (value == "delete") {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          title:
                                              const Text("Delete Trip"),
                                          content: Text(
                                            "Delete trip from ${trip.source} to ${trip.destination} ?",
                                          ),
                                          actions: [

                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context);
                                              },
                                              child: const Text(
                                                "Cancel",
                                              ),
                                            ),

                                            ElevatedButton(
                                              style:
                                                  ElevatedButton
                                                      .styleFrom(
                                                backgroundColor:
                                                    Colors.red,
                                                foregroundColor:
                                                    Colors.white,
                                              ),
                                              onPressed:
                                                  () async {
                                                await provider
                                                    .deleteTrip(
                                                  trip.id!,
                                                );

                                                if (!context
                                                    .mounted) {
                                                  return;
                                                }

                                                Navigator.pop(
                                                    context);

                                                ScaffoldMessenger.of(
                                                        context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    content: Text(
                                                      "Trip Deleted Successfully",
                                                    ),
                                                  ),
                                                );
                                              },
                                              child:
                                                  const Text(
                                                "Delete",
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => const [

                                    PopupMenuItem(
                                      value: "view",
                                      child: Row(
                                        children: [
                                          Icon(Icons.visibility),
                                          SizedBox(width: 10),
                                          Text("View"),
                                        ],
                                      ),
                                    ),

                                    PopupMenuItem(
                                      value: "edit",
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(width: 10),
                                          Text("Edit"),
                                        ],
                                      ),
                                    ),

                                    PopupMenuItem(
                                      value: "delete",
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 10),
                                          Text("Delete"),
                                        ],
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