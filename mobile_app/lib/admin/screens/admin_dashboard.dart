import 'package:flutter/material.dart';
import '../../employee/screens/employee_list_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Widget dashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 45,
                color: color,
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [

            dashboardCard(
              context,
              "Employees",
              Icons.people,
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmployeeListScreen(),
                  ),
                );
              },
            ),

            dashboardCard(
              context,
              "Drivers",
              Icons.drive_eta,
              Colors.green,
              () {},
            ),

            dashboardCard(
              context,
              "Vehicles",
              Icons.directions_car,
              Colors.orange,
              () {},
            ),

            dashboardCard(
              context,
              "Trips",
              Icons.route,
              Colors.red,
              () {},
            ),

            dashboardCard(
              context,
              "Reports",
              Icons.bar_chart,
              Colors.purple,
              () {},
            ),

            dashboardCard(
              context,
              "Settings",
              Icons.settings,
              Colors.grey,
              () {},
            ),
          ],
        ),
      ),
    );
  }
}