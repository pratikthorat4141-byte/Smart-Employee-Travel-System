import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/employee_provider.dart';
import 'add_employee_screen.dart';
import 'employee_details_screen.dart';
import 'edit_employee_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  Widget infoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        final employees = provider.employees;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Employees (${employees.length})",
            ),
            centerTitle: true,
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),

          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text("Add Employee"),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEmployeeScreen(),
                ),
              );

              if (context.mounted) {
                provider.loadEmployees();
              }
            },
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              await provider.loadEmployees();
            },

            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(15),
                  child: infoCard(
                    "Total Employees",
                    employees.length.toString(),
                    Icons.people,
                    Colors.indigo,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: TextField(
                    onChanged: (value) async {
                      await provider.searchEmployee(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Search employee...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(
                        Icons.person_search,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: employees.isEmpty
                      ? ListView(
                          children: const [

                            SizedBox(height: 150),

                            Icon(
                              Icons.people_outline,
                              size: 90,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 15),

                            Center(
                              child: Text(
                                "No Employees Found",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            Center(
                              child: Text(
                                "Add Employee to continue",
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: employees.length,
                          itemBuilder: (context, index) {

                            final employee =
                                employees[index];

                            return Card(
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),

                              elevation: 5,

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  15,
                                ),
                              ),

                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.all(
                                  12,
                                ),

                                leading: CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                      Colors.indigo,

                                  child: Text(
                                    employee.name[0]
                                        .toUpperCase(),

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),

                                title: Text(
                                  employee.name,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.only(
                                    top: 6,
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      Text(
                                        employee.email,
                                      ),

                                      const SizedBox(
                                        height: 4,
                                      ),

                                      Container(
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                                                                decoration:
                                            BoxDecoration(
                                          color: Colors
                                              .indigo
                                              .withOpacity(
                                                  .12),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      20),
                                        ),
                                        child: Text(
                                          employee.department,
                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.indigo,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EmployeeDetailsScreen(
                                        employee:
                                            employee,
                                      ),
                                    ),
                                  );
                                },

                                trailing:
                                    PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == "view") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EmployeeDetailsScreen(
                                            employee:
                                                employee,
                                          ),
                                        ),
                                      );
                                    }

                                    if (value == "edit") {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EditEmployeeScreen(
                                            employee:
                                                employee,
                                          ),
                                        ),
                                      );

                                      if (context
                                          .mounted) {
                                        provider
                                            .loadEmployees();
                                      }
                                    }

                                    if (value ==
                                        "delete") {
                                      showDialog(
                                        context: context,
                                        builder: (_) =>
                                            AlertDialog(
                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    15),
                                          ),
                                          title:
                                              const Text(
                                            "Delete Employee",
                                          ),
                                          content: Text(
                                            "Delete ${employee.name} ?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () {
                                                Navigator.pop(
                                                    context);
                                              },
                                              child:
                                                  const Text(
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
                                                    .deleteEmployee(
                                                  employee
                                                      .id!,
                                                );

                                                if (!context
                                                    .mounted)
                                                  return;

                                                Navigator.pop(
                                                    context);

                                                ScaffoldMessenger.of(
                                                        context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    content:
                                                        Text(
                                                      "${employee.name} deleted successfully",
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
                                  itemBuilder: (context) =>
                                      const [
                                    PopupMenuItem(
                                      value: "view",
                                      child: Row(
                                        children: [
                                          Icon(Icons
                                              .visibility),
                                          SizedBox(
                                              width: 10),
                                          Text("View"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: "edit",
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit,
                                              color: Colors
                                                  .blue),
                                          SizedBox(
                                              width: 10),
                                          Text("Edit"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: "delete",
                                      child: Row(
                                        children: [
                                          Icon(Icons
                                                  .delete,
                                              color: Colors
                                                  .red),
                                          SizedBox(
                                              width: 10),
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