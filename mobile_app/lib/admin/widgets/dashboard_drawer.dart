import 'package:flutter/material.dart';

import '../../auth/screens/login_screen.dart';
import '../../employee/screens/employee_list_screen.dart';
import '../../driver/screens/driver_list_screen.dart';
import '../../vehicle/screens/vehicle_list_screen.dart';
import '../../trip/screens/trip_list_screen.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  Widget tile(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Pratik Thorat"),
            accountEmail: const Text("admin@travel.com"),
            currentAccountPicture: const CircleAvatar(
              child: Icon(
                Icons.admin_panel_settings,
                size: 35,
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.indigo,
            ),
          ),

          tile(
            context,
            Icons.people,
            "Employees",
            const EmployeeListScreen(),
          ),

          tile(
            context,
            Icons.drive_eta,
            "Drivers",
            const DriverListScreen(),
          ),

          tile(
            context,
            Icons.directions_car,
            "Vehicles",
            const VehicleListScreen(),
          ),

          tile(
            context,
            Icons.route,
            "Trips",
            const TripListScreen(),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}