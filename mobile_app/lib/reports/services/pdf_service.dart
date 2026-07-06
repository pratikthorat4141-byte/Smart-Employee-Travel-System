import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../employee_user/models/employee_model.dart';
import '../../driver/models/driver_model.dart';
import '../../vehicle/models/vehicle_model.dart';
import '../../trip/models/trip_model.dart';

class PdfService {
  static Future<void> generateReport({
    required List<Employee> employees,
    required List<Driver> drivers,
    required List<Vehicle> vehicles,
    required List<Trip> trips,
  }) async {

    final pdf = pw.Document();

    pdf.addPage(

      pw.MultiPage(

        pageFormat: PdfPageFormat.a4,

        build: (context) => [

          pw.Center(
            child: pw.Text(
              "Smart Employee Travel System",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Center(
            child: pw.Text(
              "System Report",
              style: const pw.TextStyle(
                fontSize: 18,
              ),
            ),
          ),

          pw.Divider(),

          pw.SizedBox(height: 15),

          pw.Text(
            "Summary",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Bullet(
            text: "Total Employees : ${employees.length}",
          ),

          pw.Bullet(
            text: "Total Drivers : ${drivers.length}",
          ),

          pw.Bullet(
            text: "Total Vehicles : ${vehicles.length}",
          ),

          pw.Bullet(
            text: "Total Trips : ${trips.length}",
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            "Employees",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.Table.fromTextArray(

            headers: const [
              "Name",
              "Email",
              "Department",
            ],

            data: employees
                .map(
                  (e) => [
                    e.name,
                    e.email,
                    e.department,
                  ],
                )
                .toList(),
          ),

          pw.SizedBox(height: 20),
                    pw.Text(
            "Drivers",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.Table.fromTextArray(
            headers: const [
              "Name",
              "Phone",
              "License No",
            ],
            data: drivers
                .map(
                  (d) => [
                    d.name,
                    d.phone,
                    d.licenseNo,
                  ],
                )
                .toList(),
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            "Vehicles",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.Table.fromTextArray(
            headers: const [
              "Vehicle No",
              "Type",
              "Capacity",
            ],
            data: vehicles
                .map(
                  (v) => [
                    v.vehicleNo,
                    v.type,
                    v.capacity.toString(),
                  ],
                )
                .toList(),
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            "Trips",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.Table.fromTextArray(
            headers: const [
              "Employee",
              "Driver",
              "Vehicle",
              "Source",
              "Destination",
              "Status",
            ],
            data: trips
                .map(
                  (t) => [
                    t.employee,
                    t.driver,
                    t.vehicle,
                    t.source,
                    t.destination,
                    t.status,
                  ],
                )
                .toList(),
          ),
        ],
      ),
    );

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
      "${directory.path}/travel_system_report.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}