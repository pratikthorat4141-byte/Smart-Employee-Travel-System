class PasswordResetOtpModel {
  final int? id;
  final String? email;
  final String? mobile;
  final String otp;
  final String createdAt;
  final String expiresAt;
  final bool isVerified;

  const PasswordResetOtpModel({
    this.id,
    this.email,
    this.mobile,
    required this.otp,
    required this.createdAt,
    required this.expiresAt,
    this.isVerified = false,
  });

  factory PasswordResetOtpModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return PasswordResetOtpModel(
      id: map['id'] as int?,
      email: map['email'],
      mobile: map['mobile'],
      otp: map['otp'] ?? '',
      createdAt: map['createdAt'] ?? '',
      expiresAt: map['expiresAt'] ?? '',
      isVerified: (map['isVerified'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'mobile': mobile,
      'otp': otp,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
      'isVerified': isVerified ? 1 : 0,
    };
  }

  PasswordResetOtpModel copyWith({
    int? id,
    String? email,
    String? mobile,
    String? otp,
    String? createdAt,
    String? expiresAt,
    bool? isVerified,
  }) {
    return PasswordResetOtpModel(
      id: id ?? this.id,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      otp: otp ?? this.otp,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  String toString() {
    return '''
PasswordResetOtpModel(
  id: $id,
  email: $email,
  mobile: $mobile,
  otp: $otp,
  createdAt: $createdAt,
  expiresAt: $expiresAt,
  isVerified: $isVerified
)
''';
  }
}