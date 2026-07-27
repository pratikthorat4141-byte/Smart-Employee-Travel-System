import 'package:flutter/material.dart';

import '../../../models/driver_model.dart';

class DriverDetailsScreen extends StatelessWidget {
  final DriverModel driver;

  const DriverDetailsScreen({
    super.key,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  child: Icon(
                    Icons.person,
                    size: 45,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  driver.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                _buildTile(
                  "Driver ID",
                  driver.driverId,
                  Icons.badge,
                ),

                _buildTile(
                  "Mobile",
                  driver.mobile,
                  Icons.phone,
                ),

                _buildTile(
                  "Email",
                  driver.email,
                  Icons.email,
                ),

                _buildTile(
                  "License Number",
                  driver.licenseNumber,
                  Icons.credit_card,
                ),

                _buildTile(
                  "Gender",
                  driver.gender,
                  Icons.people,
                ),

                _buildTile(
                  "Joining Date",
                  driver.joiningDate,
                  Icons.calendar_today,
                ),

                _buildTile(
                  "Address",
                  driver.address,
                  Icons.home,
                ),

                _buildTile(
                  "Availability",
                  driver.isAvailable
                      ? "Available"
                      : "Unavailable",
                  driver.isAvailable
                      ? Icons.check_circle
                      : Icons.cancel,
                ),

                _buildTile(
                  "Status",
                  driver.isActive
                      ? "Active"
                      : "Inactive",
                  driver.isActive
                      ? Icons.verified
                      : Icons.block,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
    String title,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}