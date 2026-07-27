import 'dart:math';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
class PaymentGatewayService {
  PaymentGatewayService._();

  static final Razorpay _razorpay =
      Razorpay();

  //--------------------------------------------------
  // CALLBACKS
  //--------------------------------------------------

  static Function(
    PaymentSuccessResponse,
  )? _onSuccess;

  static Function(
    PaymentFailureResponse,
  )? _onFailure;

  static Function(
    ExternalWalletResponse,
  )? _onExternalWallet;

  //--------------------------------------------------
  // INITIALIZE
  //--------------------------------------------------

  static void initialize({

    required Function(
      PaymentSuccessResponse,
    ) onSuccess,

    required Function(
      PaymentFailureResponse,
    ) onFailure,

    required Function(
      ExternalWalletResponse,
    ) onExternalWallet,

  }) {

    _onSuccess = onSuccess;

    _onFailure = onFailure;

    _onExternalWallet =
        onExternalWallet;

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handleSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _handleFailure,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );
  }

  //--------------------------------------------------
  // OPEN PAYMENT
  //--------------------------------------------------

  static void openPayment({

    required String customerName,

    required String email,

    required String contact,

    required double amount,

    required String description,

  }) {

    final options = {

      'key':
          'YOUR_RAZORPAY_KEY',

      'amount':
          (amount * 100).toInt(),

      'name':
          'Smart Employee Travel',

      'description':
          description,

      'prefill': {

        'contact': contact,

        'email': email,

        'name': customerName,

      },

      'theme': {

        'color': '#1565C0',

      },

    };

    try {

      _razorpay.open(options);

    } catch (e) {

      debugPrint(
        e.toString(),
      );

    }

  }
    //--------------------------------------------------
  // PAYMENT SUCCESS
  //--------------------------------------------------

  static void _handleSuccess(
    PaymentSuccessResponse response,
  ) {

    if (_onSuccess != null) {

      _onSuccess!(response);

    }

    debugPrint(
      "Payment Success : ${response.paymentId}",
    );
  }

  //--------------------------------------------------
  // PAYMENT FAILURE
  //--------------------------------------------------

  static void _handleFailure(
    PaymentFailureResponse response,
  ) {

    if (_onFailure != null) {

      _onFailure!(response);

    }

    debugPrint(
      "Payment Failed : ${response.code}",
    );

    debugPrint(
      response.message ?? "",
    );
  }

  //--------------------------------------------------
  // EXTERNAL WALLET
  //--------------------------------------------------

  static void _handleExternalWallet(
    ExternalWalletResponse response,
  ) {

    if (_onExternalWallet != null) {

      _onExternalWallet!(response);

    }

    debugPrint(
      "External Wallet : ${response.walletName}",
    );
  }

  //--------------------------------------------------
  // GENERATE TRANSACTION ID
  //--------------------------------------------------

  static String generateTransactionId() {

    final random = Random();

    final time =
        DateTime.now().millisecondsSinceEpoch;

    final number =
        random.nextInt(999999);

    return "TXN${time}_$number";
  }

  //--------------------------------------------------
  // GENERATE RECEIPT ID
  //--------------------------------------------------

  static String generateReceiptId() {

    final random = Random();

    return "REC${DateTime.now().millisecondsSinceEpoch}${random.nextInt(999)}";
  }

  //--------------------------------------------------
  // VERIFY PAYMENT
  //--------------------------------------------------

  static bool verifyPayment({
    required String? paymentId,
    required String? signature,
  }) {

    return paymentId != null &&
        paymentId.isNotEmpty &&
        signature != null &&
        signature.isNotEmpty;
  }
    //--------------------------------------------------
  // SUPPORTED PAYMENT METHODS
  //--------------------------------------------------

  static const List<String>
      supportedMethods = [

    "UPI",

    "Credit Card",

    "Debit Card",

    "Net Banking",

    "Wallet",

    "EMI",

  ];

  //--------------------------------------------------
  // FORMAT AMOUNT
  //--------------------------------------------------

  static String formatAmount(
    double amount,
  ) {
    return "₹${amount.toStringAsFixed(2)}";
  }

  //--------------------------------------------------
  // BUILD PAYMENT OPTIONS
  //--------------------------------------------------

  static Map<String, dynamic>
      buildPaymentOptions({

    required String key,

    required double amount,

    required String customerName,

    required String email,

    required String contact,

    required String description,

    String companyName =
        "Smart Employee Travel System",

  }) {

    return {

      'key': key,

      'amount':
          (amount * 100).round(),

      'name':
          companyName,

      'description':
          description,

      'prefill': {

        'name':
            customerName,

        'email':
            email,

        'contact':
            contact,

      },

      'theme': {

        'color':
            '#1565C0',

      },

      'retry': {

        'enabled': true,

        'max_count': 3,

      },

      'send_sms_hash': true,

    };

  }

  //--------------------------------------------------
  // OPEN CUSTOM PAYMENT
  //--------------------------------------------------

  static void openCustomPayment(
    Map<String, dynamic> options,
  ) {

    try {

      _razorpay.open(options);

    } catch (e) {

      debugPrint(
        "Payment Error : $e",
      );

    }

  }

  //--------------------------------------------------
  // PAYMENT STATUS
  //--------------------------------------------------

  static bool isPaymentSuccessful(
    PaymentSuccessResponse response,
  ) {
    return response.paymentId != null;
  }

  static bool isPaymentFailed(
    PaymentFailureResponse response,
  ) {
    return response.code != null;
  }

  //--------------------------------------------------
  // CHECK WALLET
  //--------------------------------------------------

  static bool hasExternalWallet(
    ExternalWalletResponse response,
  ) {
    return response.walletName != null;
  }
    //--------------------------------------------------
  // CLEAR CALLBACKS
  //--------------------------------------------------

  static void clearCallbacks() {
    _onSuccess = null;
    _onFailure = null;
    _onExternalWallet = null;
  }

  //--------------------------------------------------
  // RESET SERVICE
  //--------------------------------------------------

  static void resetService() {
    clearCallbacks();

    try {
      _razorpay.clear();
    } catch (_) {}
  }

  //--------------------------------------------------
  // DISPOSE
  //--------------------------------------------------

  static void dispose() {
    clearCallbacks();

    try {
      _razorpay.clear();
    } catch (_) {}

    debugPrint(
      "PaymentGatewayService Disposed",
    );
  }

  //--------------------------------------------------
  // GET PAYMENT STATUS TEXT
  //--------------------------------------------------

  static String paymentStatusText(
    bool success,
  ) {
    return success
        ? "Payment Successful"
        : "Payment Failed";
  }

  //--------------------------------------------------
  // GET PAYMENT STATUS COLOR
  //--------------------------------------------------

  static Color paymentStatusColor(
    bool success,
  ) {
    return success
        ? Colors.green
        : Colors.red;
  }

  //--------------------------------------------------
  // GET PAYMENT STATUS ICON
  //--------------------------------------------------

  static IconData paymentStatusIcon(
    bool success,
  ) {
    return success
        ? Icons.check_circle
        : Icons.cancel;
  }
}