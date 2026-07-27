import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/assignment_provider.dart';
import '../../widgets/loading_widget.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() =>
      _AssignmentListScreenState();
}

class _AssignmentListScreenState
    extends State<AssignmentListScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<AssignmentProvider>()
          .loadAssignments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Trip Assignments",
            ),
            centerTitle: true,
          ),

          floatingActionButton:
              FloatingActionButton.extended(
            onPressed: () {

            },
            icon: const Icon(Icons.add),
            label: const Text("Assign"),
          ),

          body: provider.isLoading
              ? const LoadingWidget(
                  message:
                      "Loading Assignments...",
                )
              : provider.assignments.isEmpty
                  ? const Center(
                      child: Text(
                        "No Assignments Found",
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh:
                          provider.refresh,
                      child: ListView.builder(
                        itemCount: provider
                            .assignments.length,
                        itemBuilder:
                            (context, index) {
                          final assignment =
                              provider
                                      .assignments[
                                  index];

                          return Card(
                            margin:
                                const EdgeInsets
                                    .all(10),

                            child: ListTile(
                              leading:
                                  const CircleAvatar(
                                child: Icon(
                                  Icons
                                      .assignment,
                                ),
                              ),

                              title: Text(
                                assignment
                                    .assignmentId,
                              ),

                              subtitle:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [

                                  Text(
                                    "Trip ID : ${assignment.tripId}",
                                  ),

                                  Text(
                                    "Driver ID : ${assignment.driverId}",
                                  ),

                                  Text(
                                    "Vehicle ID : ${assignment.vehicleId}",
                                  ),

                                  Text(
                                    "Employees : ${assignment.employeeIds.length}",
                                  ),

                                  Text(
                                    "Status : ${assignment.status}",
                                  ),
                                ],
                              ),

                              trailing:
                                  PopupMenuButton<
                                      String>(
                                onSelected:
                                    (value) async {
                                  switch (
                                      value) {
                                    case "delete":

                                      await provider
                                          .deleteAssignment(
                                        assignment
                                            .id!,
                                      );

                                      if (!mounted)
                                        return;

                                      ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text(
                                            "Assignment Deleted",
                                          ),
                                        ),
                                      );

                                      break;

                                    case "complete":

                                      provider
                                          .updateStatus(
                                        id: assignment
                                            .id!,
                                        status:
                                            "Completed",
                                      );

                                      break;
                                  }
                                },

                                itemBuilder:
                                    (_) => const [

                                  PopupMenuItem(
                                    value:
                                        "complete",
                                    child: Text(
                                      "Complete",
                                    ),
                                  ),

                                  PopupMenuItem(
                                    value:
                                        "delete",
                                    child: Text(
                                      "Delete",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        );
      },
    );
  }
}