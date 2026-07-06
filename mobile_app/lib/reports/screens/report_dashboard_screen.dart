import '../services/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/employee_provider.dart';
import '../../providers/driver_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/trip_provider.dart';

class ReportDashboardScreen extends StatelessWidget {
  const ReportDashboardScreen({super.key});

  Widget statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 15),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final employees =
        context.watch<EmployeeProvider>().employees;

    final drivers =
        context.watch<DriverProvider>().drivers;

    final vehicles =
        context.watch<VehicleProvider>().vehicles;

    final trips =
        context.watch<TripProvider>().trips;

    final completed = trips
        .where((e) => e.status == "Completed")
        .length;

    final pending = trips
        .where((e) => e.status == "Pending")
        .length;

    final ongoing = trips
        .where((e) => e.status == "Ongoing")
        .length;

    final cancelled = trips
        .where((e) => e.status == "Cancelled")
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports & Analytics"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [

            statCard(
              "Employees",
              employees.length.toString(),
              Icons.people,
              Colors.blue,
            ),

            statCard(
              "Drivers",
              drivers.length.toString(),
              Icons.drive_eta,
              Colors.green,
            ),

            statCard(
              "Vehicles",
              vehicles.length.toString(),
              Icons.directions_car,
              Colors.orange,
            ),

            statCard(
              "Trips",
              trips.length.toString(),
              Icons.route,
              Colors.deepPurple,
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Trip Status",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),
                        GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [

                statCard(
                  "Completed",
                  completed.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),

                statCard(
                  "Pending",
                  pending.toString(),
                  Icons.pending_actions,
                  Colors.orange,
                ),

                statCard(
                  "Ongoing",
                  ongoing.toString(),
                  Icons.directions_car,
                  Colors.blue,
                ),

                statCard(
                  "Cancelled",
                  cancelled.toString(),
                  Icons.cancel,
                  Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [

                    Icon(
                      Icons.analytics,
                      size: 60,
                      color: Colors.teal,
                    ),

                    SizedBox(height: 15),

                    Text(
                      "System Summary",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "This dashboard provides an overview of Employees, Drivers, Vehicles and Trips along with current trip status statistics.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () async {
  await PdfService.generateReport(
    employees: employees,
    drivers: drivers,
    vehicles: vehicles,
    trips: trips,
  );

  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        "PDF Generated Successfully",
      ),
    ),
  );
},
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text(
                  "EXPORT REPORT",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}