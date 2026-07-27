import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _emailController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  bool _obscure = true;

  String _selectedRole = "Admin";

  @override
  void initState() {
    super.initState();
    _fillDemoAccount();
  }

  void _fillDemoAccount() {
    switch (_selectedRole) {
      case "Admin":
        _emailController.text =
            "admin@travel.com";
        _passwordController.text =
            "admin123";
        break;

      case "Employee":
        _emailController.clear();
        _passwordController.clear();
        break;

      case "Driver":
        _emailController.clear();
        _passwordController.clear();
        break;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final auth =
        context.read<AuthProvider>();

    final success =
        await auth.login(
      email: _emailController.text.trim(),
      password:
          _passwordController.text.trim(),
      role: _selectedRole,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ??
                "Login Failed",
          ),
        ),
      );
      return;
    }

    if (auth.isAdmin) {
      Navigator.pushReplacementNamed(
        context,
        AppRouter.adminDashboard,
      );
    } else if (auth.isEmployee) {
      Navigator.pushReplacementNamed(
        context,
        AppRouter.employeeDashboard,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        AppRouter.driverDashboard,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AuthProvider>(
      builder: (
        context,
        auth,
        child,
      ) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff1565C0),
                  Color(0xff1976D2),
                  Color(0xff42A5F5),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      const SizedBox(height: 20),

                      Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(18),
                          child: Image.asset(
                            "assets/images/admin_logo.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Smart Employee\nTravel Solution",
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        padding:
                            const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(25),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                                                        const Text(
                              "Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 25),

                            DropdownButtonFormField<String>(
                              value: _selectedRole,
                              decoration: const InputDecoration(
                                labelText: "Login As",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "Admin",
                                  child: Text("Admin"),
                                ),
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
                                if (value == null) return;

                                setState(() {
                                  _selectedRole = value;
                                  _fillDemoAccount();
                                });
                              },
                            ),

                            const SizedBox(height: 18),

                            CustomTextField(
                              controller: _emailController,
                              label: "Email",
                              hint: "Enter Email",
                              keyboardType:
                                  TextInputType.emailAddress,
                              prefixIcon: Icons.email,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return "Enter Email";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            CustomTextField(
                              controller: _passwordController,
                              label: "Password",
                              hint: "Enter Password",
                              obscureText: _obscure,
                              prefixIcon: Icons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscure = !_obscure;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return "Enter Password";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 25),

                            auth.isLoading
                                ? const Center(
                                    child:
                                        CircularProgressIndicator(),
                                  )
                                : SizedBox(
                                    height: 52,
                                    child: CustomButton(
                                      text: "LOGIN",
                                      onPressed: _login,
                                    ),
                                  ),

                            const SizedBox(height: 10),

                            if (_selectedRole != "Admin")
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRouter.forgotPassword,
                                    );
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                  ),
                                ),
                              ),

                            if (_selectedRole != "Admin")
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRouter.signup,
                                  );
                                },
                                child: const Text(
                                  "Create New Account",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                            const Divider(height: 35),
                                                        if (_selectedRole == "Admin")
                              const Card(
                                elevation: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        "Admin Demo Account",
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                      Divider(),

                                      Text(
                                        "Name : Pratik Thorat",
                                      ),

                                      SizedBox(height: 6),

                                      Text(
                                        "Email : admin@travel.com",
                                      ),

                                      SizedBox(height: 6),

                                      Text(
                                        "Password : admin123",
                                      ),

                                    ],
                                  ),
                                ),
                              ),

                            if (_selectedRole == "Employee")
                              const Card(
                                elevation: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        "Employee Login",
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                      Divider(),

                                      Text(
                                        "Use your registered Email & Password.",
                                      ),

                                      SizedBox(height: 8),

                                      Text(
                                        "If you don't have an account, click 'Create New Account'.",
                                      ),

                                    ],
                                  ),
                                ),
                              ),

                            if (_selectedRole == "Driver")
                              const Card(
                                elevation: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        "Driver Login",
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                      Divider(),

                                      Text(
                                        "Use your registered Email & Password.",
                                      ),

                                      SizedBox(height: 8),

                                      Text(
                                        "If you don't have an account, click 'Create New Account'.",
                                      ),

                                    ],
                                  ),
                                ),
                              ),

                            const SizedBox(height: 20),

                            Center(
                              child: Text(
                                "Version 1.0.0",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Center(
                              child: Text(
                                "© 2026 Pratik Thorat",
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                                                      ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "AI Enabled Smart Employee Travel Management System",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 25),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}