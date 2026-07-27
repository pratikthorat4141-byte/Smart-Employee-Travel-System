class PaymentModel {
  final int? id;

  //----------------------------------------------------------
  // BASIC
  //----------------------------------------------------------

  final String paymentId;
  final String tripId;

  //----------------------------------------------------------
  // EMPLOYEE
  //----------------------------------------------------------

  final int employeeId;
  final String employeeName;

  //----------------------------------------------------------
  // DRIVER / VEHICLE
  //----------------------------------------------------------

  final int driverId;
  final int vehicleId;

  //----------------------------------------------------------
  // AMOUNT
  //----------------------------------------------------------

  final double amount;
  final double gst;
  final double totalAmount;

  //----------------------------------------------------------
  // PAYMENT
  //----------------------------------------------------------

  final String paymentMethod;
  final String paymentStatus;

  final String transactionId;

  //----------------------------------------------------------
  // RAZORPAY
  //----------------------------------------------------------

  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  //----------------------------------------------------------
  // INVOICE
  //----------------------------------------------------------

  final String invoiceNumber;

  //----------------------------------------------------------
  // DATES
  //----------------------------------------------------------

  final DateTime paymentDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  //----------------------------------------------------------
  // OTHER
  //----------------------------------------------------------

  final String remarks;

  const PaymentModel({
    this.id,

    required this.paymentId,
    required this.tripId,

    required this.employeeId,
    required this.employeeName,

    required this.driverId,
    required this.vehicleId,

    required this.amount,
    required this.gst,
    required this.totalAmount,

    required this.paymentMethod,
    required this.paymentStatus,

    required this.transactionId,

    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,

    required this.invoiceNumber,

    required this.paymentDate,
    required this.createdAt,
    required this.updatedAt,

    required this.remarks,
  });

  double get baseAmount => amount;

  double get gstAmount => gst;
    //----------------------------------------------------------
  // COPY WITH
  //----------------------------------------------------------

  PaymentModel copyWith({
    int? id,
    String? paymentId,
    String? tripId,
    int? employeeId,
    String? employeeName,
    int? driverId,
    int? vehicleId,
    double? amount,
    double? gst,
    double? totalAmount,
    String? paymentMethod,
    String? paymentStatus,
    String? transactionId,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    String? razorpaySignature,
    String? invoiceNumber,
    DateTime? paymentDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? remarks,
  }) {
    return PaymentModel(
      id: id ?? this.id,

      paymentId: paymentId ?? this.paymentId,
      tripId: tripId ?? this.tripId,

      employeeId: employeeId ?? this.employeeId,
      employeeName:
          employeeName ?? this.employeeName,

      driverId: driverId ?? this.driverId,
      vehicleId: vehicleId ?? this.vehicleId,

      amount: amount ?? this.amount,
      gst: gst ?? this.gst,
      totalAmount:
          totalAmount ?? this.totalAmount,

      paymentMethod:
          paymentMethod ?? this.paymentMethod,

      paymentStatus:
          paymentStatus ?? this.paymentStatus,

      transactionId:
          transactionId ?? this.transactionId,

      razorpayOrderId:
          razorpayOrderId ??
              this.razorpayOrderId,

      razorpayPaymentId:
          razorpayPaymentId ??
              this.razorpayPaymentId,

      razorpaySignature:
          razorpaySignature ??
              this.razorpaySignature,

      invoiceNumber:
          invoiceNumber ?? this.invoiceNumber,

      paymentDate:
          paymentDate ?? this.paymentDate,

      createdAt:
          createdAt ?? this.createdAt,

      updatedAt:
          updatedAt ?? this.updatedAt,

      remarks: remarks ?? this.remarks,
    );
  }
    //----------------------------------------------------------
  // TO MAP
  //----------------------------------------------------------

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'paymentId': paymentId,
      'tripId': tripId,

      'employeeId': employeeId,
      'employeeName': employeeName,

      'driverId': driverId,
      'vehicleId': vehicleId,

      'amount': amount,
      'gst': gst,
      'totalAmount': totalAmount,

      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,

      'transactionId': transactionId,

      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpaySignature': razorpaySignature,

      'invoiceNumber': invoiceNumber,

      'paymentDate': paymentDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),

      'remarks': remarks,
    };
  }
    //----------------------------------------------------------
  // FROM MAP
  //----------------------------------------------------------

  factory PaymentModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return PaymentModel(
      id: map['id'] as int?,

      paymentId: map['paymentId'] ?? '',
      tripId: map['tripId'] ?? '',

      employeeId: map['employeeId'] ?? 0,
      employeeName: map['employeeName'] ?? '',

      driverId: map['driverId'] ?? 0,
      vehicleId: map['vehicleId'] ?? 0,

      amount: (map['amount'] ?? 0).toDouble(),
      gst: (map['gst'] ?? 0).toDouble(),
      totalAmount:
          (map['totalAmount'] ?? 0).toDouble(),

      paymentMethod:
          map['paymentMethod'] ?? '',

      paymentStatus:
          map['paymentStatus'] ?? '',

      transactionId:
          map['transactionId'] ?? '',

      razorpayOrderId:
          map['razorpayOrderId'] ?? '',

      razorpayPaymentId:
          map['razorpayPaymentId'] ?? '',

      razorpaySignature:
          map['razorpaySignature'] ?? '',

      invoiceNumber:
          map['invoiceNumber'] ?? '',

      paymentDate:
          DateTime.tryParse(
                map['paymentDate'] ?? '',
              ) ??
              DateTime.now(),

      createdAt:
          DateTime.tryParse(
                map['createdAt'] ?? '',
              ) ??
              DateTime.now(),

      updatedAt:
          DateTime.tryParse(
                map['updatedAt'] ?? '',
              ) ??
              DateTime.now(),

      remarks: map['remarks'] ?? '',
    );
  }
    //----------------------------------------------------------
  // TO STRING
  //----------------------------------------------------------

  @override
  String toString() {
    return '''
PaymentModel(
  id: $id,
  paymentId: $paymentId,
  tripId: $tripId,
  employeeId: $employeeId,
  employeeName: $employeeName,
  driverId: $driverId,
  vehicleId: $vehicleId,
  amount: $amount,
  gst: $gst,
  totalAmount: $totalAmount,
  paymentMethod: $paymentMethod,
  paymentStatus: $paymentStatus,
  transactionId: $transactionId,
  razorpayOrderId: $razorpayOrderId,
  razorpayPaymentId: $razorpayPaymentId,
  razorpaySignature: $razorpaySignature,
  invoiceNumber: $invoiceNumber,
  paymentDate: $paymentDate,
  createdAt: $createdAt,
  updatedAt: $updatedAt,
  remarks: $remarks
)
''';
  }
}