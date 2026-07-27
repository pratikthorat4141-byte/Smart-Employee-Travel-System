import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../models/payment_model.dart';
import '../../../services/payment_pdf_service.dart';
import '../../../services/payment_share_service.dart';

class ViewPaymentScreen extends StatefulWidget {
  final PaymentModel payment;

  const ViewPaymentScreen({
    super.key,
    required this.payment,
  });

  @override
  State<ViewPaymentScreen> createState() =>
      _ViewPaymentScreenState();
}

class _ViewPaymentScreenState
    extends State<ViewPaymentScreen> {
  //--------------------------------------------------
  // SERVICES
  //--------------------------------------------------

  final PaymentPdfService _pdfService =
      PaymentPdfService.instance;

  final PaymentShareService _shareService =
      PaymentShareService.instance;

  //--------------------------------------------------
  // GETTERS
  //--------------------------------------------------

  PaymentModel get payment => widget.payment;

  late final NumberFormat currency;

  @override
  void initState() {
    super.initState();

    currency = NumberFormat.currency(
      locale: "en_IN",
      symbol: "₹",
      decimalDigits: 2,
    );
  }

  //--------------------------------------------------
  // EXPORT PDF
  //--------------------------------------------------

  Future<void> _exportPdf() async {
    try {
      final file =
          await _pdfService.generateInvoice(
        payment,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "PDF Saved\n${file.path}",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  //--------------------------------------------------
  // SHARE PDF
  //--------------------------------------------------

  Future<void> _sharePdf() async {
    try {
      final File file =
          await _pdfService.generateInvoice(
        payment,
      );

      await _shareService.shareFile(
        file,
        subject: "Payment Invoice",
        text:
            "Invoice : ${payment.invoiceNumber}",
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  //--------------------------------------------------
  // PRINT PDF
  //--------------------------------------------------

  Future<void> _printPdf() async {
    try {
      final File file =
          await _pdfService.generateInvoice(
        payment,
      );

      await Printing.layoutPdf(
        onLayout: (_) async =>
            file.readAsBytes(),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  //--------------------------------------------------
  // BUILD
  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Details",
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),

          child: Padding(
            padding:
                const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                                //------------------------------------------------
                // HEADER
                //------------------------------------------------

                const Center(
                  child: CircleAvatar(
                    radius: 38,
                    child: Icon(
                      Icons.payments,
                      size: 38,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: Text(
                    "Payment Information",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                const SizedBox(height: 25),

                //------------------------------------------------
                // BASIC DETAILS
                //------------------------------------------------

                _detailTile(
                  "Payment ID",
                  payment.paymentId,
                  Icons.confirmation_number,
                ),

                _detailTile(
                  "Trip ID",
                  payment.tripId,
                  Icons.route,
                ),

                _detailTile(
                  "Employee",
                  payment.employeeName,
                  Icons.person,
                ),

                _detailTile(
                  "Employee ID",
                  payment.employeeId.toString(),
                  Icons.badge,
                ),

                _detailTile(
                  "Driver ID",
                  payment.driverId.toString(),
                  Icons.drive_eta,
                ),

                const Divider(height: 30),

                //------------------------------------------------
                // AMOUNT DETAILS
                //------------------------------------------------

                _detailTile(
                  "Amount",
                  currency.format(payment.amount),
                  Icons.account_balance_wallet,
                ),

                _detailTile(
                  "GST",
                  currency.format(payment.gst),
                  Icons.receipt_long,
                ),

                _detailTile(
                  "Total Amount",
                  currency.format(payment.totalAmount),
                  Icons.payments,
                ),

                const Divider(height: 30),
                                //------------------------------------------------
                // PAYMENT DETAILS
                //------------------------------------------------

                _detailTile(
                  "Payment Method",
                  payment.paymentMethod,
                  Icons.credit_card,
                ),

                _detailTile(
                  "Transaction ID",
                  payment.transactionId,
                  Icons.swap_horiz,
                ),

                _detailTile(
                  "Invoice Number",
                  payment.invoiceNumber,
                  Icons.receipt,
                ),

                _detailTile(
                  "Payment Status",
                  payment.paymentStatus,
                  Icons.verified,
                  valueColor: payment.paymentStatus == "Paid"
                      ? Colors.green
                      : payment.paymentStatus == "Pending"
                          ? Colors.orange
                          : Colors.red,
                ),

                _detailTile(
                  "Payment Date",
                  DateFormat(
                    "dd MMM yyyy",
                  ).format(
                    payment.paymentDate,
                  ),
                  Icons.calendar_today,
                ),

                _detailTile(
                  "Created At",
                  DateFormat(
                    "dd MMM yyyy  hh:mm a",
                  ).format(
                    payment.createdAt,
                  ),
                  Icons.access_time,
                ),

                if (payment.remarks.isNotEmpty) ...[
                  const Divider(height: 30),

                  const Text(
                    "Remarks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Text(
                      payment.remarks,
                    ),
                  ),
                ],

                const SizedBox(height: 30),
                                //------------------------------------------------
                // ACTION BUTTONS
                //------------------------------------------------

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _exportPdf,
                        icon: const Icon(
                          Icons.picture_as_pdf,
                        ),
                        label: const Text(
                          "PDF",
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _sharePdf,
                        icon: const Icon(
                          Icons.share,
                        ),
                        label: const Text(
                          "Share",
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _printPdf,
                        icon: const Icon(
                          Icons.print,
                        ),
                        label: const Text(
                          "Print",
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    label: const Text(
                      "Back",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //------------------------------------------------
  // DETAIL TILE
  //------------------------------------------------

  Widget _detailTile(
    String title,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                Colors.blue.shade50,
            child: Icon(
              icon,
              color: Colors.blue,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                SelectableText(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        valueColor ??
                        Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}