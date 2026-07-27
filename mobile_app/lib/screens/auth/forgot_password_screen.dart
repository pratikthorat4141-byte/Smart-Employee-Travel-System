import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth =
        context.read<AuthProvider>();

    final success =
        await auth.sendPasswordResetOtp(
      _emailController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("OTP sent successfully"),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              OtpVerificationScreen(
            email:
                _emailController.text.trim(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage ??
                "Something went wrong",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth =
        context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                const SizedBox(height: 30),

                const Icon(
                  Icons.lock_reset,
                  size: 90,
                  color: Colors.blue,
                ),

                const SizedBox(height: 25),

                const Text(
                  "Enter your registered email.",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller:
                      _emailController,
                  keyboardType:
                      TextInputType
                          .emailAddress,
                  decoration:
                      const InputDecoration(
                    labelText: "Email",
                    border:
                        OutlineInputBorder(),
                    prefixIcon:
                        Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null ||
                      value.trim().isEmpty) {
                      return "Enter email";
                    }

                   final email = value.trim();

                  if (!RegExp(
                      r'^[^@]+@[^@]+\.[^@]+',
                      ).hasMatch(email)) {
                      return "Enter valid email";
                     }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width:
                      double.infinity,
                  height: 50,
                  child:
                      FilledButton(
                    onPressed:
                        auth.isLoading
                            ? null
                            : _sendOtp,
                    child:
                        auth.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors
                                    .white,
                              )
                            : const Text(
                                "Send OTP",
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}