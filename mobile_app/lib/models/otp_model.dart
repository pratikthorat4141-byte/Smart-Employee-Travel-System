class OtpModel {
  final int? id;

  final String tripId;

  final int employeeId;

  final int driverId;

  final String otp;

  /// START / END
  final String otpType;

  final bool isVerified;

  final String generatedAt;

  final String? verifiedAt;

  final String expiresAt;

  const OtpModel({
    this.id,
    required this.tripId,
    required this.employeeId,
    required this.driverId,
    required this.otp,
    required this.otpType,
    this.isVerified = false,
    required this.generatedAt,
    this.verifiedAt,
    required this.expiresAt,
  });

  factory OtpModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return OtpModel(
      id: map['id'] as int?,
      tripId: map['tripId'] ?? '',
      employeeId: map['employeeId'] ?? 0,
      driverId: map['driverId'] ?? 0,
      otp: map['otp'] ?? '',
      otpType: map['otpType'] ?? '',
      isVerified: (map['isVerified'] ?? 0) == 1,
      generatedAt: map['generatedAt'] ?? '',
      verifiedAt: map['verifiedAt'],
      expiresAt: map['expiresAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'employeeId': employeeId,
      'driverId': driverId,
      'otp': otp,
      'otpType': otpType,
      'isVerified': isVerified ? 1 : 0,
      'generatedAt': generatedAt,
      'verifiedAt': verifiedAt,
      'expiresAt': expiresAt,
    };
  }

  OtpModel copyWith({
    int? id,
    String? tripId,
    int? employeeId,
    int? driverId,
    String? otp,
    String? otpType,
    bool? isVerified,
    String? generatedAt,
    String? verifiedAt,
    String? expiresAt,
  }) {
    return OtpModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      employeeId: employeeId ?? this.employeeId,
      driverId: driverId ?? this.driverId,
      otp: otp ?? this.otp,
      otpType: otpType ?? this.otpType,
      isVerified: isVerified ?? this.isVerified,
      generatedAt: generatedAt ?? this.generatedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  String toString() {
    return '''
OtpModel(
  id: $id,
  tripId: $tripId,
  employeeId: $employeeId,
  driverId: $driverId,
  otp: $otp,
  otpType: $otpType,
  isVerified: $isVerified,
  generatedAt: $generatedAt,
  verifiedAt: $verifiedAt,
  expiresAt: $expiresAt
)
''';
  }
}