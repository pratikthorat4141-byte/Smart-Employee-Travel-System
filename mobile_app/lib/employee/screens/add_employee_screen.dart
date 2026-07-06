import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../employee_user/models/employee_model.dart';
import '../../providers/employee_provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() =>
      _AddEmployeeScreenState();
}

class _AddEmployeeScreenState
    extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  String department = "IT";

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
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    final employee = Employee(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      department: department,
    );

    await context
        .read<EmployeeProvider>()
        .addEmployee(employee);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Employee Added Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employee"),
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
                  Icons.person_add,
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

                  if (v.length < 3) {
                    return "Minimum 3 characters";
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
                  onPressed: saveEmployee,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "SAVE EMPLOYEE",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
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
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
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