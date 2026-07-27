import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/payment_model.dart';
import '../../models/trip_model.dart';

import '../../providers/payment_provider.dart';
import '../../providers/trip_provider.dart';

import '../../services/payment_gateway_service.dart';

class PaymentScreen extends StatefulWidget {
  final TripModel trip;

  const PaymentScreen({
    super.key,
    required this.trip,
  });

  @override
  State<PaymentScreen> createState() =>
      _PaymentScreenState();
}

class _PaymentScreenState
    extends State<PaymentScreen> {
  final _formKey =
      GlobalKey<FormState>();

  //----------------------------------------------------------
  // Controllers
  //----------------------------------------------------------

  final TextEditingController
      _nameController =
      TextEditingController();

  final TextEditingController
      _emailController =
      TextEditingController();

  final TextEditingController
      _mobileController =
      TextEditingController();

  final TextEditingController
      _remarksController =
      TextEditingController();

  //----------------------------------------------------------
  // Variables
  //----------------------------------------------------------

  bool _processing = false;

  late double amount;
  late double gst;
  late double total;

  @override
  void initState() {
    super.initState();

    amount =
        widget.trip.totalDistance * 20;

    gst = amount * 0.18;

    total = amount + gst;

    _nameController.text =
        "Employee ${widget.trip.employeeId}";

    _emailController.text =
        "employee${widget.trip.employeeId}@gmail.com";

    _mobileController.text =
        "9999999999";

    PaymentGatewayService.initialize(
      onSuccess: _paymentSuccess,
      onFailure: _paymentFailure,
      onExternalWallet:
          _externalWallet,
    );
  }

  @override
  void dispose() {
    PaymentGatewayService.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _remarksController.dispose();

    super.dispose();
  }

  //----------------------------------------------------------
  // Pay Now
  //----------------------------------------------------------

  void _payNow() {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    PaymentGatewayService.openPayment(
      customerName:
          _nameController.text.trim(),
      email:
          _emailController.text.trim(),
      contact:
          _mobileController.text.trim(),
      amount: total,
      description:
          "Trip ${widget.trip.tripId}",
    );
  }
    //----------------------------------------------------------
  // Payment Success
  //----------------------------------------------------------

  Future<void> _paymentSuccess(
    dynamic response,
  ) async {
    setState(() {
      _processing = true;
    });

    try {
      final payment = PaymentModel(
        paymentId: const Uuid().v4(),

        tripId: widget.trip.tripId,

        employeeId:
            widget.trip.employeeId,

        employeeName:
            _nameController.text.trim(),

        driverId:
            widget.trip.driverId,

        // *****************************
        // NEW FIELD
        // *****************************
        vehicleId:
            widget.trip.vehicleId,

        amount: amount,

        gst: gst,

        totalAmount: total,

        paymentMethod: "Razorpay",

        paymentStatus: "Paid",

        transactionId:
            response.paymentId ?? "",

        razorpayOrderId:
            response.orderId ?? "",

        razorpayPaymentId:
            response.paymentId ?? "",

        razorpaySignature:
            response.signature ?? "",

        invoiceNumber:
            "INV${DateTime.now().millisecondsSinceEpoch}",

        paymentDate:
            DateTime.now(),

        createdAt:
            DateTime.now(),

        updatedAt:
            DateTime.now(),

        remarks:
            _remarksController.text.trim(),
      );

      await context
          .read<PaymentProvider>()
          .addPayment(payment);

      await context
          .read<TripProvider>()
          .updateStatus(
            widget.trip.id!,
            "Completed",
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Payment Successful",
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _processing = false;
        });
      }
    }
  }

  //----------------------------------------------------------
  // Payment Failed
  //----------------------------------------------------------

  void _paymentFailure(
    dynamic response,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          response.message ??
              "Payment Failed",
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  //----------------------------------------------------------
  // External Wallet
  //----------------------------------------------------------

  void _externalWallet(
    dynamic response,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          "Wallet : ${response.walletName}",
        ),
      ),
    );
  }
    //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Payment"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Employee Name",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Enter employee name";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              keyboardType:
                  TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Enter email";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _mobileController,
              keyboardType:
                  TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return "Enter mobile number";
                }

                if (value.length != 10) {
                  return "Enter valid mobile number";
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _remarksController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Remarks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              child: Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  children: [

                    _buildTile(
                      "Trip ID",
                      widget.trip.tripId,
                    ),

                    _buildTile(
                      "Employee ID",
                      widget.trip.employeeId
                          .toString(),
                    ),

                    _buildTile(
                      "Driver ID",
                      widget.trip.driverId
                          .toString(),
                    ),

                    _buildTile(
                      "Vehicle ID",
                      widget.trip.vehicleId
                          .toString(),
                    ),

                    _buildTile(
                      "Distance",
                      "${widget.trip.totalDistance.toStringAsFixed(2)} KM",
                    ),

                    _buildTile(
                      "Amount",
                      "₹${amount.toStringAsFixed(2)}",
                    ),

                    _buildTile(
                      "GST (18%)",
                      "₹${gst.toStringAsFixed(2)}",
                    ),

                    const Divider(),

                    _buildTile(
                      "Total",
                      "₹${total.toStringAsFixed(2)}",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
                        SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: _processing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.payment),
                label: Text(
                  _processing
                      ? "Processing..."
                      : "Pay Now",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                onPressed: _processing
                    ? null
                    : _payNow,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  //----------------------------------------------------------
  // TILE
  //----------------------------------------------------------

  Widget _buildTile(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}  