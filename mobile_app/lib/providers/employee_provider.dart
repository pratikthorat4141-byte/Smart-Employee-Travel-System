import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../employee_user/models/employee_model.dart';

class EmployeeProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Employee> _employees = [];

  List<Employee> get employees => _employees;

  EmployeeProvider() {
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    final data = await _db.getEmployees();

    _employees = data.map((e) => Employee.fromMap(e)).toList();

    notifyListeners();
  }

  Future<void> addEmployee(Employee employee) async {
    await _db.insertEmployee(employee.toMap());
    await loadEmployees();
  }

  Future<void> updateEmployee(Employee employee) async {
    await _db.updateEmployee(employee.toMap());
    await loadEmployees();
  }

  Future<void> deleteEmployee(int id) async {
    await _db.deleteEmployee(id);
    await loadEmployees();
  }

  Future<void> searchEmployee(String keyword) async {
    final data = await _db.getEmployees();

    if (keyword.trim().isEmpty) {
      _employees = data.map((e) => Employee.fromMap(e)).toList();
    } else {
      _employees = data
          .map((e) => Employee.fromMap(e))
          .where((employee) =>
              employee.name.toLowerCase().contains(keyword.toLowerCase()) ||
              employee.email.toLowerCase().contains(keyword.toLowerCase()) ||
              employee.department.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }
}