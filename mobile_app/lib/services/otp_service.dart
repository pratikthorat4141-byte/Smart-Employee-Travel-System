import 'dart:math';

class OtpService {
  OtpService._();

  static final Random _random = Random();

  //=========================================================
  // Generate 6 Digit OTP
  //=========================================================

  static String generateOtp() {
    return (100000 + _random.nextInt(900000)).toString();
  }

  //=========================================================
  // Current Time
  //=========================================================

  static DateTime now() {
    return DateTime.now();
  }

  //=========================================================
  // Expiry Time
  //=========================================================

  static DateTime expiryTime({
    int minutes = 5,
  }) {
    return DateTime.now().add(
      Duration(minutes: minutes),
    );
  }

  //=========================================================
  // Check Expired
  //=========================================================

  static bool isExpired(
    String expiry,
  ) {
    return DateTime.now().isAfter(
      DateTime.parse(expiry),
    );
  }

  //=========================================================
  // Compare OTP
  //=========================================================

  static bool verify({
    required String enteredOtp,
    required String savedOtp,
  }) {
    return enteredOtp.trim() ==
        savedOtp.trim();
  }
}