import 'package:flutter/material.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/role_selection_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/role":
        return MaterialPageRoute(
          builder: (_) => const RoleSelectionScreen(),
        );

      case "/login":
        final role = settings.arguments as String? ?? "Employee";

        return MaterialPageRoute(
          builder: (_) => LoginScreen(role: role),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const RoleSelectionScreen(),
        );
    }
  }
}