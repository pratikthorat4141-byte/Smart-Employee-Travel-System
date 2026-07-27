import 'package:flutter/material.dart';

import '../database/dao/password_reset_dao.dart';
import '../database/dao/user_dao.dart';
import '../models/password_reset_model.dart';
import '../services/otp_service.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final UserDao _userDao = UserDao.instance;

  final PasswordResetDao _otpDao =
      PasswordResetDao.instance;

  bool _isLoading = false;

  String? _error;

  bool _otpVerified = false;

  String? _email;

  bool get isLoading => _isLoading;

  String? get error => _error;

  bool get otpVerified => _otpVerified;

  String? get email => _email;

  //------------------------------------------------------
  // PRIVATE
  //------------------------------------------------------

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  //------------------------------------------------------
  // SEND OTP
  //------------------------------------------------------

  Future<String?> sendOtp(
    String email,
  ) async {
    try {
      _setLoading(true);

      _setError(null);

      final user =
          await _userDao.getByEmail(
        email.trim(),
      );

      if (user == null) {
        _setError(
          "Account not found",
        );
        return null;
      }

      await _otpDao.deleteOtp(
        email,
      );

      final otp =
          OtpService.generateOtp();

      final model =
          PasswordResetModel(
        email: email.trim(),
        otp: otp,
        expiry: OtpService
            .expiryTime()
            .toIso8601String(),
        verified: false,
        createdAt: DateTime.now()
            .toIso8601String(),
      );

      await _otpDao.insert(model);

      _email = email;

      notifyListeners();

      return otp;
    } catch (e) {
      _setError(
        e.toString(),
      );

      return null;
    } finally {
      _setLoading(false);
    }
  }

  //------------------------------------------------------
  // VERIFY OTP
  //------------------------------------------------------

  Future<bool> verifyOtp(
    String otp,
  ) async {
    try {
      _setLoading(true);

      _setError(null);

      if (_email == null) {
        _setError(
          "Email missing",
        );
        return false;
      }

      final model =
          await _otpDao.getLatestOtp(
        _email!,
      );

      if (model == null) {
        _setError(
          "OTP not found",
        );
        return false;
      }

      if (OtpService.isExpired(
        model.expiry,
      )) {
        _setError(
          "OTP Expired",
        );
        return false;
      }

      if (!OtpService.verify(
        enteredOtp: otp,
        savedOtp: model.otp,
      )) {
        _setError(
          "Invalid OTP",
        );
        return false;
      }

      await _otpDao.verifyOtp(
        model.id!,
      );

      _otpVerified = true;

      notifyListeners();

      return true;
    } catch (e) {
      _setError(
        e.toString(),
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //------------------------------------------------------
  // RESET PASSWORD
  //------------------------------------------------------

  Future<bool> resetPassword(
    String password,
  ) async {
    try {
      _setLoading(true);

      _setError(null);

      if (!_otpVerified) {
        _setError(
          "OTP not verified",
        );
        return false;
      }

      await _userDao.updatePassword(
        _email!,
        password,
      );

      await _otpDao.deleteOtp(
        _email!,
      );

      _otpVerified = false;

      notifyListeners();

      return true;
    } catch (e) {
      _setError(
        e.toString(),
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //------------------------------------------------------
  // CLEAR
  //------------------------------------------------------

  void clear() {
    _error = null;
    _otpVerified = false;
    _email = null;

    notifyListeners();
  }
}