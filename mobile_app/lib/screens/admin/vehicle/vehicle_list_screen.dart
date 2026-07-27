import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/vehicle_model.dart';
import '../../../providers/vehicle_provider.dart';
import 'add_vehicle_screen.dart';
import 'vehicle_details_screen.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<VehicleProvider>().loadVehicles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteVehicle(VehicleModel vehicle) async {
    final provider = context.read<VehicleProvider>();

    final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Delete Vehicle"),
            content: Text(
              "Delete ${vehicle.vehicleNumber} ?",
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
        ) ??
        false;

    if (!confirm) return;

    await provider.deleteVehicle(vehicle.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Vehicle Deleted Successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Vehicle Management"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text("Add Vehicle"),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddVehicleScreen(),
                ),
              );

              provider.loadVehicles();
            },
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search Vehicle",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        provider.loadVehicles();
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: provider.searchVehicles,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.refresh,
                  child: provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : provider.vehicles.isEmpty
                          ? const Center(
                              child: Text("No Vehicles Found"),
                            )
                          : ListView.builder(
                              itemCount: provider.vehicles.length,
                              itemBuilder: (context, index) {
                                final vehicle =
                                    provider.vehicles[index];

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.directions_car),
                                    ),
                                    title: Text(vehicle.vehicleNumber),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(vehicle.vehicleName),
                                        Text(vehicle.vehicleType),
                                        Text(
                                            "Seats : ${vehicle.seatingCapacity}"),
                                      ],
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (value) async {
                                        switch (value) {
                                          case "view":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    VehicleDetailsScreen(
                                                  vehicle: vehicle,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "edit":
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    AddVehicleScreen(
                                                  vehicle: vehicle,
                                                ),
                                              ),
                                            );

                                            provider.loadVehicles();
                                            break;

                                          case "delete":
                                            _deleteVehicle(vehicle);
                                            break;
                                        }
                                      },
                                      itemBuilder: (_) => const [
                                        PopupMenuItem(
                                          value: "view",
                                          child: Text("View Details"),
                                        ),
                                        PopupMenuItem(
                                          value: "edit",
                                          child: Text("Edit"),
                                        ),
                                        PopupMenuItem(
                                          value: "delete",
                                          child: Text("Delete"),
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