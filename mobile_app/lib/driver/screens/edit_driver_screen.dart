import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/driver_model.dart';
import '../../providers/driver_provider.dart';

class EditDriverScreen extends StatefulWidget {
  final Driver driver;

  const EditDriverScreen({
    super.key,
    required this.driver,
  });

  @override
  State<EditDriverScreen> createState() =>
      _EditDriverScreenState();
}

class _EditDriverScreenState
    extends State<EditDriverScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController licenseController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.driver.name);

    phoneController =
        TextEditingController(text: widget.driver.phone);

    licenseController =
        TextEditingController(
      text: widget.driver.licenseNo,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    licenseController.dispose();
    super.dispose();
  }

  Future<void> updateDriver() async {
    if (!_formKey.currentState!.validate()) return;

    final driver = widget.driver.copyWith(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      licenseNo: licenseController.text.trim(),
    );

    await context
        .read<DriverProvider>()
        .updateDriver(driver);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Driver Updated Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Driver"),
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
                  Icons.edit,
                  size: 45,
                  color: Colors.green,
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
                  onPressed: updateDriver,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "UPDATE DRIVER",
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
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.badge,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    "Driver Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Driver ID : ${widget.driver.id}",
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