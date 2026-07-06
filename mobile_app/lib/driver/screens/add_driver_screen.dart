import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/driver_model.dart';
import '../../providers/driver_provider.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  State<AddDriverScreen> createState() =>
      _AddDriverScreenState();
}

class _AddDriverScreenState
    extends State<AddDriverScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final licenseController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    licenseController.dispose();
    super.dispose();
  }

  Future<void> saveDriver() async {
    if (!_formKey.currentState!.validate()) return;

    final driver = Driver(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      licenseNo: licenseController.text.trim(),
    );

    await context.read<DriverProvider>().addDriver(driver);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Driver Added Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Driver"),
        centerTitle: true,
        backgroundColor: Colors.green,
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
                    Colors.green.withOpacity(.15),

                child: const Icon(
                  Icons.drive_eta,
                  color: Colors.green,
                  size: 45,
                ),
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Driver Name",
                  prefixIcon:
                      const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Enter Driver Name";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon:
                      const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Enter Phone Number";
                  }

                  if (v.length != 10) {
                    return "Enter Valid Phone Number";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: licenseController,
                decoration: InputDecoration(
                  labelText: "License Number",
                  prefixIcon: const Icon(
                    Icons.badge,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Enter License Number";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 35),
                            SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: saveDriver,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "SAVE DRIVER",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
                child: const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "Driver Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Driver will be available after saving.",
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