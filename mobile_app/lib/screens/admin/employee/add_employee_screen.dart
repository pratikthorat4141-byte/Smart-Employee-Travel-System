import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/employee_model.dart';
import '../../../providers/employee_provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  final EmployeeModel? employee;

  const AddEmployeeScreen({
    super.key,
    this.employee,
  });

  @override
  State<AddEmployeeScreen> createState() =>
      _AddEmployeeScreenState();
}

class _AddEmployeeScreenState
    extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _employeeIdController =
      TextEditingController();

  final _nameController =
      TextEditingController();

  final _departmentController =
      TextEditingController();

  final _designationController =
      TextEditingController();

  final _mobileController =
      TextEditingController();

  final _emailController =
      TextEditingController();

  final _addressController =
      TextEditingController();

  final _joiningDateController =
      TextEditingController();

  String _gender = "Male";

  bool get isEdit =>
      widget.employee != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final employee = widget.employee!;

      _employeeIdController.text =
          employee.employeeId;

      _nameController.text =
          employee.name;

      _departmentController.text =
          employee.department;

      _designationController.text =
          employee.designation;

      _mobileController.text =
          employee.mobile;

      _emailController.text =
          employee.email;

      _addressController.text =
          employee.address;

      _joiningDateController.text =
          employee.joiningDate;

      _gender = employee.gender;
    }
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _nameController.dispose();
    _departmentController.dispose();
    _designationController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _joiningDateController.dispose();

    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    _joiningDateController.text =
        "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider =
        context.read<EmployeeProvider>();

    final employee = EmployeeModel(
      id: widget.employee?.id,
      employeeId:
          _employeeIdController.text.trim(),
      name: _nameController.text.trim(),
      department:
          _departmentController.text.trim(),
      designation:
          _designationController.text.trim(),
      mobile: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      gender: _gender,
      joiningDate:
          _joiningDateController.text.trim(),
      isActive: true,
    );
        if (isEdit) {
      await provider.updateEmployee(employee);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Employee updated successfully"),
        ),
      );
    } else {
      await provider.addEmployee(employee);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Employee added successfully"),
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? "Edit Employee"
              : "Add Employee",
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                TextFormField(
                  controller: _employeeIdController,
                  decoration: const InputDecoration(
                    labelText: "Employee ID",
                    prefixIcon: Icon(Icons.badge),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Employee ID is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Employee Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Employee name is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _departmentController,
                  decoration: const InputDecoration(
                    labelText: "Department",
                    prefixIcon: Icon(Icons.apartment),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Department is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _designationController,
                  decoration: const InputDecoration(
                    labelText: "Designation",
                    prefixIcon: Icon(Icons.work),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Designation is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Mobile Number",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.length != 10) {
                      return "Enter valid mobile number";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Address is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(
                    labelText: "Gender",
                    prefixIcon: Icon(Icons.people),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Male",
                      child: Text("Male"),
                    ),
                    DropdownMenuItem(
                      value: "Female",
                      child: Text("Female"),
                    ),
                    DropdownMenuItem(
                      value: "Other",
                      child: Text("Other"),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _gender = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _joiningDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Joining Date",
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: _pickDate,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Joining date is required";
                    }
                    return null;
                  },
                  onTap: _pickDate,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _saveEmployee,
                    icon: Icon(
                      isEdit
                          ? Icons.edit
                          : Icons.save,
                    ),
                    label: Text(
                      isEdit
                          ? "Update Employee"
                          : "Save Employee",
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}