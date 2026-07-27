import 'package:flutter/material.dart';

import '../../models/assignment_model.dart';

class AssignmentDetailsScreen extends StatelessWidget {
  final AssignmentModel assignment;

  const AssignmentDetailsScreen({
    super.key,
    required this.assignment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignment Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _title("Assignment Information"),

                const SizedBox(height: 20),

                _tile(
                  "Assignment ID",
                  assignment.assignmentId,
                  Icons.assignment,
                ),

                _tile(
                  "Trip ID",
                  assignment.tripId.toString(),
                  Icons.route,
                ),

                _tile(
                  "Driver ID",
                  assignment.driverId.toString(),
                  Icons.person,
                ),

                _tile(
                  "Vehicle ID",
                  assignment.vehicleId.toString(),
                  Icons.directions_car,
                ),

                _tile(
                  "Employees",
                  assignment.employeeIds.join(", "),
                  Icons.people,
                ),

                _tile(
                  "Assignment Date",
                  assignment.assignmentDate,
                  Icons.calendar_today,
                ),

                _tile(
                  "Status",
                  assignment.status,
                  Icons.flag,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.print),
                    label: const Text(
                      "Print / Export PDF",
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "PDF Module Coming Next",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _tile(
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}