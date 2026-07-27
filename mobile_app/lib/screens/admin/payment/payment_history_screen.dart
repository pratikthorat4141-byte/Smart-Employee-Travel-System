import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../models/payment_model.dart';
import '../../../providers/payment_provider.dart';

import 'payment_receipt_screen.dart';
import 'view_payment_screen.dart';
import 'edit_payment_screen.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({
    super.key,
  });

  @override
  State<PaymentHistoryScreen> createState() =>
      _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState
    extends State<PaymentHistoryScreen> {
  //--------------------------------------------------
  // CONTROLLERS
  //--------------------------------------------------

  final TextEditingController
      _searchController =
      TextEditingController();

  //--------------------------------------------------
  // VARIABLES
  //--------------------------------------------------

  String _status = "All";

  DateTime? _fromDate;
  DateTime? _toDate;

  //--------------------------------------------------
  // INIT
  //--------------------------------------------------

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      context
          .read<PaymentProvider>()
          .loadPayments();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
    //--------------------------------------------------
  // DATE PICKER
  //--------------------------------------------------

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
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
      initialDate:
          _toDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  //--------------------------------------------------
  // FILTER PAYMENTS
  //--------------------------------------------------

  List<PaymentModel> _filterPayments(
    List<PaymentModel> payments,
  ) {
    List<PaymentModel> filtered =
        List.from(payments);

    if (_searchController.text
        .trim()
        .isNotEmpty) {
      final key =
          _searchController.text
              .toLowerCase();

      filtered = filtered.where((e) {
        return e.paymentId
                .toLowerCase()
                .contains(key) ||
            e.tripId
                .toLowerCase()
                .contains(key) ||
            e.employeeName
                .toLowerCase()
                .contains(key) ||
            e.paymentStatus
                .toLowerCase()
                .contains(key);
      }).toList();
    }

    if (_status != "All") {
      filtered = filtered.where((e) {
        return e.paymentStatus ==
            _status;
      }).toList();
    }

    if (_fromDate != null) {
      filtered = filtered.where((e) {
        return !e.paymentDate
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

      filtered = filtered.where((e) {
        return !e.paymentDate
            .isAfter(lastDate);
      }).toList();
    }

    return filtered;
  }

  //--------------------------------------------------
  // REFRESH
  //--------------------------------------------------

  Future<void> _refresh() async {
    await context
        .read<PaymentProvider>()
        .loadPayments();
  }

  //--------------------------------------------------
  // BUILD
  //--------------------------------------------------

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<PaymentProvider>(
      builder: (
        context,
        provider,
        child,
      ) {

        final payments =
            _filterPayments(
          provider.payments,
        );
                return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Payment History",
            ),
            centerTitle: true,
          ),

          body: RefreshIndicator(
            onRefresh: _refresh,

            child: Column(
              children: [

                //--------------------------------------------------
                // SEARCH
                //--------------------------------------------------

                Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: TextField(
                    controller:
                        _searchController,
                    decoration:
                        InputDecoration(
                      hintText:
                          "Search Payment",
                      prefixIcon:
                          const Icon(
                        Icons.search,
                      ),
                      suffixIcon:
                          IconButton(
                        icon: const Icon(
                          Icons.clear,
                        ),
                        onPressed: () {
                          _searchController
                              .clear();

                          setState(() {});
                        },
                      ),
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
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
                  child: Row(
                    children: [

                      Expanded(
                        child:
                            OutlinedButton.icon(
                          onPressed:
                              _pickFromDate,
                          icon: const Icon(
                            Icons
                                .calendar_today,
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

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child:
                            OutlinedButton.icon(
                          onPressed:
                              _pickToDate,
                          icon: const Icon(
                            Icons
                                .calendar_today,
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

                      IconButton(
                        onPressed: () {
                          setState(() {
                            _fromDate = null;
                            _toDate = null;
                          });
                        },
                        icon: const Icon(
                          Icons.clear,
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 12),

                //--------------------------------------------------
                // STATUS FILTER
                //--------------------------------------------------

                SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Row(
                    children: [

                      _chip("All"),

                      _chip("Paid"),

                      _chip("Pending"),

                      _chip("Failed"),

                      _chip("Cancelled"),

                    ],
                  ),
                ),

                const SizedBox(height: 10),
                                //--------------------------------------------------
                // SUMMARY
                //--------------------------------------------------

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        16,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [

                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [

                              const Text(
                                "Total Payments",
                                style: TextStyle(
                                  color:
                                      Colors.grey,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                "${payments.length}",
                                style:
                                    const TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .end,
                            children: [

                              const Text(
                                "Collection",
                                style: TextStyle(
                                  color:
                                      Colors.grey,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                "₹${payments.fold<double>(0, (sum, e) => sum + e.totalAmount).toStringAsFixed(2)}",
                                style:
                                    const TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  color:
                                      Colors.green,
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                //--------------------------------------------------
                // PAYMENT LIST
                //--------------------------------------------------

                Expanded(
                  child: provider.isLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator(),
                        )
                      : payments.isEmpty
                          ? const Center(
                              child: Text(
                                "No Payments Found",
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.all(
                                12,
                              ),
                              itemCount:
                                  payments.length,
                              itemBuilder:
                                  (
                                context,
                                index,
                              ) {
                                final payment =
                                    payments[
                                        index];

                                return Card(
                                  margin:
                                      const EdgeInsets.only(
                                    bottom: 12,
                                  ),

                                  child:
                                      ListTile(

                                    leading:
                                        CircleAvatar(
                                      backgroundColor:
                                          _statusColor(
                                        payment
                                            .paymentStatus,
                                      ),
                                      child:
                                          const Icon(
                                        Icons
                                            .payments,
                                        color: Colors
                                            .white,
                                      ),
                                    ),

                                    title: Text(
                                      payment
                                          .employeeName,
                                    ),

                                    subtitle:
                                        Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [

                                        Text(
                                          payment
                                              .paymentId,
                                        ),

                                        Text(
                                          payment
                                              .tripId,
                                        ),

                                        Text(
                                          payment
                                              .paymentStatus,
                                        ),

                                        Text(
                                          "₹${payment.totalAmount.toStringAsFixed(2)}",
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                      ],
                                    ),

                                    trailing:
                                        PopupMenuButton<
                                            String>(
                                      onSelected:
                                          (
                                        value,
                                      ) {

                                        switch (
                                            value) {

                                          case "view":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) =>
                                                        ViewPaymentScreen(
                                                  payment:
                                                      payment,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "receipt":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) =>
                                                        PaymentReceiptScreen(
                                                  payment:
                                                      payment,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "edit":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) =>
                                                        EditPaymentScreen(
                                                  payment:
                                                      payment,
                                                ),
                                              ),
                                            );
                                            break;

                                        }

                                      },

                                      itemBuilder:
                                          (_) =>
                                              const [

                                        PopupMenuItem(
                                          value:
                                              "view",
                                          child: Text(
                                              "View"),
                                        ),

                                        PopupMenuItem(
                                          value:
                                              "receipt",
                                          child: Text(
                                              "Receipt"),
                                        ),

                                        PopupMenuItem(
                                          value:
                                              "edit",
                                          child: Text(
                                              "Edit"),
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
          ),
        );
      },
    );
  }

  //--------------------------------------------------
  // STATUS CHIP
  //--------------------------------------------------

  Widget _chip(String value) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
      ),
      child: ChoiceChip(
        label: Text(value),
        selected: _status == value,
        onSelected: (_) {
          setState(() {
            _status = value;
          });
        },
      ),
    );
  }

  //--------------------------------------------------
  // STATUS COLOR
  //--------------------------------------------------

  Color _statusColor(String status) {
    switch (status) {
      case "Paid":
        return Colors.green;

      case "Pending":
        return Colors.orange;

      case "Failed":
        return Colors.red;

      case "Cancelled":
        return Colors.grey;

      default:
        return Colors.blue;
    }
  }
}