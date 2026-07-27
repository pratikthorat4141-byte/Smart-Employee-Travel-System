import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/driver_provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/trip_provider.dart';
import '../../providers/vehicle_provider.dart';

import '../../routes/app_router.dart';

import '../../widgets/app_drawer.dart';
import '../../widgets/dashboard_card.dart';

import 'driver/driver_list_screen.dart';
import 'employee/employee_list_screen.dart';
import 'live_tracking/admin_live_tracking_screen.dart';
import 'payment/payment_dashboard_screen.dart';
import 'trip/trip_list_screen.dart';
import 'vehicle/vehicle_list_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() =>
      _AdminDashboardState();
}

class _AdminDashboardState
    extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context
          .read<EmployeeProvider>()
          .loadEmployees();

      await context
          .read<DriverProvider>()
          .loadDrivers();

      await context
          .read<VehicleProvider>()
          .loadVehicles();

      await context
          .read<TripProvider>()
          .loadTrips();

      // Payment Load
      await context
          .read<PaymentProvider>()
          .loadPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider =
        context.watch<EmployeeProvider>();

    final driverProvider =
        context.watch<DriverProvider>();

    final vehicleProvider =
        context.watch<VehicleProvider>();

    final tripProvider =
        context.watch<TripProvider>();

    final paymentProvider =
        context.watch<PaymentProvider>();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Admin Dashboard",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await employeeProvider.loadEmployees();
          await driverProvider.loadDrivers();
          await vehicleProvider.loadVehicles();
          await tripProvider.loadTrips();
          await paymentProvider.loadPayments();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics:
              const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
                            GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.25,
                children: [

                  DashboardCard(
                    title: "Employees",
                    value: employeeProvider.employees.length.toString(),
                    icon: Icons.people,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EmployeeListScreen(),
                        ),
                      );
                    },
                  ),

                  DashboardCard(
                    title: "Drivers",
                    value: driverProvider.drivers.length.toString(),
                    icon: Icons.badge,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DriverListScreen(),
                        ),
                      );
                    },
                  ),

                  DashboardCard(
                    title: "Vehicles",
                    value: vehicleProvider.vehicles.length.toString(),
                    icon: Icons.directions_car,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VehicleListScreen(),
                        ),
                      );
                    },
                  ),

                  DashboardCard(
                    title: "Trips",
                    value: tripProvider.trips.length.toString(),
                    icon: Icons.route,
                    color: Colors.deepPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TripListScreen(),
                        ),
                      );
                    },
                  ),

                  DashboardCard(
                    title: "Payments",
                    value: context
                        .watch<PaymentProvider>()
                        .payments
                        .length
                        .toString(),
                    icon: Icons.payment,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.paymentDashboard,
                      );
                    },
                  ),

                  DashboardCard(
                    title: "Live Tracking",
                    value: "",
                    icon: Icons.location_on,
                    color: Colors.red,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.liveTracking,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
  "Quick Actions",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

Row(
  children: [
    Expanded(
      child: FilledButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EmployeeListScreen(),
            ),
          );
        },
        icon: const Icon(Icons.people),
        label: const Text("Employees"),
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: FilledButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DriverListScreen(),
            ),
          );
        },
        icon: const Icon(Icons.badge),
        label: const Text("Drivers"),
      ),
    ),
  ],
),

const SizedBox(height: 12),

Row(
  children: [
    Expanded(
      child: FilledButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const VehicleListScreen(),
            ),
          );
        },
        icon: const Icon(Icons.directions_car),
        label: const Text("Vehicles"),
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: FilledButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TripListScreen(),
            ),
          );
        },
        icon: const Icon(Icons.route),
        label: const Text("Trips"),
      ),
    ),
  ],
),

const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  child: FilledButton.icon(
    onPressed: () {
      Navigator.pushNamed(
        context,
        AppRouter.paymentDashboard,
      );
    },
    icon: const Icon(Icons.payment),
    label: const Text("Payments"),
  ),
),

const SizedBox(height: 30),
DashboardCard(
  title: "Employees",
  value: employeeProvider.employees.length.toString(),
  icon: Icons.people,
  color: Colors.blue,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EmployeeListScreen(),
      ),
    );
  },
),

DashboardCard(
  title: "Live Tracking",
  value: "",
  icon: Icons.location_on,
  color: Colors.red,
  onTap: () {
    Navigator.pushNamed(
      context,
      AppRouter.liveTracking,
    );
  },
),

DashboardCard(
  title: "Drivers",
  value: driverProvider.drivers.length.toString(),
  icon: Icons.badge,
  color: Colors.orange,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DriverListScreen(),
      ),
    );
  },
),

DashboardCard(
  title: "Vehicles",
  value: vehicleProvider.vehicles.length.toString(),
  icon: Icons.directions_car,
  color: Colors.green,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VehicleListScreen(),
      ),
    );
  },
),

DashboardCard(
  title: "Trips",
  value: tripProvider.trips.length.toString(),
  icon: Icons.route,
  color: Colors.deepPurple,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TripListScreen(),
      ),
    );
  },
),

// ===================== PAYMENT CARD =====================

DashboardCard(
  title: "Payments",
  value: "₹",
  icon: Icons.payment,
  color: Colors.teal,
  onTap: () {
    Navigator.pushNamed(
      context,
      AppRouter.paymentDashboard,
    );
  },
),
              const SizedBox(height: 30),

              const Text(
                "Recent Activity",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                      title: const Text(
                        "System Ready",
                      ),
                      subtitle: const Text(
                        "All modules loaded successfully.",
                      ),
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.route,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "${tripProvider.trips.length} Trips Available",
                      ),
                      subtitle: const Text(
                        "Trip database synchronized.",
                      ),
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.people,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "${employeeProvider.employees.length} Employees Registered",
                      ),
                      subtitle: const Text(
                        "Employee records are up to date.",
                      ),
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Icon(
                          Icons.local_shipping,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        "${driverProvider.drivers.length} Drivers Available",
                      ),
                      subtitle: const Text(
                        "Driver database synchronized.",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Text(
                  "Developed By Pratik Thorat",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await employeeProvider.loadEmployees();
                    await driverProvider.loadDrivers();
                    await vehicleProvider.loadVehicles();
                    await tripProvider.loadTrips();

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Dashboard Refreshed Successfully",
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    "Refresh Dashboard",
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}