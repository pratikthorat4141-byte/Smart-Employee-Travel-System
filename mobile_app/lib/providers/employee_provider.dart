import 'package:flutter/material.dart';
import '../employee/models/employee_model.dart';

class EmployeeProvider extends ChangeNotifier {
  final List<Employee> _employees = [
    Employee(
      id: 1,
      name: "Rahul Sharma",
      email: "rahul@gmail.com",
      department: "IT",
    ),
    Employee(
      id: 2,
      name: "Priya Patil",
      email: "priya@gmail.com",
      department: "HR",
    ),
  ];

  List<Employee> get employees => _employees;

  void addEmployee(Employee employee) {
    _employees.add(employee);
    notifyListeners();
  }

  void deleteEmployee(int id) {
    _employees.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void updateEmployee(Employee employee) {
    final index = _employees.indexWhere((e) => e.id == employee.id);

    if (index != -1) {
      _employees[index] = employee;
      notifyListeners();
    }
  }
}