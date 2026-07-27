import 'dart:io';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../models/payment_model.dart';

class PaymentExcelService {
  PaymentExcelService._();

  static final PaymentExcelService instance =
      PaymentExcelService._();

  //--------------------------------------------------
  // EXPORT PAYMENTS
  //--------------------------------------------------

  Future<File> exportPayments(
    List<PaymentModel> payments,
  ) async {
    final excel = Excel.createExcel();

    final Sheet sheet =
        excel['Payments'];

    sheet.appendRow([
      TextCellValue("Payment ID"),
      TextCellValue("Trip ID"),
      TextCellValue("Employee"),
      TextCellValue("Method"),
      TextCellValue("Status"),
      TextCellValue("Amount"),
      TextCellValue("GST"),
      TextCellValue("Total"),
      TextCellValue("Date"),
    ]);

    final formatter = NumberFormat.currency(
      locale: "en_IN",
      symbol: "₹",
      decimalDigits: 2,
    );
        //--------------------------------------------------
    // ADD PAYMENT DATA
    //--------------------------------------------------

    for (final payment in payments) {
      sheet.appendRow([
        TextCellValue(payment.paymentId),
        TextCellValue(payment.tripId),
        TextCellValue(payment.employeeName),
        TextCellValue(payment.paymentMethod),
        TextCellValue(payment.paymentStatus),
        TextCellValue(
          formatter.format(payment.amount),
        ),
        TextCellValue(
          formatter.format(payment.gst),
        ),
        TextCellValue(
          formatter.format(payment.totalAmount),
        ),
        TextCellValue(
          DateFormat(
            "dd MMM yyyy",
          ).format(
            payment.paymentDate,
          ),
        ),
      ]);
    }

    //--------------------------------------------------
    // AUTO FIT (Optional Widths)
    //--------------------------------------------------

    sheet.setColumnWidth(0, 18);
    sheet.setColumnWidth(1, 18);
    sheet.setColumnWidth(2, 28);
    sheet.setColumnWidth(3, 18);
    sheet.setColumnWidth(4, 15);
    sheet.setColumnWidth(5, 16);
    sheet.setColumnWidth(6, 16);
    sheet.setColumnWidth(7, 16);
    sheet.setColumnWidth(8, 18);
        //--------------------------------------------------
    // SAVE EXCEL FILE
    //--------------------------------------------------

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
      "${directory.path}/Payment_Report_${DateFormat("yyyyMMdd_HHmmss").format(DateTime.now())}.xlsx",
    );

    final bytes = excel.encode();

    if (bytes == null) {
      throw Exception(
        "Failed to generate Excel file.",
      );
    }

    await file.writeAsBytes(bytes);

    return file;
  }
}