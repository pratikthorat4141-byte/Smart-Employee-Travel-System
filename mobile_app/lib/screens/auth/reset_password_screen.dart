import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _passwordController =
      TextEditingController();

  final TextEditingController
      _confirmController =
      TextEditingController();

  bool _hidePassword = true;

  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final auth =
        context.read<AuthProvider>();

    final success =
        await auth.resetPassword(
      email: widget.email,
      newPassword:
          _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (!success) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ??
                "Password Reset Failed",
          ),
        ),
      );

      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: const Row(
            children: [

              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),

              SizedBox(width: 10),

              Text("Success"),
            ],
          ),
          content: const Text(
            "Your password has been changed successfully.\n\nPlease login using your new password.",
          ),
          actions: [

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.login,
                    (route) => false,
                  );

                },
                child: const Text(
                  "Go To Login",
                ),
              ),
            ),

          ],
        );
      },
    );
  }
    @override
  Widget build(BuildContext context) {

    final auth =
        context.watch<AuthProvider>();

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

          child: Center(

            child: SingleChildScrollView(

              padding:
                  const EdgeInsets.all(20),

              child: Form(

                key: _formKey,

                child: Container(

                  padding:
                      const EdgeInsets.all(24),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(25),

                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,

                    children: [

                      const Icon(
                        Icons.lock_reset,
                        color: Colors.blue,
                        size: 90,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Reset Password",
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        widget.email,
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color:
                              Colors.grey.shade700,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 30),

                      TextFormField(

                        controller:
                            _passwordController,

                        obscureText:
                            _hidePassword,

                        decoration:
                            InputDecoration(

                          labelText:
                              "New Password",

                          border:
                              const OutlineInputBorder(),

                          prefixIcon:
                              const Icon(
                            Icons.lock,
                          ),

                          suffixIcon:
                              IconButton(

                            onPressed: () {

                              setState(() {

                                _hidePassword =
                                    !_hidePassword;

                              });

                            },

                            icon: Icon(

                              _hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,

                            ),

                          ),

                        ),

                        validator: (value) {

                          if (value == null ||
                              value.isEmpty) {
                            return "Enter New Password";
                          }

                          if (value.length < 6) {
                            return "Minimum 6 characters";
                          }

                          return null;

                        },

                      ),

                      const SizedBox(height: 20),

                      TextFormField(

                        controller:
                            _confirmController,

                        obscureText:
                            _hideConfirmPassword,

                        decoration:
                            InputDecoration(

                          labelText:
                              "Confirm Password",

                          border:
                              const OutlineInputBorder(),

                          prefixIcon:
                              const Icon(
                            Icons.lock_outline,
                          ),

                          suffixIcon:
                              IconButton(

                            onPressed: () {

                              setState(() {

                                _hideConfirmPassword =
                                    !_hideConfirmPassword;

                              });

                            },

                            icon: Icon(

                              _hideConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,

                            ),

                          ),

                        ),

                        validator: (value) {

                          if (value == null ||
                              value.isEmpty) {
                            return "Confirm Password";
                          }

                          if (value !=
                              _passwordController.text) {
                            return "Passwords do not match";
                          }

                          return null;

                        },

                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Password must contain at least 6 characters.",
                        style: TextStyle(
                          color:
                              Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 30),
                                            SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: auth.isLoading
                            ? const Center(
                                child:
                                    CircularProgressIndicator(),
                              )
                            : FilledButton.icon(
                                onPressed:
                                    _resetPassword,
                                icon: const Icon(
                                  Icons.lock_reset,
                                ),
                                label: const Text(
                                  "Reset Password",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRouter.login,
                            (route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        label: const Text(
                          "Back to Login",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}