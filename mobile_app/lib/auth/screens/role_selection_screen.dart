import 'package:flutter/material.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Widget roleCard(
    BuildContext context,
    String role,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color: color,
          size: 35,
        ),
        title: Text(
          role,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Role"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            roleCard(
              context,
              "Admin",
              Icons.admin_panel_settings,
              Colors.red,
            ),
            roleCard(
              context,
              "Driver",
              Icons.drive_eta,
              Colors.green,
            ),
            roleCard(
              context,
              "Employee",
              Icons.person,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}