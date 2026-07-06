import 'package:flutter/material.dart';

import '../auth/screens/login_screen.dart';
import '../auth/screens/role_selection_screen.dart';

import '../admin/screens/admin_dashboard.dart';
import '../employee_user/screens/employee_dashboard.dart';
import '../driver/screens/driver_list_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
      case "/role":
        return MaterialPageRoute(
          builder: (_) => const RoleSelectionScreen(),
        );

      case "/login":
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case "/dashboard":
        return MaterialPageRoute(
          builder: (_) => const AdminDashboard(),
        );

      case "/employeeDashboard":
        return MaterialPageRoute(
          builder: (_) => const EmployeeDashboard(),
        );

      case "/driverDashboard":
        return MaterialPageRoute(
          builder: (_) => const DriverListScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const RoleSelectionScreen(),
        );
    }
  }
}