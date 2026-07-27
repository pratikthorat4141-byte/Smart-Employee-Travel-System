class AppStrings {
  AppStrings._();

  // ---------------------------------------------------------------------------
  // Application
  // ---------------------------------------------------------------------------

  static const String appName = "Smart Employee Travel System";
  static const String appVersion = "Version 1.0.0";

  // ---------------------------------------------------------------------------
  // Authentication
  // ---------------------------------------------------------------------------

  static const String login = "Login";
  static const String signup = "Sign Up";
  static const String logout = "Logout";

  static const String welcome = "Welcome";
  static const String welcomeBack = "Welcome Back";
  static const String createAccount = "Create Account";

  static const String email = "Email";
  static const String password = "Password";
  static const String confirmPassword = "Confirm Password";

  static const String rememberMe = "Remember Me";
  static const String forgotPassword = "Forgot Password?";

  // ---------------------------------------------------------------------------
  // User Details
  // ---------------------------------------------------------------------------

  static const String fullName = "Full Name";
  static const String mobile = "Mobile Number";
  static const String address = "Address";
  static const String department = "Department";
  static const String designation = "Designation";

  // ---------------------------------------------------------------------------
  // Employee
  // ---------------------------------------------------------------------------

  static const String employee = "Employee";
  static const String employees = "Employees";
  static const String employeeId = "Employee ID";

  static const String addEmployee = "Add Employee";
  static const String editEmployee = "Edit Employee";
  static const String deleteEmployee = "Delete Employee";

  // ---------------------------------------------------------------------------
  // Driver
  // ---------------------------------------------------------------------------

  static const String driver = "Driver";
  static const String drivers = "Drivers";
  static const String driverId = "Driver ID";

  static const String addDriver = "Add Driver";
  static const String editDriver = "Edit Driver";
  static const String deleteDriver = "Delete Driver";

  // ---------------------------------------------------------------------------
  // Vehicle
  // ---------------------------------------------------------------------------

  static const String vehicle = "Vehicle";
  static const String vehicles = "Vehicles";

  static const String vehicleNumber = "Vehicle Number";
  static const String vehicleType = "Vehicle Type";
  static const String seatingCapacity = "Seating Capacity";

  static const String addVehicle = "Add Vehicle";
  static const String editVehicle = "Edit Vehicle";
  static const String deleteVehicle = "Delete Vehicle";

  // ---------------------------------------------------------------------------
  // Trip
  // ---------------------------------------------------------------------------

  static const String trip = "Trip";
  static const String trips = "Trips";

  static const String tripId = "Trip ID";
  static const String pickupLocation = "Pickup Location";
  static const String destination = "Destination";
  static const String tripDate = "Trip Date";
  static const String tripTime = "Trip Time";
  static const String status = "Status";

  static const String addTrip = "Add Trip";
  static const String editTrip = "Edit Trip";
  static const String deleteTrip = "Delete Trip";

  // ---------------------------------------------------------------------------
  // Dashboard
  // ---------------------------------------------------------------------------

  static const String dashboard = "Dashboard";
  static const String reports = "Reports";
  static const String settings = "Settings";
  static const String profile = "Profile";

  // ---------------------------------------------------------------------------
  // Buttons
  // ---------------------------------------------------------------------------

  static const String save = "Save";
  static const String update = "Update";
  static const String delete = "Delete";
  static const String edit = "Edit";

  static const String cancel = "Cancel";
  static const String close = "Close";

  static const String search = "Search";
  static const String filter = "Filter";
  static const String refresh = "Refresh";

  static const String yes = "Yes";
  static const String no = "No";

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  static const String requiredField = "This field is required";
  static const String invalidEmail = "Please enter a valid email";
  static const String invalidMobile = "Please enter a valid mobile number";
  static const String passwordTooShort =
      "Password must be at least 6 characters";
  static const String passwordNotMatch = "Passwords do not match";

  // ---------------------------------------------------------------------------
  // Messages
  // ---------------------------------------------------------------------------

  static const String loading = "Loading...";
  static const String noDataFound = "No data found";

  static const String saveSuccess = "Saved successfully";
  static const String updateSuccess = "Updated successfully";
  static const String deleteSuccess = "Deleted successfully";

  static const String loginSuccess = "Login successful";
  static const String signupSuccess = "Account created successfully";

  static const String somethingWentWrong =
      "Something went wrong. Please try again.";

  // ---------------------------------------------------------------------------
  // Dialogs
  // ---------------------------------------------------------------------------

  static const String confirmDelete = "Confirm Delete";
  static const String deleteMessage =
      "Are you sure you want to delete this record?";

  static const String logoutMessage =
      "Are you sure you want to logout?";

  // ---------------------------------------------------------------------------
  // Trip Status
  // ---------------------------------------------------------------------------

  static const String pending = "Pending";
  static const String assigned = "Assigned";
  static const String started = "Started";
  static const String completed = "Completed";
  static const String cancelled = "Cancelled";
}