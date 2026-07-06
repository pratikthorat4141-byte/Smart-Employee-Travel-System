import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../auth/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  // ================= REGISTER =================

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final user = UserModel(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    try {
      await DatabaseHelper.instance.registerUser(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // ================= LOGIN =================

  Future<bool> login(
    String email,
    String password,
  ) async {
    final data = await DatabaseHelper.instance.loginUser(
      email,
      password,
    );

    if (data == null) {
      return false;
    }

    _currentUser = UserModel.fromMap(data);

    notifyListeners();

    return true;
  }

  // ================= LOGOUT =================

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}