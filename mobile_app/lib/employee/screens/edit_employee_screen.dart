import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../employee_user/models/employee_model.dart';
import '../../providers/employee_provider.dart';

class EditEmployeeScreen extends StatefulWidget {
  final Employee employee;

  const EditEmployeeScreen({
    super.key,
    required this.employee,
  });

  @override
  State<EditEmployeeScreen> createState() =>
      _EditEmployeeScreenState();
}

class _EditEmployeeScreenState
    extends State<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;

  late String department;

  final departments = [
    "IT",
    "HR",
    "Finance",
    "Sales",
    "Marketing",
    "Support",
    "Admin",
  ];

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.employee.name);

    emailController =
        TextEditingController(text: widget.employee.email);

    department = widget.employee.department;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> updateEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    final employee = widget.employee.copyWith(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      department: department,
    );

    await context
        .read<EmployeeProvider>()
        .updateEmployee(employee);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Employee Updated Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Employee"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              CircleAvatar(
                radius: 45,
                backgroundColor:
                    Colors.indigo.withOpacity(.15),

                child: const Icon(
                  Icons.edit,
                  size: 45,
                  color: Colors.indigo,
                ),
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: nameController,

                decoration: InputDecoration(
                  labelText: "Employee Name",
                  prefixIcon:
                      const Icon(Icons.person),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Enter Employee Name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: emailController,

                keyboardType:
                    TextInputType.emailAddress,

                decoration: InputDecoration(
                  labelText: "Email",

                  prefixIcon:
                      const Icon(Icons.email),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Enter Email";
                  }

                  if (!v.contains("@")) {
                    return "Invalid Email";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: department,

                decoration: InputDecoration(
                  labelText: "Department",

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                items: departments
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),

                onChanged: (value) {
                  setState(() {
                    department = value!;
                  });
                },
              ),

              const SizedBox(height: 35),
                            SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: updateEmployee,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "UPDATE EMPLOYEE",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  label: const Text(
                    "CANCEL",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    "Employee Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Employee ID : ${widget.employee.id}",
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}