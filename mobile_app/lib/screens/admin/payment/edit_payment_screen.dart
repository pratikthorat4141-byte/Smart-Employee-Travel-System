import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/payment_model.dart';
import '../../../providers/payment_provider.dart';

class EditPaymentScreen extends StatefulWidget {
  final PaymentModel payment;

  const EditPaymentScreen({
    super.key,
    required this.payment,
  });

  @override
  State<EditPaymentScreen> createState() =>
      _EditPaymentScreenState();
}

class _EditPaymentScreenState
    extends State<EditPaymentScreen> {
  //--------------------------------------------------
  // FORM KEY
  //--------------------------------------------------

  final _formKey =
      GlobalKey<FormState>();

  //--------------------------------------------------
  // CONTROLLERS
  //--------------------------------------------------

  late final TextEditingController
      _amountController;

  late final TextEditingController
      _gstController;

  late final TextEditingController
      _totalController;

  late final TextEditingController
      _remarksController;

  //--------------------------------------------------
  // VARIABLES
  //--------------------------------------------------

  late String _paymentMethod;
  late String _paymentStatus;

  //--------------------------------------------------
  // INIT
  //--------------------------------------------------

  @override
  void initState() {
    super.initState();

    _paymentMethod =
        widget.payment.paymentMethod;

    _paymentStatus =
        widget.payment.paymentStatus;

    _amountController =
        TextEditingController(
      text: widget.payment.amount
          .toStringAsFixed(2),
    );

    _gstController =
        TextEditingController(
      text: widget.payment.gst
          .toStringAsFixed(2),
    );

    _totalController =
        TextEditingController(
      text: widget.payment.totalAmount
          .toStringAsFixed(2),
    );

    _remarksController =
        TextEditingController(
      text: widget.payment.remarks,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _gstController.dispose();
    _totalController.dispose();
    _remarksController.dispose();

    super.dispose();
  }
    //--------------------------------------------------
  // CALCULATE GST & TOTAL
  //--------------------------------------------------

  void _calculateTotal() {
    final amount = double.tryParse(
          _amountController.text,
        ) ??
        0;

    final gst = amount * 0.18;

    final total = amount + gst;

    _gstController.text =
        gst.toStringAsFixed(2);

    _totalController.text =
        total.toStringAsFixed(2);

    setState(() {});
  }

  //--------------------------------------------------
  // UPDATE PAYMENT
  //--------------------------------------------------

  Future<void> _updatePayment() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final amount = double.tryParse(
          _amountController.text,
        ) ??
        0;

    final gst = double.tryParse(
          _gstController.text,
        ) ??
        0;

    final total = double.tryParse(
          _totalController.text,
        ) ??
        0;

    final updatedPayment =
        widget.payment.copyWith(
      amount: amount,
      gst: gst,
      totalAmount: total,
      paymentMethod: _paymentMethod,
      paymentStatus: _paymentStatus,
      remarks:
          _remarksController.text.trim(),
    );

    final success = await context
        .read<PaymentProvider>()
        .updatePayment(
          updatedPayment,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Payment Updated Successfully"
              : "Failed to Update Payment",
        ),
      ),
    );

    if (success) {
      Navigator.pop(
        context,
        true,
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
          "Edit Payment",
        ),
        centerTitle: true,
      ),

      body: Form(
        key: _formKey,

        child: ListView(
          padding:
              const EdgeInsets.all(16),

          children: [
                        //--------------------------------------------------
            // AMOUNT
            //--------------------------------------------------

            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: "Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Enter Amount";
                }

                final amount =
                    double.tryParse(value);

                if (amount == null ||
                    amount <= 0) {
                  return "Enter Valid Amount";
                }

                return null;
              },
              onChanged: (_) =>
                  _calculateTotal(),
            ),

            const SizedBox(height: 16),

            //--------------------------------------------------
            // GST
            //--------------------------------------------------

            TextFormField(
              controller: _gstController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "GST (18%)",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            //--------------------------------------------------
            // TOTAL
            //--------------------------------------------------

            TextFormField(
              controller: _totalController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Total Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            //--------------------------------------------------
            // PAYMENT METHOD
            //--------------------------------------------------

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
                if (value == null) return;

                setState(() {
                  _paymentMethod = value;
                });
              },
            ),

            const SizedBox(height: 16),

            //--------------------------------------------------
            // PAYMENT STATUS
            //--------------------------------------------------

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
                DropdownMenuItem(
                  value: "Cancelled",
                  child: Text("Cancelled"),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _paymentStatus = value;
                });
              },
            ),

            const SizedBox(height: 16),
                        //--------------------------------------------------
            // REMARKS
            //--------------------------------------------------

            TextFormField(
              controller: _remarksController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Remarks",
                hintText: "Enter Remarks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            //--------------------------------------------------
            // UPDATE BUTTON
            //--------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _updatePayment,
                icon: const Icon(
                  Icons.save,
                ),
                label: const Text(
                  "Update Payment",
                ),
              ),
            ),

            const SizedBox(height: 12),

            //--------------------------------------------------
            // CANCEL BUTTON
            //--------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                ),
                label: const Text(
                  "Cancel",
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