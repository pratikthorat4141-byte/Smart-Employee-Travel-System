import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../models/payment_model.dart';
import '../../../providers/payment_provider.dart';

import '../../../services/payment_excel_service.dart';
import '../../../services/payment_pdf_service.dart';
import '../../../services/payment_share_service.dart';

import 'view_payment_screen.dart';

class PaymentDashboardScreen extends StatefulWidget {
  const PaymentDashboardScreen({
    super.key,
  });

  @override
  State<PaymentDashboardScreen> createState() =>
      _PaymentDashboardScreenState();
}

class _PaymentDashboardScreenState
    extends State<PaymentDashboardScreen> {

  //--------------------------------------------------
  // Controllers
  //--------------------------------------------------

  final TextEditingController _searchController =
      TextEditingController();

  //--------------------------------------------------
  // Services
  //--------------------------------------------------

  final PaymentPdfService _pdfService =
      PaymentPdfService.instance;

  final PaymentExcelService _excelService =
      PaymentExcelService.instance;

  final PaymentShareService _shareService =
      PaymentShareService.instance;

  //--------------------------------------------------
  // Filters
  //--------------------------------------------------

  DateTime? _fromDate;
  DateTime? _toDate;

  //--------------------------------------------------
  // Init
  //--------------------------------------------------

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context
            .read<PaymentProvider>()
            .loadPayments();
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
    //--------------------------------------------------
  // Date Picker
  //--------------------------------------------------

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  //--------------------------------------------------
  // Snackbar
  //--------------------------------------------------

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  //--------------------------------------------------
  // Filter Payments
  //--------------------------------------------------

  List<PaymentModel> _filterPayments(
    List<PaymentModel> payments,
  ) {
    List<PaymentModel> filtered = List.from(payments);

    if (_searchController.text.trim().isNotEmpty) {
      final keyword =
          _searchController.text
              .trim()
              .toLowerCase();

      filtered = filtered.where((payment) {
        return payment.paymentId
                .toLowerCase()
                .contains(keyword) ||
            payment.tripId
                .toLowerCase()
                .contains(keyword) ||
            payment.employeeName
                .toLowerCase()
                .contains(keyword) ||
            payment.paymentStatus
                .toLowerCase()
                .contains(keyword);
      }).toList();
    }

    if (_fromDate != null) {
      filtered = filtered.where((payment) {
        return !payment.paymentDate
            .isBefore(_fromDate!);
      }).toList();
    }

    if (_toDate != null) {
      final lastDate = DateTime(
        _toDate!.year,
        _toDate!.month,
        _toDate!.day,
        23,
        59,
        59,
      );

      filtered = filtered.where((payment) {
        return !payment.paymentDate
            .isAfter(lastDate);
      }).toList();
    }

    return filtered;
  }
    //--------------------------------------------------
  // Export PDF
  //--------------------------------------------------

  Future<void> _exportPdf(
    PaymentModel payment,
  ) async {
    try {
      final file =
          await _pdfService.generateInvoice(
        payment,
      );

      _showMessage(
        "PDF Saved\n${file.path}",
      );
    } catch (e) {
      _showMessage(
        "PDF Export Failed\n$e",
      );
    }
  }

  //--------------------------------------------------
  // Export Excel
  //--------------------------------------------------

  Future<void> _exportExcel(
    List<PaymentModel> payments,
  ) async {
    try {
      final file =
          await _excelService.exportPayments(
        payments,
      );

      _showMessage(
        "Excel Saved\n${file.path}",
      );
    } catch (e) {
      _showMessage(
        "Excel Export Failed\n$e",
      );
    }
  }

  //--------------------------------------------------
  // Share PDF
  //--------------------------------------------------

  Future<void> _sharePdf(
    PaymentModel payment,
  ) async {
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
      _showMessage(
        "Share Failed\n$e",
      );
    }
  }

  //--------------------------------------------------
  // Print PDF
  //--------------------------------------------------

  Future<void> _printPdf(
    PaymentModel payment,
  ) async {
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
      _showMessage(
        "Print Failed\n$e",
      );
    }
  }

  //--------------------------------------------------
  // Delete Payment
  //--------------------------------------------------

  Future<void> _deletePayment(
    PaymentModel payment,
  ) async {
    final provider =
        context.read<PaymentProvider>();

    final success =
        await provider.deletePayment(
      payment.id!,
    );

    if (!mounted) return;

    _showMessage(
      success
          ? "Payment deleted successfully."
          : "Unable to delete payment.",
    );
  }

  //--------------------------------------------------
  // Confirm Delete
  //--------------------------------------------------

  Future<void> _confirmDelete(
    PaymentModel payment,
  ) async {
    final result =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Delete Payment",
        ),
        content: Text(
          "Delete ${payment.paymentId} ?",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
              context,
              false,
            ),
            child: const Text(
              "Cancel",
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(
              context,
              true,
            ),
            child: const Text(
              "Delete",
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await _deletePayment(payment);
    }
  }
    //--------------------------------------------------
  // DATE FILTER CARD
  //--------------------------------------------------

  Widget _dateFilterCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickFromDate,
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _fromDate == null
                          ? "From Date"
                          : DateFormat(
                              "dd MMM yyyy",
                            ).format(_fromDate!),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickToDate,
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _toDate == null
                          ? "To Date"
                          : DateFormat(
                              "dd MMM yyyy",
                            ).format(_toDate!),
                    ),
                  ),
                ),
              ],
            ),

            if (_fromDate != null ||
                _toDate != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _fromDate = null;
                      _toDate = null;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text(
                    "Clear Filter",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------------
  // BUILD
  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(
      builder: (
        context,
        provider,
        child,
      ) {
        final payments = _filterPayments(
          provider.payments,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Payment Dashboard",
            ),
            centerTitle: true,
          ),

          body: Column(
            children: [

              //--------------------------------------------------
              // SEARCH
              //--------------------------------------------------

              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search Payment...",
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),

              //--------------------------------------------------
              // DATE FILTER
              //--------------------------------------------------

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: _dateFilterCard(),
              ),

              const SizedBox(height: 12),

              //--------------------------------------------------
              // EXPORT
              //--------------------------------------------------

              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [

                    Expanded(
                      child:
                          ElevatedButton.icon(
                        onPressed:
                            payments.isEmpty
                                ? null
                                : () => _exportExcel(
                                      payments,
                                    ),
                        icon: const Icon(
                          Icons.table_chart,
                        ),
                        label: const Text(
                          "Export Excel",
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      "Total : ${payments.length}",
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              //--------------------------------------------------
              // PAYMENT LIST
              //--------------------------------------------------

              Expanded(
                child: payments.isEmpty
                    ? const Center(
                        child: Text(
                          "No Payments Found",
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            payments.length,
                        itemBuilder:
                            (context, index) {
                          final payment =
                              payments[index];
                                                        return Card(
                            margin:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            elevation: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(
                                16,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [

                                  Text(
                                    payment.paymentId,
                                    style:
                                        const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 8,
                                  ),

                                  Text(
                                    "Employee : ${payment.employeeName}",
                                  ),

                                  Text(
                                    "Trip : ${payment.tripId}",
                                  ),

                                  Text(
                                    "Method : ${payment.paymentMethod}",
                                  ),

                                  Text(
                                    "Status : ${payment.paymentStatus}",
                                    style: TextStyle(
                                      color: payment.paymentStatus ==
                                              "Paid"
                                          ? Colors.green
                                          : payment.paymentStatus ==
                                                  "Pending"
                                              ? Colors.orange
                                              : Colors.red,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    "Amount : ₹${payment.totalAmount.toStringAsFixed(2)}",
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  Text(
                                    DateFormat(
                                      "dd MMM yyyy",
                                    ).format(
                                      payment.paymentDate,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 14,
                                  ),

                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [

                                      OutlinedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ViewPaymentScreen(
                                                payment:
                                                    payment,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.visibility,
                                        ),
                                        label: const Text(
                                          "View",
                                        ),
                                      ),

                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            _exportPdf(
                                                payment),
                                        icon: const Icon(
                                          Icons.picture_as_pdf,
                                        ),
                                        label: const Text(
                                          "PDF",
                                        ),
                                      ),

                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            _sharePdf(
                                                payment),
                                        icon: const Icon(
                                          Icons.share,
                                        ),
                                        label: const Text(
                                          "Share",
                                        ),
                                      ),

                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            _printPdf(
                                                payment),
                                        icon: const Icon(
                                          Icons.print,
                                        ),
                                        label: const Text(
                                          "Print",
                                        ),
                                      ),

                                      ElevatedButton.icon(
                                        style:
                                            ElevatedButton
                                                .styleFrom(
                                          backgroundColor:
                                              Colors.red,
                                        ),
                                        onPressed: () =>
                                            _confirmDelete(
                                                payment),
                                        icon: const Icon(
                                          Icons.delete,
                                        ),
                                        label: const Text(
                                          "Delete",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}