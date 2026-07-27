import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../database/dao/otp_dao.dart';
import '../models/otp_model.dart';

class OtpProvider extends ChangeNotifier {
  OtpProvider();

  final OtpDao _dao = OtpDao.instance;

  OtpModel? _currentOtp;

  bool _isLoading = false;

  bool _isVerified = false;

  int _remainingSeconds = 0;

  Timer? _timer;

  //==========================================================
  // GETTERS
  //==========================================================

  OtpModel? get currentOtp => _currentOtp;

  bool get isLoading => _isLoading;

  bool get isVerified => _isVerified;

  int get remainingSeconds => _remainingSeconds;

  bool get canResend => _remainingSeconds == 0;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //==========================================================
  // RANDOM OTP
  //==========================================================

  String _generateOtp() {
    final random = Random();

    return (100000 + random.nextInt(900000))
        .toString();
  }

  //==========================================================
  // GENERATE OTP
  //==========================================================

  Future<void> generateOtp({
    required String tripId,
    required int employeeId,
    required int driverId,
    required String otpType,
  }) async {
    _setLoading(true);

    try {
      final now = DateTime.now();

      final otpModel = OtpModel(
        tripId: tripId,
        employeeId: employeeId,
        driverId: driverId,
        otp: _generateOtp(),
        otpType: otpType,
        isVerified: false,
        generatedAt: now.toIso8601String(),
        verifiedAt: null,
        expiresAt: now
            .add(const Duration(minutes: 5))
            .toIso8601String(),
      );

      await _dao.insert(otpModel);

      _currentOtp =
          await _dao.getLatestOtp(
        tripId,
        otpType,
      );

      _isVerified = false;

      _startTimer();

      notifyListeners();
    } catch (e) {
      debugPrint(
        'OTP Generate Error : $e',
      );
    } finally {
      _setLoading(false);
    }
  }
    //==========================================================
  // VERIFY OTP
  //==========================================================

  Future<bool> verifyOtp({
    required String tripId,
    required String otp,
    required String otpType,
  }) async {
    _setLoading(true);

    try {
      final result = await _dao.verifyOtp(
        tripId: tripId,
        otp: otp,
        otpType: otpType,
      );

      _isVerified = result;

      notifyListeners();

      return result;
    } catch (e) {
      debugPrint(
        'OTP Verify Error : $e',
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // LOAD LATEST OTP
  //==========================================================

  Future<void> loadLatestOtp({
    required String tripId,
    required String otpType,
  }) async {
    try {
      _currentOtp = await _dao.getLatestOtp(
        tripId,
        otpType,
      );

      notifyListeners();
    } catch (e) {
      debugPrint(
        'Load OTP Error : $e',
      );
    }
  }

  //==========================================================
  // RESEND OTP
  //==========================================================

  Future<void> resendOtp({
    required String tripId,
    required int employeeId,
    required int driverId,
    required String otpType,
  }) async {
    if (!canResend) {
      return;
    }

    await generateOtp(
      tripId: tripId,
      employeeId: employeeId,
      driverId: driverId,
      otpType: otpType,
    );
  }

  //==========================================================
  // CHECK OTP STATUS
  //==========================================================

  bool get hasOtp =>
      _currentOtp != null;

  bool get otpExpired {
    if (_currentOtp == null) {
      return true;
    }

    return DateTime.now().isAfter(
      DateTime.parse(
        _currentOtp!.expiresAt,
      ),
    );
  }
    //==========================================================
  // START TIMER
  //==========================================================

  void _startTimer() {
    _timer?.cancel();

    _remainingSeconds = 300;

    notifyListeners();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainingSeconds <= 0) {
          timer.cancel();
          _remainingSeconds = 0;
        } else {
          _remainingSeconds--;
        }

        notifyListeners();
      },
    );
  }

  //==========================================================
  // RESET
  //==========================================================

  void reset() {
    _timer?.cancel();

    _currentOtp = null;

    _isVerified = false;

    _remainingSeconds = 0;

    _isLoading = false;

    notifyListeners();
  }

  //==========================================================
  // DELETE EXPIRED OTP
  //==========================================================

  Future<void> clearExpiredOtp() async {
    try {
      await _dao.deleteExpiredOtp();
    } catch (e) {
      debugPrint(
        'Delete Expired OTP Error : $e',
      );
    }
  }

  //==========================================================
  // DISPOSE
  //==========================================================

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }
}