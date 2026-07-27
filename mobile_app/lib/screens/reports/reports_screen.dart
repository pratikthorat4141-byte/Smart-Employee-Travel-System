import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/driver_provider.dart';
import '../../providers/employee_provider.dart';
import '../../providers/trip_provider.dart';
import '../../providers/vehicle_provider.dart';

import '../../services/pdf_report_service.dart';
import '../../services/excel_report_service.dart';

import '../../widgets/dashboard_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({
    super.key,
  });

  @override
  State<ReportsScreen> createState() =>
      _ReportsScreenState();
}

class _ReportsScreenState
    extends State<ReportsScreen> {

  DateTime? _fromDate;
  DateTime? _toDate;

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
    });
  }

  List<Map<String, dynamic>> _reportData(
    EmployeeProvider employeeProvider,
    DriverProvider driverProvider,
    VehicleProvider vehicleProvider,
    TripProvider tripProvider,
  ) {
    return [
      {
        "Category": "Employees",
        "Count": employeeProvider.totalEmployees,
      },
      {
        "Category": "Drivers",
        "Count": driverProvider.totalDrivers,
      },
      {
        "Category": "Vehicles",
        "Count": vehicleProvider.totalVehicles,
      },
      {
        "Category": "Trips",
        "Count": tripProvider.totalTrips,
      },
      {
        "Category": "Completed Trips",
        "Count": tripProvider.completedTrips.length,
      },
      {
        "Category": "Pending Trips",
        "Count": tripProvider.pendingTrips.length,
      },
      {
        "Category": "Started Trips",
        "Count": tripProvider.startedTrips.length,
      },
      {
        "Category": "Cancelled Trips",
        "Count": tripProvider.cancelledTrips.length,
      },
    ];
  }

  Future<void> _exportPdf(
    EmployeeProvider employeeProvider,
    DriverProvider driverProvider,
    VehicleProvider vehicleProvider,
    TripProvider tripProvider,
  ) async {
    final file =
        await PdfReportService.generateReport(
      title: "Travel Report",
      data: _reportData(
        employeeProvider,
        driverProvider,
        vehicleProvider,
        tripProvider,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "PDF Saved\n${file.path}",
        ),
      ),
    );
  }
    Future<void> _exportExcel(
    EmployeeProvider employeeProvider,
    DriverProvider driverProvider,
    VehicleProvider vehicleProvider,
    TripProvider tripProvider,
  ) async {
    final file =
        await ExcelReportService.generateReport(
      title: "Travel Report",
      data: _reportData(
        employeeProvider,
        driverProvider,
        vehicleProvider,
        tripProvider,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Excel Saved\n${file.path}",
        ),
      ),
    );
  }

  Future<void> _shareReport(
    EmployeeProvider employeeProvider,
    DriverProvider driverProvider,
    VehicleProvider vehicleProvider,
    TripProvider tripProvider,
  ) async {
    final file =
        await PdfReportService.generateReport(
      title: "Travel Report",
      data: _reportData(
        employeeProvider,
        driverProvider,
        vehicleProvider,
        tripProvider,
      ),
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(file.path),
        ],
        text: "Smart Employee Travel Report",
        subject: "Travel Report",
      ),
    );
  }

  Future<void> _pickFromDate() async {
    final picked =
        await showDatePicker(
      context: context,
      initialDate:
          _fromDate ??
              DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _pickToDate() async {
    final picked =
        await showDatePicker(
      context: context,
      initialDate:
          _toDate ??
              DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
    }
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Reports Dashboard",
        ),
              actions: [
        IconButton(
          icon: const Icon(
            Icons.refresh,
          ),
          onPressed: () async {
            await employeeProvider.refresh();
            await driverProvider.refresh();
            await vehicleProvider.refresh();
            await tripProvider.refresh();
          },
        ),
      ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await employeeProvider.refresh();
          await driverProvider.refresh();
          await vehicleProvider.refresh();
          await tripProvider.refresh();
        },

        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [

            //------------------------------------------------
            // HEADER
            //------------------------------------------------

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(22),

                gradient: const LinearGradient(
                  colors: [
                    Color(0xff1565C0),
                    Color(0xff1E88E5),
                  ],
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Admin Analytics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Smart Employee Travel System",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      Expanded(
                        child:
                            OutlinedButton.icon(
                          style:
                              OutlinedButton
                                  .styleFrom(
                            foregroundColor:
                                Colors.white,
                            side:
                                const BorderSide(
                              color:
                                  Colors.white,
                            ),
                          ),
                          onPressed:
                              _pickFromDate,
                          icon: const Icon(
                            Icons.calendar_today,
                          ),
                          label: Text(
                            _fromDate == null
                                ? "From"
                                : DateFormat(
                                    "dd MMM",
                                  ).format(
                                    _fromDate!,
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child:
                            OutlinedButton.icon(
                          style:
                              OutlinedButton
                                  .styleFrom(
                            foregroundColor:
                                Colors.white,
                            side:
                                const BorderSide(
                              color:
                                  Colors.white,
                            ),
                          ),
                          onPressed:
                              _pickToDate,
                          icon: const Icon(
                            Icons.event,
                          ),
                          label: Text(
                            _toDate == null
                                ? "To"
                                : DateFormat(
                                    "dd MMM",
                                  ).format(
                                    _toDate!,
                                  ),
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),
                        //------------------------------------------------
            // EXPORT BUTTONS
            //------------------------------------------------

            Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.picture_as_pdf,
                    ),
                    label: const Text(
                      "PDF",
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red,
                      foregroundColor:
                          Colors.white,
                    ),
                    onPressed: () async {

                      await _exportPdf(
                        employeeProvider,
                        driverProvider,
                        vehicleProvider,
                        tripProvider,
                      );

                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.table_chart,
                    ),
                    label: const Text(
                      "Excel",
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green,
                      foregroundColor:
                          Colors.white,
                    ),
                    onPressed: () async {

                      await _exportExcel(
                        employeeProvider,
                        driverProvider,
                        vehicleProvider,
                        tripProvider,
                      );

                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.share,
                    ),
                    label: const Text(
                      "Share",
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                      foregroundColor:
                          Colors.white,
                    ),
                    onPressed: () async {

                      await _shareReport(
                        employeeProvider,
                        driverProvider,
                        vehicleProvider,
                        tripProvider,
                      );

                    },
                  ),
                ),

              ],
            ),

            const SizedBox(height: 25),

            //------------------------------------------------
            // OVERALL STATISTICS
            //------------------------------------------------

            Text(
              "Overall Statistics",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight:
                        FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 15),

           GridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: 2,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  mainAxisExtent: 150,
  children: [

                DashboardCard(
                  title: "Employees",
                  value: employeeProvider
                      .totalEmployees
                      .toString(),
                  icon: Icons.people,
                  color: Colors.blue,
                ),

                DashboardCard(
                  title: "Drivers",
                  value: driverProvider
                      .totalDrivers
                      .toString(),
                  icon: Icons.person,
                  color: Colors.orange,
                ),

                DashboardCard(
                  title: "Vehicles",
                  value: vehicleProvider
                      .totalVehicles
                      .toString(),
                  icon: Icons.directions_bus,
                  color: Colors.green,
                ),

                DashboardCard(
                  title: "Trips",
                  value: tripProvider
                      .totalTrips
                      .toString(),
                  icon: Icons.route,
                  color: Colors.red,
                ),

              ],
            ),

            const SizedBox(height: 24),
                        //------------------------------------------------
            // DRIVER REPORT
            //------------------------------------------------

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        CircleAvatar(
                          backgroundColor:
                              Colors.orange.shade100,
                          child: const Icon(
                            Icons.person,
                            color: Colors.orange,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Text(
                          "Driver Report",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 18),

                    ListTile(
                      leading: const Icon(
                        Icons.people,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        "Total Drivers",
                      ),
                      trailing: Text(
                        driverProvider
                            .totalDrivers
                            .toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: const Text(
                        "Available Drivers",
                      ),
                      trailing: Text(
                        driverProvider
                            .availableDrivers
                            .length
                            .toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.person_off,
                        color: Colors.red,
                      ),
                      title: const Text(
                        "Busy Drivers",
                      ),
                      trailing: Text(
                        (driverProvider.totalDrivers -
                                driverProvider
                                    .availableDrivers
                                    .length)
                            .toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            //------------------------------------------------
            // VEHICLE REPORT
            //------------------------------------------------

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        CircleAvatar(
                          backgroundColor:
                              Colors.green.shade100,
                          child: const Icon(
                            Icons.directions_bus,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Text(
                          "Vehicle Report",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 18),

                    ListTile(
                      leading: const Icon(
                        Icons.directions_bus,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        "Total Vehicles",
                      ),
                      trailing: Text(
                        vehicleProvider
                            .totalVehicles
                            .toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: const Text(
                        "Available Vehicles",
                      ),
                      trailing: Text(
                        vehicleProvider
                            .availableVehicles
                            .length
                            .toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.car_crash,
                        color: Colors.red,
                      ),
                      title: const Text(
                        "Busy Vehicles",
                      ),
                      trailing: Text(
                        (vehicleProvider.totalVehicles -
                                vehicleProvider
                                    .availableVehicles
                                    .length)
                            .toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
                        //------------------------------------------------
            // TRIP STATUS REPORT
            //------------------------------------------------

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        CircleAvatar(
                          backgroundColor:
                              Colors.blue.shade100,
                          child: const Icon(
                            Icons.route,
                            color: Colors.blue,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Text(
                          "Trip Status Report",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 18),

                    ListTile(
                      leading: const Icon(
                        Icons.pending,
                        color: Colors.orange,
                      ),
                      title: const Text(
                        "Pending Trips",
                      ),
                      trailing: Text(
                        tripProvider
                            .pendingTrips
                            .length
                            .toString(),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.assignment,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        "Assigned Trips",
                      ),
                      trailing: Text(
                        tripProvider
                            .assignedTrips
                            .length
                            .toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.play_circle_fill,
                        color: Colors.deepPurple,
                      ),
                      title: const Text(
                        "Started Trips",
                      ),
                      trailing: Text(
                        tripProvider
                            .startedTrips
                            .length
                            .toString(),
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: const Text(
                        "Completed Trips",
                      ),
                      trailing: Text(
                        tripProvider
                            .completedTrips
                            .length
                            .toString(),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      title: const Text(
                        "Cancelled Trips",
                      ),
                      trailing: Text(
                        tripProvider
                            .cancelledTrips
                            .length
                            .toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
                        //------------------------------------------------
            // TRIP COMPLETION
            //------------------------------------------------

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        CircleAvatar(
                          backgroundColor:
                              Colors.purple.shade100,
                          child: const Icon(
                            Icons.analytics,
                            color: Colors.purple,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Text(
                          "Trip Completion",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 20),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: tripProvider.totalTrips == 0
                            ? 0
                            : tripProvider
                                    .completedTrips
                                    .length /
                                tripProvider.totalTrips,
                        minHeight: 12,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: Text(
                        tripProvider.totalTrips == 0
                            ? "0 % Completed"
                            : "${((tripProvider.completedTrips.length / tripProvider.totalTrips) * 100).toStringAsFixed(1)} % Completed",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            //------------------------------------------------
            // OVERALL SUMMARY
            //------------------------------------------------

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        CircleAvatar(
                          backgroundColor:
                              Colors.indigo.shade100,
                          child: const Icon(
                            Icons.summarize,
                            color: Colors.indigo,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Text(
                          "Overall Summary",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 15),

                    ListTile(
                      leading:
                          const Icon(Icons.people),
                      title:
                          const Text("Employees"),
                      trailing: Text(
                        employeeProvider
                            .totalEmployees
                            .toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    ListTile(
                      leading:
                          const Icon(Icons.person),
                      title:
                          const Text("Drivers"),
                      trailing: Text(
                        driverProvider
                            .totalDrivers
                            .toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    ListTile(
                      leading: const Icon(
                        Icons.directions_bus,
                      ),
                      title: const Text(
                        "Vehicles",
                      ),
                      trailing: Text(
                        vehicleProvider
                            .totalVehicles
                            .toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    ListTile(
                      leading:
                          const Icon(Icons.route),
                      title:
                          const Text("Trips"),
                      trailing: Text(
                        tripProvider.totalTrips
                            .toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
                        //------------------------------------------------
            // QUICK ACTIONS
            //------------------------------------------------

            Text(
              "Quick Actions",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight:
                        FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(
                      Icons.picture_as_pdf,
                    ),
                    label: const Text(
                      "Export PDF",
                    ),
                    onPressed: () async {

                      await _exportPdf(
                        employeeProvider,
                        driverProvider,
                        vehicleProvider,
                        tripProvider,
                      );

                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(
                      Icons.table_chart,
                    ),
                    label: const Text(
                      "Export Excel",
                    ),
                    onPressed: () async {

                      await _exportExcel(
                        employeeProvider,
                        driverProvider,
                        vehicleProvider,
                        tripProvider,
                      );

                    },
                  ),
                ),

              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(
                  Icons.share,
                ),
                label: const Text(
                  "Share Report",
                ),
                onPressed: () async {

                  await _shareReport(
                    employeeProvider,
                    driverProvider,
                    vehicleProvider,
                    tripProvider,
                  );

                },
              ),
            ),

            const SizedBox(height: 30),
                        //------------------------------------------------
            // DEVELOPER CARD
            //------------------------------------------------

            Card(
              elevation: 0,
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const Icon(
                      Icons.admin_panel_settings,
                      size: 48,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Smart Employee Travel System",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "AI Enabled Travel Management System",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: const [

                        Icon(
                          Icons.code,
                          color: Colors.blue,
                          size: 18,
                        ),

                        SizedBox(width: 6),

                        Text(
                          "Developed By",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Pratik Thorat",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "Generated on ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                "Version 1.0.0",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 30),
                      ],
        ),
      ),
    );
  }
}