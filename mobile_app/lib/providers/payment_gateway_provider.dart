import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../models/payment_model.dart';
import '../services/payment_gateway_service.dart';
import 'payment_provider.dart';

class PaymentGatewayProvider extends ChangeNotifier {
  bool _isProcessing = false;

  String? _paymentStatus;

  String? _paymentId;

  String? _error;

  bool get isProcessing => _isProcessing;

  String? get paymentStatus => _paymentStatus;

  String? get paymentId => _paymentId;

  String? get error => _error;

  //----------------------------------------------------------
  // INITIALIZE
  //----------------------------------------------------------

  void initialize() {
    PaymentGatewayService.initialize(
      onSuccess: _handleSuccess,
      onFailure: _handleFailure,
      onExternalWallet: _handleWallet,
    );
  }

  //----------------------------------------------------------
  // START PAYMENT
  //----------------------------------------------------------

  Future<void> startPayment({
    required PaymentModel payment,
    required String customerName,
    required String email,
    required String mobile,
  }) async {
    _isProcessing = true;
    _paymentStatus = null;
    _error = null;

    notifyListeners();

    PaymentGatewayService.openPayment(
      customerName: customerName,
      email: email,
      contact: mobile,
      amount: payment.totalAmount,
      description:
          "Trip Payment ${payment.tripId}",
    );
  }

  //----------------------------------------------------------
  // SUCCESS
  //----------------------------------------------------------

  Future<void> _handleSuccess(
    PaymentSuccessResponse response,
  ) async {
    _paymentId = response.paymentId;

    _paymentStatus = "Paid";

    _isProcessing = false;

    notifyListeners();
  }

  //----------------------------------------------------------
  // FAILURE
  //----------------------------------------------------------

  Future<void> _handleFailure(
    PaymentFailureResponse response,
  ) async {
    _paymentStatus = "Failed";

    _error = response.message;

    _isProcessing = false;

    notifyListeners();
  }

  //----------------------------------------------------------
  // EXTERNAL WALLET
  //----------------------------------------------------------

  void _handleWallet(
    ExternalWalletResponse response,
  ) {
    debugPrint(
      "Wallet : ${response.walletName}",
    );
  }

  //----------------------------------------------------------
  // SAVE PAYMENT
  //----------------------------------------------------------

  Future<bool> savePayment(
      PaymentModel payment) async {
    return await PaymentProvider.instance
        .addPayment(payment);
  }

  //----------------------------------------------------------
  // RESET
  //----------------------------------------------------------

  void reset() {
    _paymentStatus = null;
    _paymentId = null;
    _error = null;
    _isProcessing = false;

    notifyListeners();
  }

  //----------------------------------------------------------
  // DISPOSE
  //----------------------------------------------------------

  @override
  void dispose() {
    PaymentGatewayService.dispose();
    super.dispose();
  }
}