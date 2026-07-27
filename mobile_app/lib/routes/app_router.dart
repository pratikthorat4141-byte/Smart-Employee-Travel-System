import 'package:flutter/material.dart';

import '../models/payment_model.dart';

import '../screens/splash/splash_screen.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';

import '../screens/admin/admin_dashboard.dart';
import '../screens/employee/employee_dashboard.dart';
import '../screens/driver/driver_dashboard.dart';

import '../screens/reports/reports_screen.dart';

//=============================
// ADMIN
//=============================

import '../screens/admin/employee/employee_list_screen.dart';
import '../screens/admin/driver/driver_list_screen.dart';
import '../screens/admin/trip/trip_list_screen.dart';
import '../screens/admin/vehicle/vehicle_list_screen.dart';
import '../screens/admin/live_tracking/admin_live_tracking_screen.dart';

//=============================
// PAYMENT
//=============================

import '../screens/admin/payment/payment_dashboard_screen.dart';
import '../screens/admin/payment/payment_history_screen.dart';
import '../screens/admin/payment/payment_receipt_screen.dart';

class AppRouter {
  AppRouter._();

  // AUTH
  static const splash = "/";
  static const login = "/login";
  static const signup = "/signup";
  static const forgotPassword =
      "/forgot-password";

  // DASHBOARD
  static const adminDashboard =
      "/admin-dashboard";
  static const employeeDashboard =
      "/employee-dashboard";
  static const driverDashboard =
      "/driver-dashboard";

  // ADMIN
  static const employeeList =
      "/employee-list";
  static const driverList =
      "/driver-list";
  static const vehicleList =
      "/vehicle-list";
  static const tripList =
      "/trip-list";
  static const paymentDashboard =
      "/payment-dashboard";
  static const liveTracking =
      "/live-tracking";

  // PAYMENT
  static const payment = "/payment";
  static const paymentHistory =
      "/payment-history";
  static const paymentReceipt =
      "/payment-receipt";

  // REPORT
  static const reports = "/reports";

  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) =>
              const SplashScreen(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        );

      case signup:
        return MaterialPageRoute(
          builder: (_) =>
              const SignupScreen(),
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) =>
              const ForgotPasswordScreen(),
        );

      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) =>
              const AdminDashboard(),
        );

      case employeeDashboard:
        return MaterialPageRoute(
          builder: (_) =>
              const EmployeeDashboard(),
        );

      case driverDashboard:
        return MaterialPageRoute(
          builder: (_) =>
              const DriverDashboard(),
        );

      case employeeList:
        return MaterialPageRoute(
          builder: (_) =>
              const EmployeeListScreen(),
        );

      case driverList:
        return MaterialPageRoute(
          builder: (_) =>
              const DriverListScreen(),
        );

      case vehicleList:
        return MaterialPageRoute(
          builder: (_) =>
              const VehicleListScreen(),
        );

      case tripList:
        return MaterialPageRoute(
          builder: (_) =>
              const TripListScreen(),
        );

      case paymentDashboard:
      case payment:
        return MaterialPageRoute(
          builder: (_) =>
              const PaymentDashboardScreen(),
        );

      case paymentHistory:
        return MaterialPageRoute(
          builder: (_) =>
              const PaymentHistoryScreen(),
        );

      case paymentReceipt:
        final payment =
            settings.arguments
                as PaymentModel;

        return MaterialPageRoute(
          builder: (_) =>
              PaymentReceiptScreen(
            payment: payment,
          ),
        );

      case liveTracking:
        return MaterialPageRoute(
          builder: (_) =>
              const AdminLiveTrackingScreen(),
        );

      case reports:
        return MaterialPageRoute(
          builder: (_) =>
              const ReportsScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text(
                "404",
              ),
            ),
            body: const Center(
              child: Text(
                "Page Not Found",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ),
        );
    }
  }
}