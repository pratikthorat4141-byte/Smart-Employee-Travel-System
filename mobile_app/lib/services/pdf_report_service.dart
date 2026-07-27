import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfReportService {
  PdfReportService._();

  static Future<File> generateReport({
    required String title,
    required List<Map<String, dynamic>> data,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,

        margin: const pw.EdgeInsets.all(25),

        build: (context) {
          return [

            //------------------------------------------------
            // HEADER
            //------------------------------------------------

            pw.Container(
              padding: const pw.EdgeInsets.all(18),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue700,
                borderRadius:
                    pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                children: [

                  pw.Text(
                    "SMART EMPLOYEE TRAVEL SYSTEM",
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 24,
                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 6),

                  pw.Text(
                    title,
                    style: const pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 16,
                    ),
                  ),

                ],
              ),
            ),

            pw.SizedBox(height: 25),

            //------------------------------------------------
            // REPORT TABLE
            //------------------------------------------------

            pw.Table.fromTextArray(

              border: pw.TableBorder.all(),

              headerDecoration:
                  const pw.BoxDecoration(
                color: PdfColors.blue100,
              ),

              headerStyle: pw.TextStyle(
                fontWeight:
                    pw.FontWeight.bold,
              ),

              headers: data.isNotEmpty
                  ? data.first.keys.toList()
                  : [],

              data: data
                  .map(
                    (row) => row.values
                        .map(
                          (e) => e.toString(),
                        )
                        .toList(),
                  )
                  .toList(),

            ),

            pw.SizedBox(height: 30),

            //------------------------------------------------
            // SUMMARY
            //------------------------------------------------

            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius:
                    pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [

                  pw.Text(
                    "Report Summary",
                    style: pw.TextStyle(
                      fontWeight:
                          pw.FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  pw.SizedBox(height: 8),

                  pw.Text(
                    "Total Records : ${data.length}",
                  ),

                  pw.Text(
                    "Generated : ${DateFormat("dd MMM yyyy  hh:mm a").format(DateTime.now())}",
                  ),

                ],
              ),
            ),

            pw.SizedBox(height: 40),

            //------------------------------------------------
            // FOOTER
            //------------------------------------------------

            pw.Divider(),

            pw.Center(
              child: pw.Column(
                children: [

                  pw.Text(
                    "Smart Employee Travel Solution",
                    style: pw.TextStyle(
                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 5),

                  pw.Text(
                    "Developed By",
                  ),

                  pw.Text(
                    "Pratik Thorat",
                    style: pw.TextStyle(
                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),

          ];
        },
      ),
    );

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
      "${directory.path}/${title.replaceAll(" ", "_")}.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    return file;
  }
}