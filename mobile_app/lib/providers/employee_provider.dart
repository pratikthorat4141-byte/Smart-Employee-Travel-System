import 'package:flutter/material.dart';

import '../database/dao/employee_dao.dart';
import '../models/employee_model.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeDao _employeeDao = EmployeeDao.instance;

  List<EmployeeModel> _employees = [];

  bool _isLoading = false;

  String? _errorMessage;

  List<EmployeeModel> get employees => List.unmodifiable(_employees);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get totalEmployees => _employees.length;

  List<EmployeeModel> get activeEmployees =>
      _employees.where((e) => e.isActive).toList();

  //==========================================================================
  // PRIVATE
  //==========================================================================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  //==========================================================================
  // LOAD
  //==========================================================================

  Future<void> loadEmployees() async {
    try {
      _setLoading(true);

      _employees = await _employeeDao.getAll();

      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // INSERT
  //==========================================================================

  Future<bool> addEmployee(EmployeeModel employee) async {
    try {
      _setLoading(true);

      final exists =
          await _employeeDao.getByEmployeeId(employee.employeeId);

      if (exists != null) {
        _setError('Employee ID already exists');
        return false;
      }

      await _employeeDao.insert(employee);

      await loadEmployees();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // UPDATE
  //==========================================================================

  Future<bool> updateEmployee(EmployeeModel employee) async {
    try {
      _setLoading(true);

      await _employeeDao.update(employee);

      await loadEmployees();

      return true;
    } catch (e) {
      _setError(e.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // DELETE
  //==========================================================================

  Future<void> deleteEmployee(int id) async {
    try {
      _setLoading(true);

      await _employeeDao.delete(id);

      await loadEmployees();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // SEARCH
  //==========================================================================

  Future<void> searchEmployees(String keyword) async {
    try {
      _setLoading(true);

      if (keyword.trim().isEmpty) {
        await loadEmployees();
        return;
      }

      _employees = await _employeeDao.search(keyword);

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //==========================================================================
  // REFRESH
  //==========================================================================

  Future<void> refresh() async {
    await loadEmployees();
  }

  //==========================================================================
  // CLEAR ERROR
  //==========================================================================

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

 //==========================================================================
// GET EMPLOYEE
//==========================================================================

EmployeeModel? getEmployee(int id) {
  try {
    return _employees.firstWhere((e) => e.id == id);
  } catch (_) {
    return null;
  }
}

//==========================================================================
// GET EMPLOYEE BY ID (Compatibility)
//==========================================================================

EmployeeModel? getEmployeeById(int id) {
  return getEmployee(id);
}
}