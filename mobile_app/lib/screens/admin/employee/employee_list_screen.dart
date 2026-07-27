import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/employee_model.dart';
import '../../../providers/employee_provider.dart';
import 'add_employee_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() =>
      _EmployeeListScreenState();
}

class _EmployeeListScreenState
    extends State<EmployeeListScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<EmployeeProvider>().loadEmployees();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteEmployee(EmployeeModel employee) async {
    final provider = context.read<EmployeeProvider>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Employee"),
        content: Text(
          "Delete ${employee.name} ?",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (result != true) return;

    await provider.deleteEmployee(employee.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Employee Deleted"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Employees"),
            centerTitle: true,
          ),

          floatingActionButton:
              FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text("Add Employee"),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const AddEmployeeScreen(),
                ),
              );

              provider.loadEmployees();
            },
          ),

          body: Column(
            children: [

              Padding(
                padding:
                    const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search Employee",
                    prefixIcon:
                        const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        provider.loadEmployees();
                      },
                    ),
                    border:
                        const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    provider.searchEmployees(value);
                  },
                ),
              ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      provider.refresh(),
                  child: provider.isLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator(),
                        )
                      : provider.employees.isEmpty
                          ? const Center(
                              child: Text(
                                  "No Employees"),
                            )
                          : ListView.builder(
                              itemCount: provider
                                  .employees.length,
                              itemBuilder:
                                  (context, index) {
                                final employee =
                                    provider
                                            .employees[
                                        index];

                                return Card(
                                  margin:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    leading:
                                        CircleAvatar(
                                      child: Text(
                                        employee.name
                                            .substring(
                                                0, 1)
                                            .toUpperCase(),
                                      ),
                                    ),
                                    title: Text(
                                        employee.name),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(employee
                                            .department),
                                        Text(employee
                                            .mobile),
                                      ],
                                    ),
                                    trailing:
                                        PopupMenuButton(
                                      onSelected:
                                          (value) async {
                                        if (value ==
                                            "edit") {
                                          await Navigator
                                              .push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  AddEmployeeScreen(
                                                employee:
                                                    employee,
                                              ),
                                            ),
                                          );

                                          provider
                                              .loadEmployees();
                                        }

                                        if (value ==
                                            "delete") {
                                          _deleteEmployee(
                                              employee);
                                        }
                                      },
                                      itemBuilder:
                                          (context) =>
                                              const [
                                        PopupMenuItem(
                                          value:
                                              "edit",
                                          child:
                                              Text(
                                                  "Edit"),
                                        ),
                                        PopupMenuItem(
                                          value:
                                              "delete",
                                          child:
                                              Text(
                                                  "Delete"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}