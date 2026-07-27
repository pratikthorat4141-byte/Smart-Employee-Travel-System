import 'package:flutter/material.dart';

import '../database/dao/payment_dao.dart';
import '../models/payment_model.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentProvider._();

  static final PaymentProvider instance =
      PaymentProvider._();

  final PaymentDao _paymentDao =
      PaymentDao.instance;

  List<PaymentModel> _payments = [];
  List<PaymentModel> _filteredPayments = [];

  bool _isLoading = false;

  String? _error;

  PaymentModel? _selectedPayment;

  String _selectedStatus = "All";

  //----------------------------------------------------------
  // GETTERS
  //----------------------------------------------------------

  List<PaymentModel> get payments =>
      List.unmodifiable(_payments);

  List<PaymentModel> get filteredPayments =>
      List.unmodifiable(_filteredPayments);

  bool get isLoading => _isLoading;

  String? get error => _error;

  PaymentModel? get selectedPayment =>
      _selectedPayment;

  //----------------------------------------------------------
  // PRIVATE
  //----------------------------------------------------------

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  //----------------------------------------------------------
  // LOAD PAYMENTS
  //----------------------------------------------------------

  Future<void> loadPayments() async {
    try {
      _setLoading(true);

      _payments =
          await _paymentDao.getAllPayments();

      _filteredPayments =
          List.from(_payments);

      _error = null;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() async {
    await loadPayments();
  }

  //----------------------------------------------------------
  // SELECT PAYMENT
  //----------------------------------------------------------

  void selectPayment(
    PaymentModel payment,
  ) {
    _selectedPayment = payment;
    notifyListeners();
  }

  void clearSelection() {
    _selectedPayment = null;
    notifyListeners();
  }
    //----------------------------------------------------------
  // ADD PAYMENT
  //----------------------------------------------------------

  Future<bool> addPayment(
    PaymentModel payment,
  ) async {
    try {
      _setLoading(true);

      await _paymentDao.insert(payment);

      await loadPayments();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //----------------------------------------------------------
  // UPDATE PAYMENT
  //----------------------------------------------------------

  Future<bool> updatePayment(
    PaymentModel payment,
  ) async {
    try {
      _setLoading(true);

      await _paymentDao.update(payment);

      await loadPayments();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //----------------------------------------------------------
  // DELETE PAYMENT
  //----------------------------------------------------------

  Future<bool> deletePayment(
    int id,
  ) async {
    try {
      _setLoading(true);

      await _paymentDao.delete(id);

      await loadPayments();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //----------------------------------------------------------
  // UPDATE STATUS
  //----------------------------------------------------------

  Future<bool> updateStatus({
    required int id,
    required String status,
  }) async {
    try {
      _setLoading(true);

      await _paymentDao.updateStatus(
        id: id,
        status: status,
      );

      await loadPayments();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
    //----------------------------------------------------------
  // SEARCH
  //----------------------------------------------------------

  void searchPayment(
    String keyword,
  ) {
    if (keyword.trim().isEmpty) {
      _applyStatusFilter();
      return;
    }

    final key = keyword.toLowerCase();

    _filteredPayments = _payments.where((payment) {
      return payment.paymentId
              .toLowerCase()
              .contains(key) ||
          payment.tripId
              .toLowerCase()
              .contains(key) ||
          payment.employeeName
              .toLowerCase()
              .contains(key) ||
          payment.transactionId
              .toLowerCase()
              .contains(key) ||
          payment.invoiceNumber
              .toLowerCase()
              .contains(key);
    }).toList();

    notifyListeners();
  }

  //----------------------------------------------------------
  // STATUS FILTER
  //----------------------------------------------------------

  void changeStatus(
    String status,
  ) {
    _selectedStatus = status;
    _applyStatusFilter();
  }

  void _applyStatusFilter() {
    if (_selectedStatus == "All") {
      _filteredPayments =
          List.from(_payments);
    } else {
      _filteredPayments =
          _payments.where((payment) {
        return payment.paymentStatus ==
            _selectedStatus;
      }).toList();
    }

    notifyListeners();
  }

  //----------------------------------------------------------
  // COUNTS
  //----------------------------------------------------------

  int get totalPayments =>
      _payments.length;

  int get paidCount =>
      _payments
          .where(
            (e) =>
                e.paymentStatus ==
                "Paid",
          )
          .length;

  int get pendingCount =>
      _payments
          .where(
            (e) =>
                e.paymentStatus ==
                "Pending",
          )
          .length;

  int get failedCount =>
      _payments
          .where(
            (e) =>
                e.paymentStatus ==
                "Failed",
          )
          .length;
            //----------------------------------------------------------
  // REVENUE
  //----------------------------------------------------------

  double get totalRevenue =>
      _payments
          .where(
            (e) =>
                e.paymentStatus ==
                "Paid",
          )
          .fold(
            0.0,
            (sum, e) =>
                sum + e.totalAmount,
          );

  double get pendingRevenue =>
      _payments
          .where(
            (e) =>
                e.paymentStatus ==
                "Pending",
          )
          .fold(
            0.0,
            (sum, e) =>
                sum + e.totalAmount,
          );

  double get failedRevenue =>
      _payments
          .where(
            (e) =>
                e.paymentStatus ==
                "Failed",
          )
          .fold(
            0.0,
            (sum, e) =>
                sum + e.totalAmount,
          );

  double get totalGST =>
      _payments.fold(
        0.0,
        (sum, e) => sum + e.gst,
      );

  double get totalBaseAmount =>
      _payments.fold(
        0.0,
        (sum, e) => sum + e.amount,
      );

  double get todayRevenue {
    final now = DateTime.now();

    return _payments
        .where(
          (e) =>
              e.paymentStatus ==
                  "Paid" &&
              e.paymentDate.year ==
                  now.year &&
              e.paymentDate.month ==
                  now.month &&
              e.paymentDate.day ==
                  now.day,
        )
        .fold(
          0.0,
          (sum, e) =>
              sum + e.totalAmount,
        );
  }

  //----------------------------------------------------------
  // PAYMENT METHOD
  //----------------------------------------------------------

  int paymentMethodCount(
    String method,
  ) {
    return _payments
        .where(
          (e) =>
              e.paymentMethod ==
              method,
        )
        .length;
  }

  double paymentMethodRevenue(
    String method,
  ) {
    return _payments
        .where(
          (e) =>
              e.paymentMethod ==
              method,
        )
        .fold(
          0.0,
          (sum, e) =>
              sum + e.totalAmount,
        );
  }

  //----------------------------------------------------------
  // MONTHLY REVENUE
  //----------------------------------------------------------

  double revenueByMonth(
    int month,
    int year,
  ) {
    return _payments
        .where(
          (e) =>
              e.paymentStatus ==
                  "Paid" &&
              e.paymentDate.month ==
                  month &&
              e.paymentDate.year ==
                  year,
        )
        .fold(
          0.0,
          (sum, e) =>
              sum + e.totalAmount,
        );
  }

  //----------------------------------------------------------
  // DATE FILTER
  //----------------------------------------------------------

  void filterByDate(
    DateTime from,
    DateTime to,
  ) {
    _filteredPayments =
        _payments.where((e) {
      return !e.paymentDate
              .isBefore(from) &&
          !e.paymentDate
              .isAfter(to);
    }).toList();

    notifyListeners();
  }

  void clearDateFilter() {
    _filteredPayments =
        List.from(_payments);

    notifyListeners();
  }

  //----------------------------------------------------------
  // ERROR
  //----------------------------------------------------------

  void clearError() {
    _error = null;
    notifyListeners();
  }

  //----------------------------------------------------------
  // RESET
  //----------------------------------------------------------

  void reset() {
    _payments.clear();
    _filteredPayments.clear();

    _selectedPayment = null;
    _selectedStatus = "All";

    _error = null;
    _isLoading = false;

    notifyListeners();
  }
}