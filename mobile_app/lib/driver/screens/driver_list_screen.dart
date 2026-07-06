import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/driver_provider.dart';
import 'add_driver_screen.dart';
import 'driver_details_screen.dart';
import 'edit_driver_screen.dart';

class DriverListScreen extends StatelessWidget {
  const DriverListScreen({super.key});

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
    return Consumer<DriverProvider>(
      builder: (context, provider, child) {
        final drivers = provider.drivers;

        return Scaffold(
          appBar: AppBar(
            title: Text("Drivers (${drivers.length})"),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),

          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text("Add Driver"),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddDriverScreen(),
                ),
              );

              if (context.mounted) {
                provider.loadDrivers();
              }
            },
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              await provider.loadDrivers();
            },

            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(15),
                  child: infoCard(
                    "Total Drivers",
                    drivers.length.toString(),
                    Icons.drive_eta,
                    Colors.green,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    onChanged: (value) async {
                      await provider.searchDriver(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Search Driver...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.person_search),
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
                  child: drivers.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 150),
                            Icon(
                              Icons.drive_eta_outlined,
                              size: 90,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 15),
                            Center(
                              child: Text(
                                "No Drivers Found",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                "Add Driver to continue",
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: drivers.length,
                          itemBuilder: (context, index) {

                            final driver = drivers[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.all(12),

                                leading: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.green,
                                  child: Text(
                                    driver.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                title: Text(
                                  driver.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    const SizedBox(height: 6),

                                    Text(driver.phone),

                                    const SizedBox(height: 5),

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green
                                            .withOpacity(.12),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        driver.licenseNo,
                                        style: const TextStyle(
                                          color: Colors.green,
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
                                          DriverDetailsScreen(
                                        driver: driver,
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
                                              DriverDetailsScreen(
                                            driver: driver,
                                          ),
                                        ),
                                      );
                                    }

                                    if (value == "edit") {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EditDriverScreen(
                                            driver: driver,
                                          ),
                                        ),
                                      );

                                      if (context.mounted) {
                                        provider.loadDrivers();
                                      }
                                    }

                                    if (value == "delete") {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    15),
                                          ),
                                          title:
                                              const Text("Delete Driver"),
                                          content: Text(
                                            "Delete ${driver.name} ?",
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
                                                    .deleteDriver(
                                                  driver.id!,
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
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    content: Text(
                                                      "${driver.name} deleted successfully",
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
                                          Icon(
                                            Icons.visibility,
                                          ),
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