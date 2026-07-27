import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/otp_provider.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String tripId;

  const OtpVerifyScreen({
    super.key,
    required this.tripId,
  });

  @override
  State<OtpVerifyScreen> createState() =>
      _OtpVerifyScreenState();
}

class _OtpVerifyScreenState
    extends State<OtpVerifyScreen> {

  final TextEditingController
      _otpController =
      TextEditingController();

  final GlobalKey<FormState>
      _formKey =
      GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<OtpProvider>(
      builder: (
        context,
        provider,
        child,
      ) {

        return Scaffold(

          appBar: AppBar(
            title: const Text(
              "Verify OTP",
            ),
            centerTitle: true,
          ),

          body: Padding(
            padding:
                const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                children: [

                  const SizedBox(height: 25),

                  const Icon(
                    Icons.verified_user,
                    color: Colors.green,
                    size: 90,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Enter Trip OTP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: _otpController,

                    keyboardType:
                        TextInputType.number,

                    maxLength: 6,

                    decoration:
                        const InputDecoration(
                      labelText: "OTP",
                      border:
                          OutlineInputBorder(),
                      prefixIcon:
                          Icon(Icons.lock),
                    ),

                    validator: (value) {

                      if (value == null ||
                          value.isEmpty) {
                        return "Enter OTP";
                      }

                      if (value.length != 6) {
                        return "OTP must be 6 digits";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 25),
                                    ElevatedButton.icon(
                    onPressed: provider.isLoading
                        ? null
                        : () async {

                            if (!_formKey.currentState!
                                .validate()) {
                              return;
                            }

                            final verified =
                                await provider.verifyOtp(
                              tripId: widget.tripId,
                              otp: _otpController.text.trim(),
                            );

                            if (!context.mounted) return;

                            if (verified) {

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) {
                                  return AlertDialog(
                                    icon: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 60,
                                    ),
                                    title: const Text(
                                      "OTP Verified",
                                    ),
                                    content: const Text(
                                      "Trip started successfully.",
                                    ),
                                    actions: [
                                      FilledButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text(
                                          "OK",
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                            } else {

                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    icon: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 60,
                                    ),
                                    title: const Text(
                                      "Verification Failed",
                                    ),
                                    content: const Text(
                                      "Invalid or expired OTP.",
                                    ),
                                    actions: [
                                      FilledButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "OK",
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                            }
                          },
                    icon: const Icon(
                      Icons.verified,
                    ),
                    label: provider.isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Verify OTP",
                          ),
                  ),

                  const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}