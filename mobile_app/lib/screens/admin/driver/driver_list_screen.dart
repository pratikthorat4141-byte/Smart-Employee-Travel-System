import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/driver_model.dart';
import '../../../providers/driver_provider.dart';
import 'add_driver_screen.dart';
import 'driver_details_screen.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DriverProvider>().loadDrivers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteDriver(DriverModel driver) async {
    final provider = context.read<DriverProvider>();

    final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete Driver"),
            content: Text(
              "Are you sure you want to delete ${driver.name}?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    await provider.deleteDriver(driver.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Driver deleted successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Driver Management"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text("Add Driver"),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddDriverScreen(),
                ),
              );

              provider.loadDrivers();
            },
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search Driver...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        provider.loadDrivers();
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: provider.searchDrivers,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.refresh,
                  child: provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : provider.drivers.isEmpty
                          ? const Center(
                              child: Text(
                                "No Drivers Found",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              itemCount: provider.drivers.length,
                              itemBuilder: (context, index) {
                                final driver =
                                    provider.drivers[index];

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        driver.name
                                            .substring(0, 1)
                                            .toUpperCase(),
                                      ),
                                    ),
                                    title: Text(driver.name),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "License : ${driver.licenseNumber}"),
                                        Text(
                                            "Mobile : ${driver.mobile}"),
                                      ],
                                    ),
                                    trailing:
                                        PopupMenuButton<String>(
                                      onSelected:
                                          (value) async {
                                        switch (value) {
                                          case "view":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    DriverDetailsScreen(
                                                  driver: driver,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "edit":
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    AddDriverScreen(
                                                  driver: driver,
                                                ),
                                              ),
                                            );

                                            provider.loadDrivers();
                                            break;

                                          case "delete":
                                            _deleteDriver(driver);
                                            break;
                                        }
                                      },
                                      itemBuilder: (_) => const [
                                        PopupMenuItem(
                                          value: "view",
                                          child: Row(
                                            children: [
                                              Icon(Icons.visibility),
                                              SizedBox(width: 10),
                                              Text("View Details"),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: "edit",
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit),
                                              SizedBox(width: 10),
                                              Text("Edit"),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: "delete",
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete),
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
              ),
            ],
          ),
        );
      },
    );
  }
}