import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/vehicle_provider.dart';
import 'add_vehicle_screen.dart';
import 'edit_vehicle_screen.dart';
import 'vehicle_details_screen.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key});

  Widget statsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(15),
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
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
    return Consumer<VehicleProvider>(
      builder: (context, provider, child) {

        final vehicles = provider.vehicles;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Vehicles (${vehicles.length})",
            ),
            centerTitle: true,
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),

          floatingActionButton:
              FloatingActionButton.extended(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text("Add Vehicle"),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const AddVehicleScreen(),
                ),
              );

              if (context.mounted) {
                provider.loadVehicles();
              }
            },
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              await provider.loadVehicles();
            },

            child: Column(
              children: [

                Padding(
                  padding:
                      const EdgeInsets.all(15),
                  child: statsCard(
                    "Total Vehicles",
                    vehicles.length.toString(),
                    Icons.directions_car,
                    Colors.orange,
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: TextField(
                    onChanged: (value) async {
                      await provider
                          .searchVehicle(value);
                    },
                    decoration: InputDecoration(
                      hintText:
                          "Search Vehicle...",
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      filled: true,
                      fillColor:
                          Colors.grey.shade100,
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: vehicles.isEmpty
                      ? ListView(
                          children: const [

                            SizedBox(
                              height: 160,
                            ),

                            Icon(
                              Icons
                                  .directions_car_outlined,
                              size: 90,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 15),

                            Center(
                              child: Text(
                                "No Vehicles Found",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ],
                        )

                      : ListView.builder(

                          itemCount:
                              vehicles.length,

                          itemBuilder:
                              (context, index) {

                            final vehicle =
                                vehicles[index];

                            return Card(
                              margin:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),

                              elevation: 4,

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            15),
                              ),

                              child: ListTile(

                                leading:
                                    CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                      Colors.orange,

                                  child: const Icon(
                                    Icons
                                        .directions_car,
                                    color:
                                        Colors.white,
                                  ),
                                ),

                                title: Text(
                                  vehicle.vehicleNo,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [

                                    const SizedBox(
                                        height: 5),

                                    Text(
                                        vehicle.type),

                                    const SizedBox(
                                        height: 5),

                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal:
                                            10,
                                        vertical: 4,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: Colors
                                            .orange
                                            .withOpacity(
                                                .12),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    20),
                                      ),
                                      child: Text(
                                        "Capacity : ${vehicle.capacity}",
                                        style:
                                            const TextStyle(
                                          color: Colors
                                              .orange,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
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
                                          VehicleDetailsScreen(
                                        vehicle:
                                            vehicle,
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
                                              VehicleDetailsScreen(
                                            vehicle: vehicle,
                                          ),
                                        ),
                                      );
                                    }

                                    if (value == "edit") {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EditVehicleScreen(
                                            vehicle: vehicle,
                                          ),
                                        ),
                                      );

                                      if (context.mounted) {
                                        provider.loadVehicles();
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
                                              const Text("Delete Vehicle"),
                                          content: Text(
                                            "Delete ${vehicle.vehicleNo} ?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child:
                                                  const Text("Cancel"),
                                            ),
                                            ElevatedButton(
                                              style:
                                                  ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red,
                                                foregroundColor:
                                                    Colors.white,
                                              ),
                                              onPressed: () async {
                                                await provider
                                                    .deleteVehicle(
                                                  vehicle.id!,
                                                );

                                                if (!context.mounted) {
                                                  return;
                                                }

                                                Navigator.pop(context);

                                                ScaffoldMessenger.of(
                                                        context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    content: Text(
                                                      "${vehicle.vehicleNo} deleted successfully",
                                                    ),
                                                  ),
                                                );
                                              },
                                              child:
                                                  const Text("Delete"),
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