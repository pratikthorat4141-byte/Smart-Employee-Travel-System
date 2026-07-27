import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/dao/user_dao.dart';
import '../../database/dao/employee_dao.dart';
import '../../database/dao/driver_dao.dart';

import '../../models/user_model.dart';
import '../../models/employee_model.dart';
import '../../models/driver_model.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends State<SignupScreen> {
  final _formKey =
      GlobalKey<FormState>();

  final _nameController =
      TextEditingController();

  final _emailController =
      TextEditingController();

  final _mobileController =
      TextEditingController();

  final _addressController =
      TextEditingController();

  final _departmentController =
      TextEditingController();

  final _designationController =
      TextEditingController();

  final _licenseController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  final _confirmPasswordController =
      TextEditingController();

  String _role = "Employee";

  String _gender = "Male";

  bool _hidePassword = true;

  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _departmentController.dispose();
    _designationController.dispose();
    _licenseController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }
    //==========================================================
  // REGISTER
  //==========================================================

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text !=
        _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Passwords do not match",
          ),
        ),
      );
      return;
    }

    final auth =
        context.read<AuthProvider>();

    final userDao =
        UserDao.instance;

    final email =
        _emailController.text.trim();

    final mobile =
        _mobileController.text.trim();

    final emailExists =
        await userDao.emailExists(email);

    if (emailExists) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Email already exists",
          ),
        ),
      );

      return;
    }

    final mobileExists =
        await userDao.mobileExists(
      mobile,
    );

    if (mobileExists) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Mobile already exists",
          ),
        ),
      );

      return;
    }

    final user = UserModel(
      name: _nameController.text.trim(),
      email: email,
      mobile: mobile,
      password:
          _passwordController.text.trim(),
      role: _role,
    );

    final success =
        await auth.register(user);

    if (!success) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ??
                "Registration Failed",
          ),
        ),
      );

      return;
    }

    if (_role == "Employee") {
      await EmployeeDao.instance
          .registerEmployee(
        EmployeeModel(
          employeeId: "",
          name:
              _nameController.text.trim(),
          department:
              _departmentController
                      .text
                      .trim()
                      .isEmpty
                  ? "General"
                  : _departmentController
                      .text
                      .trim(),
          designation:
              _designationController
                      .text
                      .trim()
                      .isEmpty
                  ? "Employee"
                  : _designationController
                      .text
                      .trim(),
          mobile: mobile,
          email: email,
          address:
              _addressController.text
                  .trim(),
          gender: _gender,
          joiningDate:
              DateTime.now()
                  .toString()
                  .split(" ")
                  .first,
          isActive: true,
        ),
      );
    } else {
      await DriverDao.instance
          .registerDriver(
        DriverModel(
          driverId: "",
          name:
              _nameController.text.trim(),
          mobile: mobile,
          email: email,
          licenseNumber:
              _licenseController.text
                  .trim(),
          address:
              _addressController.text
                  .trim(),
          gender: _gender,
          joiningDate:
              DateTime.now()
                  .toString()
                  .split(" ")
                  .first,
          isAvailable: true,
          isActive: true,
        ),
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Account Created Successfully",
        ),
        backgroundColor:
            Colors.green,
      ),
    );

    Navigator.pushReplacementNamed(
      context,
      AppRouter.login,
    );
  }
    @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Create Account"),
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
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return "Enter Full Name";
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
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return "Enter Email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _mobileController,
                      keyboardType:
                          TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        labelText: "Mobile Number",
                        counterText: "",
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.length != 10) {
                          return "Enter Valid Mobile Number";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _role,
                      decoration: const InputDecoration(
                        labelText: "Role",
                        prefixIcon: Icon(Icons.badge),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Employee",
                          child: Text("Employee"),
                        ),
                        DropdownMenuItem(
                          value: "Driver",
                          child: Text("Driver"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _role = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: const InputDecoration(
                        labelText: "Gender",
                        prefixIcon: Icon(Icons.wc),
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
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: "Address",
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (_role == "Employee") ...[
                      TextFormField(
                        controller:
                            _departmentController,
                        decoration:
                            const InputDecoration(
                          labelText: "Department",
                          prefixIcon:
                              Icon(Icons.business),
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller:
                            _designationController,
                        decoration:
                            const InputDecoration(
                          labelText:
                              "Designation",
                          prefixIcon:
                              Icon(Icons.work),
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],

                    if (_role == "Driver") ...[
                      TextFormField(
                        controller:
                            _licenseController,
                        decoration:
                            const InputDecoration(
                          labelText:
                              "License Number",
                          prefixIcon:
                              Icon(Icons.credit_card),
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                                        TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _hideConfirmPassword,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hideConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _hideConfirmPassword =
                                  !_hideConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Confirm your password";
                        }

                        if (value !=
                            _passwordController.text) {
                          return "Passwords do not match";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed:
                            auth.isLoading
                                ? null
                                : _register,
                        icon: auth.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.person_add,
                              ),
                        label: Text(
                          auth.isLoading
                              ? "Creating..."
                              : "Create Account",
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRouter.login,
                            );
                          },
                          child: const Text(
                            "Login",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}