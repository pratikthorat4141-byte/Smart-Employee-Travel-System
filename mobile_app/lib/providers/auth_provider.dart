import 'dart:math';

import 'package:flutter/material.dart';

import '../database/dao/user_dao.dart';
import '../database/dao/employee_dao.dart';
import '../database/dao/driver_dao.dart';

import '../models/user_model.dart';
import '../models/employee_model.dart';
import '../models/driver_model.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider();

  final UserDao _userDao = UserDao.instance;
  final EmployeeDao _employeeDao = EmployeeDao.instance;
  final DriverDao _driverDao = DriverDao.instance;

  UserModel? _currentUser;

  bool _isLoading = false;

  String? _errorMessage;

  UserModel? get currentUser => _currentUser;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isLoggedIn => _currentUser != null;

  bool get isAdmin => _currentUser?.role == "Admin";

  bool get isEmployee => _currentUser?.role == "Employee";

  bool get isDriver => _currentUser?.role == "Driver";

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  //==========================================================
  // LOGIN
  //==========================================================

  Future<bool> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _userDao.login(
        email.trim(),
        password.trim(),
        role,
      );

      if (user == null) {
        _setError(
          "Invalid Email / Password / Role",
        );
        return false;
      }

      _currentUser = user;

      notifyListeners();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // REGISTER USER
  //==========================================================

  Future<bool> register(
    UserModel user,
  ) async {
    try {
      _setLoading(true);
      _setError(null);

      if (await _userDao.emailExists(user.email)) {
        _setError("Email already exists");
        return false;
      }

      if (await _userDao.mobileExists(user.mobile)) {
        _setError("Mobile already exists");
        return false;
      }

      await _userDao.insert(user);

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // REGISTER EMPLOYEE
  //==========================================================

  Future<bool> registerEmployee({
    required UserModel user,
    required EmployeeModel employee,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      if (await _userDao.emailExists(user.email)) {
        _setError("Email already exists");
        return false;
      }

      await _userDao.insert(user);

      await _employeeDao.registerEmployee(
        employee,
      );

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
    //==========================================================
  // REGISTER DRIVER
  //==========================================================

  Future<bool> registerDriver({
    required UserModel user,
    required DriverModel driver,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      if (await _userDao.emailExists(user.email)) {
        _setError("Email already exists");
        return false;
      }

      if (await _driverDao.emailExists(driver.email)) {
        _setError("Driver email already exists");
        return false;
      }

      if (await _driverDao.mobileExists(driver.mobile)) {
        _setError("Mobile already exists");
        return false;
      }

      if (driver.licenseNumber.isNotEmpty) {
        final exists = await _driverDao.licenseExists(
          driver.licenseNumber,
        );

        if (exists) {
          _setError("License already exists");
          return false;
        }
      }

      await _userDao.insert(user);

      await _driverDao.registerDriver(driver);

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // PASSWORD RESET OTP
  //==========================================================

  String? _passwordResetOtp;

  String? _passwordResetEmail;

  DateTime? _otpExpiry;

  Future<bool> sendPasswordResetOtp(
    String email,
  ) async {
    try {
      _setLoading(true);
      _setError(null);

      final exists = await _userDao.emailExists(
        email.trim(),
      );

      if (!exists) {
        _setError("Email not found");
        return false;
      }

      _passwordResetEmail = email.trim();

      _passwordResetOtp =
          (100000 + Random().nextInt(900000))
              .toString();

      _otpExpiry = DateTime.now().add(
        const Duration(minutes: 5),
      );

      debugPrint(
        "Password Reset OTP : $_passwordResetOtp",
      );

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // VERIFY PASSWORD RESET OTP
  //==========================================================

  Future<bool> verifyPasswordOtp({
    required String email,
    required String otp,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_passwordResetEmail != email.trim()) {
        _setError("Invalid Email");
        return false;
      }

      if (_otpExpiry == null ||
          DateTime.now().isAfter(_otpExpiry!)) {
        _setError("OTP Expired");
        return false;
      }

      if (_passwordResetOtp != otp.trim()) {
        _setError("Invalid OTP");
        return false;
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
    //==========================================================
  // RESET PASSWORD
  //==========================================================

  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final exists = await _userDao.emailExists(
        email.trim(),
      );

      if (!exists) {
        _setError("Email not found");
        return false;
      }

      await _userDao.updatePassword(
        email: email.trim(),
        password: newPassword.trim(),
      );

      _passwordResetOtp = null;
      _passwordResetEmail = null;
      _otpExpiry = null;

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================
  // LOGOUT
  //==========================================================

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  //==========================================================
  // GET USERS
  //==========================================================

  Future<List<UserModel>> getUsers() async {
    return await _userDao.getAll();
  }

  //==========================================================
  // DELETE USER
  //==========================================================

  Future<void> deleteUser(
    int id,
  ) async {
    await _userDao.delete(id);
    notifyListeners();
  }

  //==========================================================
  // REFRESH CURRENT USER
  //==========================================================

  Future<void> refreshCurrentUser() async {
    if (_currentUser == null) {
      return;
    }

    final user = await _userDao.getById(
      _currentUser!.id!,
    );

    if (user != null) {
      _currentUser = user;
      notifyListeners();
    }
  }

  //==========================================================
  // CHECK LOGIN
  //==========================================================

  Future<void> checkLogin() async {
    notifyListeners();
  }
    //==========================================================
  // CLEAR ERROR
  //==========================================================

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _currentUser = null;
    super.dispose();
  }
}