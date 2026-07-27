import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/payment_model.dart';

class PaymentPdfService {
  PaymentPdfService._();

  static final PaymentPdfService instance =
      PaymentPdfService._();

  //--------------------------------------------------
  // GENERATE PDF
  //--------------------------------------------------

  Future<File> generateInvoice(
    PaymentModel payment,
  ) async {
    final pdf = pw.Document();

    final currency =
        NumberFormat.currency(
      locale: "en_IN",
      symbol: "₹",
      decimalDigits: 2,
    );

    // App Logo
    final logo = await rootBundle.load(
      "assets/images/admin_logo.png",
    );

    final logoImage = pw.MemoryImage(
      logo.buffer.asUint8List(),
    );
        pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),

        build: (context) => [

          //--------------------------------------------------
          // HEADER
          //--------------------------------------------------

          pw.Row(
            crossAxisAlignment:
                pw.CrossAxisAlignment.center,
            children: [

              pw.Container(
                width: 70,
                height: 70,
                child: pw.Image(logoImage),
              ),

              pw.SizedBox(width: 18),

              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                  children: [

                    pw.Text(
                      "Smart Employee Travel System",
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight:
                            pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),

                    pw.SizedBox(height: 4),

                    pw.Text(
                      "Payment Invoice",
                      style: pw.TextStyle(
                        fontSize: 15,
                        color: PdfColors.grey700,
                      ),
                    ),

                    pw.SizedBox(height: 4),

                    pw.Text(
                      "Generated on : ${DateFormat('dd MMM yyyy hh:mm a').format(DateTime.now())}",
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),

          pw.SizedBox(height: 25),

          pw.Divider(),

          pw.SizedBox(height: 20),
                    //--------------------------------------------------
          // INVOICE DETAILS
          //--------------------------------------------------

          pw.Text(
            "Invoice Details",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 15),

          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey400,
              width: 0.8,
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(3),
            },
            children: [

              _tableRow(
                "Invoice No",
                payment.invoiceNumber,
              ),

              _tableRow(
                "Payment ID",
                payment.paymentId,
              ),

              _tableRow(
                "Trip ID",
                payment.tripId,
              ),

              _tableRow(
                "Employee",
                payment.employeeName,
              ),

              _tableRow(
                "Transaction ID",
                payment.transactionId,
              ),

              _tableRow(
                "Payment Method",
                payment.paymentMethod,
              ),

              _tableRow(
                "Payment Status",
                payment.paymentStatus,
              ),

              _tableRow(
                "Payment Date",
                DateFormat(
                  "dd MMM yyyy",
                ).format(
                  payment.paymentDate,
                ),
              ),

              _tableRow(
                "Base Amount",
                currency.format(
                  payment.amount,
                ),
              ),

              _tableRow(
                "GST",
                currency.format(
                  payment.gst,
                ),
              ),

              _tableRow(
                "Total Amount",
                currency.format(
                  payment.totalAmount,
                ),
              ),

            ],
          ),

          pw.SizedBox(height: 25),

          if (payment.remarks.isNotEmpty) ...[

            pw.Text(
              "Remarks",
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 8),

            pw.Container(
              width: double.infinity,
              padding:
                  const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.grey400,
                ),
              ),
              child: pw.Text(
                payment.remarks,
              ),
            ),

            pw.SizedBox(height: 20),

          ],
                  ],
      ),
    );

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
      "${directory.path}/${payment.invoiceNumber}.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    return file;
  }

  //--------------------------------------------------
  // TABLE ROW
  //--------------------------------------------------

  pw.TableRow _tableRow(
    String title,
    String value,
  ) {
    return pw.TableRow(
      children: [

        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          color: PdfColors.grey200,
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),

        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Text(value),
        ),

      ],
    );
  }
}