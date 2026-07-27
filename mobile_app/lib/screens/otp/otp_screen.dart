import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/otp_provider.dart';
import '../../providers/trip_provider.dart';

class OtpScreen extends StatefulWidget {
  final String tripId;
  final int employeeId;
  final int driverId;

  const OtpScreen({
    super.key,
    required this.tripId,
    required this.employeeId,
    required this.driverId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  bool isVerifyMode = false;

  @override
  Widget build(BuildContext context) {
    final otpProvider = context.watch<OtpProvider>();
    final tripProvider = context.read<TripProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip OTP"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.lock,
              size: 90,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),

            // Generate OTP
            if (!isVerifyMode)
              ElevatedButton.icon(
                onPressed: () async {
                  await otpProvider.generateOtp(
                    tripId: widget.tripId,
                    employeeId: widget.employeeId,
                    driverId: widget.driverId,
                    otpType: "START",
                  );
                },
                icon: const Icon(Icons.lock),
                label: const Text("Generate START OTP"),
              ),

            const SizedBox(height: 20),

            // Show generated OTP
            if (otpProvider.currentOtp != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "Generated OTP",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        otpProvider.currentOtp!.otp,
                        style: const TextStyle(
                          fontSize: 34,
                          letterSpacing: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Expires in ${otpProvider.remainingSeconds} sec",
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 25),

            // OTP Input
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.password),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isVerifyMode = true;
                });
              },
              icon: const Icon(Icons.verified),
              label: const Text("Verify OTP"),
            ),

            const SizedBox(height: 20),

            // Verify & Continue
            ElevatedButton.icon(
              onPressed: otpProvider.isLoading
                  ? null
                  : () async {
                      final success = await otpProvider.verifyOtp(
                        tripId: widget.tripId,
                        otp: _otpController.text.trim(),
                        otpType: "START",
                      );

                      if (!context.mounted) return;

                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Invalid or Expired OTP"),
                          ),
                        );
                        return;
                      }

                      final trip = tripProvider.trips.firstWhere(
                        (e) => e.tripId == widget.tripId,
                      );

                      if (trip.status == "Started") {
                        await tripProvider.completeTrip(trip);

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Trip Completed"),
                          ),
                        );
                      } else {
                        await tripProvider.startTrip(trip);

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Trip Started"),
                          ),
                        );
                      }

                      Navigator.pop(context);
                    },
              icon: const Icon(Icons.check_circle),
              label: otpProvider.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Verify & Continue"),
            ),

            const SizedBox(height: 15),

            // Resend OTP
            OutlinedButton.icon(
              onPressed: otpProvider.canResend
                  ? () async {
                      await otpProvider.resendOtp(
                        tripId: widget.tripId,
                        employeeId: widget.employeeId,
                        driverId: widget.driverId,
                        otpType: "START",
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("OTP Resent Successfully"),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.refresh),
              label: Text(
                otpProvider.canResend
                    ? "Resend OTP"
                    : "Resend in ${otpProvider.remainingSeconds}s",
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}