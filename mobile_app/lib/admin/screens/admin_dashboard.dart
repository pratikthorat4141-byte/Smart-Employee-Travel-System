import '../../reports/screens/report_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/driver_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/trip_provider.dart';

import '../../employee/screens/employee_list_screen.dart';
import '../../driver/screens/driver_list_screen.dart';
import '../../vehicle/screens/vehicle_list_screen.dart';
import '../../trip/screens/trip_list_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Widget dashboardCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(.15),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statCard(
      String title,
      String value,
      Color color,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final employeeCount =
        context.watch<EmployeeProvider>().employees.length;

    final driverCount =
        context.watch<DriverProvider>().drivers.length;

    final vehicleCount =
        context.watch<VehicleProvider>().vehicles.length;

    final trips =
        context.watch<TripProvider>().trips;

    final tripCount = trips.length;

    final pending =
        trips.where((e)=>e.status=="Pending").length;

    final ongoing =
        trips.where((e)=>e.status=="Ongoing").length;

    final completed =
        trips.where((e)=>e.status=="Completed").length;

    return Scaffold(

      drawer: Drawer(

        child: ListView(

          children: [

            UserAccountsDrawerHeader(

              accountName: const Text(
                "Pratik Thorat",
              ),

              accountEmail: const Text(
                "admin@travel.com",
              ),

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

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: (){
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Employees"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_)=>const EmployeeListScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.drive_eta),
              title: const Text("Drivers"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_)=>const DriverListScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text("Vehicles"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_)=>const VehicleListScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.route),
              title: const Text("Trips"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_)=>const TripListScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text("Logout"),
              onTap: (){

                context.read<AuthProvider>().logout();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                      (route)=>false,
                );

              },
            ),

          ],
        ),
      ),

      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Welcome 👋",
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            const Text(
              "Pratik Thorat",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:25),

            GridView.count(

              shrinkWrap:true,

              physics:
              const NeverScrollableScrollPhysics(),

              crossAxisCount:2,

              mainAxisSpacing:15,

              crossAxisSpacing:15,

              childAspectRatio:.95,

              children:[

                dashboardCard(

                  context:context,

                  title:"Employees",

                  value:employeeCount.toString(),

                  icon:Icons.people,

                  color:Colors.blue,

                  page:const EmployeeListScreen(),

                ),

                dashboardCard(

                  context:context,

                  title:"Drivers",

                  value:driverCount.toString(),

                  icon:Icons.drive_eta,

                  color:Colors.green,

                  page:const DriverListScreen(),

                ),

                dashboardCard(

                  context:context,

                  title:"Vehicles",

                  value:vehicleCount.toString(),

                  icon:Icons.directions_car,

                  color:Colors.orange,

                  page:const VehicleListScreen(),

                ),

                dashboardCard(

                  context:context,

                  title:"Trips",

                  value:tripCount.toString(),

                  icon:Icons.route,

                  color:Colors.red,

                  page:const TripListScreen(),

                ),
                dashboardCard(
                   context: context,
                   title: "Reports",
                   value: "View",
                   icon: Icons.bar_chart,
                   color: Colors.teal,
                   page: const ReportDashboardScreen(),
),
              ],

            ),

            const SizedBox(height:30),

            const Text(
              "Trip Statistics",
              style: TextStyle(
                fontSize:22,
                fontWeight:FontWeight.bold,
              ),
            ),

            const SizedBox(height:15),
                        statCard(
              "Pending Trips",
              pending.toString(),
              Colors.red,
            ),

            statCard(
              "Ongoing Trips",
              ongoing.toString(),
              Colors.orange,
            ),

            statCard(
              "Completed Trips",
              completed.toString(),
              Colors.green,
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.people),
                label: const Text("Manage Employees"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmployeeListScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.drive_eta),
                label: const Text("Manage Drivers"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DriverListScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.directions_car),
                label: const Text("Manage Vehicles"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VehicleListScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.route),
                label: const Text("Manage Trips"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TripListScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Recent Summary",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.people,
                        color: Colors.blue,
                      ),
                      title: const Text("Employees"),
                      trailing: Text(employeeCount.toString()),
                    ),

                    ListTile(
                      leading: const Icon(
                        Icons.drive_eta,
                        color: Colors.green,
                      ),
                      title: const Text("Drivers"),
                      trailing: Text(driverCount.toString()),
                    ),

                    ListTile(
                      leading: const Icon(
                        Icons.directions_car,
                        color: Colors.orange,
                      ),
                      title: const Text("Vehicles"),
                      trailing: Text(vehicleCount.toString()),
                    ),

                    ListTile(
                      leading: const Icon(
                        Icons.route,
                        color: Colors.red,
                      ),
                      title: const Text("Trips"),
                      trailing: Text(tripCount.toString()),
                    ),
                               ListTile(
  leading: const Icon(Icons.bar_chart),
  title: const Text("Reports"),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ReportDashboardScreen(),
      ),
    );
  },
),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}