import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // ===========================================================================
  // APPLICATION
  // ===========================================================================

  static const String appName = "Smart Employee Travel System";
  static const String appVersion = "1.0.0";

  // ===========================================================================
  // DATABASE
  // ===========================================================================

  static const String databaseName = "smart_employee_travel.db";
  static const int databaseVersion = 6;

  // ===========================================================================
  // TABLE NAMES
  // ===========================================================================

  static const String usersTable = "users";
  static const String employeesTable = "employees";
  static const String driversTable = "drivers";
  static const String vehiclesTable = "vehicles";
  static const String tripsTable = "trips";

  // ===========================================================================
  // DEFAULT ADMIN
  // ===========================================================================

  static const String defaultAdminName = "Administrator";
  static const String defaultAdminEmail = "admin@travel.com";
  static const String defaultAdminPassword = "admin123";

  // ===========================================================================
  // USER ROLES
  // ===========================================================================

  static const String adminRole = "Admin";
  static const String employeeRole = "Employee";
  static const String driverRole = "Driver";

  // ===========================================================================
  // GENDERS
  // ===========================================================================

  static const List<String> genders = [
    "Male",
    "Female",
    "Other",
  ];

  // ===========================================================================
  // VEHICLE TYPES
  // ===========================================================================

  static const List<String> vehicleTypes = [
    "Car",
    "Sedan",
    "SUV",
  ];

  // ===========================================================================
  // FUEL TYPES
  // ===========================================================================

  static const List<String> fuelTypes = [
    "Petrol",
    "Diesel",
    "CNG",
    "Electric",
    "Hybrid",
  ];

  // ===========================================================================
  // TRIP STATUS
  // ===========================================================================

  static const List<String> tripStatus = [
    "Pending",
    "Assigned",
    "Started",
    "Completed",
    "Cancelled",
  ];

  // ===========================================================================
  // DRIVER STATUS
  // ===========================================================================

  static const String available = "Available";
  static const String unavailable = "Unavailable";

  // ===========================================================================
  // RECORD STATUS
  // ===========================================================================

  static const String active = "Active";
  static const String inactive = "Inactive";

  // ===========================================================================
  // SEARCH
  // ===========================================================================

  static const int minSearchLength = 2;
  static const int pageSize = 20;

  // ===========================================================================
  // DATE FORMAT
  // ===========================================================================

  static const String dateFormat = "dd-MM-yyyy";
  static const String dateTimeFormat = "dd-MM-yyyy HH:mm";

  // ===========================================================================
  // ANIMATION
  // ===========================================================================

  static const Duration animationDuration =
      Duration(milliseconds: 300);

  static const Duration splashDuration =
      Duration(seconds: 2);

  // ===========================================================================
  // UI
  // ===========================================================================

  static const double borderRadius = 12.0;
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double textFieldRadius = 12.0;
  static const double cardElevation = 2.0;

  // ===========================================================================
  // SPACING
  // ===========================================================================

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  static const EdgeInsets screenPadding =
      EdgeInsets.all(md);

  // ===========================================================================
  // FORM VALIDATION
  // ===========================================================================

  static const int mobileLength = 10;
  static const int passwordMinLength = 6;

  // ===========================================================================
  // REPORTS
  // ===========================================================================

  static const String pdfFolder = "Reports";
}