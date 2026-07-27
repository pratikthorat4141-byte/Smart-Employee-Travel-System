import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/payment_model.dart';
import '../../../providers/payment_provider.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() =>
      _AddPaymentScreenState();
}

class _AddPaymentScreenState
    extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  //--------------------------------------------------
  // Controllers
  //--------------------------------------------------

  final _paymentId = TextEditingController();

  final _tripId = TextEditingController();

  final _employeeId = TextEditingController();

  final _employeeName = TextEditingController();

  final _driverId = TextEditingController();

  // NEW
  final _vehicleId = TextEditingController();

  final _amount = TextEditingController();

  final _gst = TextEditingController();

  final _total = TextEditingController();

  final _transactionId =
      TextEditingController();

  final _invoiceNumber =
      TextEditingController();

  final _remarks =
      TextEditingController();

  //--------------------------------------------------
  // Variables
  //--------------------------------------------------

  DateTime _paymentDate =
      DateTime.now();

  String _paymentMethod = "UPI";

  String _paymentStatus = "Paid";

  @override
  void initState() {
    super.initState();

    final millis =
        DateTime.now().millisecondsSinceEpoch;

    _paymentId.text = "PAY$millis";

    _invoiceNumber.text = "INV$millis";
  }
    @override
  void dispose() {
    _paymentId.dispose();
    _tripId.dispose();
    _employeeId.dispose();
    _employeeName.dispose();
    _driverId.dispose();
    _vehicleId.dispose();
    _amount.dispose();
    _gst.dispose();
    _total.dispose();
    _transactionId.dispose();
    _invoiceNumber.dispose();
    _remarks.dispose();

    super.dispose();
  }

  //--------------------------------------------------
  // GST Calculation
  //--------------------------------------------------

  void calculateGST() {
    final amount =
        double.tryParse(_amount.text) ?? 0;

    final gst = amount * 0.18;

    _gst.text = gst.toStringAsFixed(2);

    _total.text =
        (amount + gst).toStringAsFixed(2);

    setState(() {});
  }

  //--------------------------------------------------
  // UI
  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Payment"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            TextFormField(
              controller: _tripId,
              decoration: const InputDecoration(
                labelText: "Trip ID",
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty
                      ? "Enter Trip ID"
                      : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _employeeId,
              keyboardType:
                  TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Employee ID",
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty
                      ? "Enter Employee ID"
                      : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _employeeName,
              decoration: const InputDecoration(
                labelText: "Employee Name",
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty
                      ? "Enter Employee Name"
                      : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _driverId,
              keyboardType:
                  TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Driver ID",
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty
                      ? "Enter Driver ID"
                      : null,
            ),

            const SizedBox(height: 16),

            // ******** NEW FIELD ********

            TextFormField(
              controller: _vehicleId,
              keyboardType:
                  TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Vehicle ID",
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty
                      ? "Enter Vehicle ID"
                      : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _amount,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: "Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => calculateGST(),
              validator: (v) =>
                  v == null || v.isEmpty
                      ? "Enter Amount"
                      : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _gst,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "GST (18%)",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _total,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Total Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: const InputDecoration(
                labelText: "Payment Method",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "UPI",
                  child: Text("UPI"),
                ),
                DropdownMenuItem(
                  value: "Cash",
                  child: Text("Cash"),
                ),
                DropdownMenuItem(
                  value: "Credit Card",
                  child: Text("Credit Card"),
                ),
                DropdownMenuItem(
                  value: "Debit Card",
                  child: Text("Debit Card"),
                ),
                DropdownMenuItem(
                  value: "Net Banking",
                  child: Text("Net Banking"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _paymentMethod = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _paymentStatus,
              decoration: const InputDecoration(
                labelText: "Payment Status",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Paid",
                  child: Text("Paid"),
                ),
                DropdownMenuItem(
                  value: "Pending",
                  child: Text("Pending"),
                ),
                DropdownMenuItem(
                  value: "Failed",
                  child: Text("Failed"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _paymentStatus = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _transactionId,
              decoration: const InputDecoration(
                labelText: "Transaction ID",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Enter Transaction ID";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _invoiceNumber,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Invoice Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              title: const Text(
                "Payment Date",
              ),
              subtitle: Text(
                DateFormat(
                  "dd MMM yyyy",
                ).format(_paymentDate),
              ),
              trailing: const Icon(
                Icons.calendar_month,
              ),
              onTap: () async {
                final picked =
                    await showDatePicker(
                  context: context,
                  initialDate: _paymentDate,
                  firstDate:
                      DateTime(2020),
                  lastDate:
                      DateTime(2100),
                );

                if (picked != null) {
                  setState(() {
                    _paymentDate = picked;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _remarks,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Remarks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),
                        SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text(
                  "Save Payment",
                ),
                onPressed: () async {

                  if (!_formKey.currentState!
                      .validate()) {
                    return;
                  }

                  final payment = PaymentModel(
                    paymentId:
                        _paymentId.text.trim(),

                    tripId:
                        _tripId.text.trim(),

                    employeeId:
                        int.parse(
                          _employeeId.text,
                        ),

                    employeeName:
                        _employeeName.text.trim(),

                    driverId:
                        int.parse(
                          _driverId.text,
                        ),

                    // *************************
                    // NEW FIELD
                    // *************************

                    vehicleId:
                        int.parse(
                          _vehicleId.text,
                        ),

                    amount:
                        double.parse(
                          _amount.text,
                        ),

                    gst:
                        double.parse(
                          _gst.text,
                        ),

                    totalAmount:
                        double.parse(
                          _total.text,
                        ),

                    paymentMethod:
                        _paymentMethod,

                    paymentStatus:
                        _paymentStatus,

                    transactionId:
                        _transactionId.text
                            .trim(),

                    invoiceNumber:
                        _invoiceNumber.text
                            .trim(),

                    paymentDate:
                        _paymentDate,

                    createdAt:
                        DateTime.now(),

                    remarks:
                        _remarks.text.trim(),
                  );

                  final success = await context
                      .read<PaymentProvider>()
                      .addPayment(payment);

                  if (!mounted) return;

                  if (success) {
                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Payment Added Successfully",
                        ),
                      ),
                    );

                    Navigator.pop(
                      context,
                      true,
                    );
                  } else {
                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                        backgroundColor:
                            Colors.red,
                        content: Text(
                          "Unable to save payment",
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 20),
                      ],
        ),
      ),
    );
  }
}