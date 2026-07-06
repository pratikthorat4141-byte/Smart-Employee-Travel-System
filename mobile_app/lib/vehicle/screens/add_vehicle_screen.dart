import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/vehicle_model.dart';
import '../../providers/vehicle_provider.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() =>
      _AddVehicleScreenState();
}

class _AddVehicleScreenState
    extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  final vehicleNoController =
      TextEditingController();

  final capacityController =
      TextEditingController();

  String vehicleType = "Car";

  final vehicleTypes = [
    "Car",
    "Mini Bus",
    "Bus",
    "Van",
    "SUV",
  ];

  @override
  void dispose() {
    vehicleNoController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  Future<void> saveVehicle() async {
    if (!_formKey.currentState!.validate()) return;

    final vehicle = Vehicle(
      vehicleNo: vehicleNoController.text.trim(),
      type: vehicleType,
      capacity: int.parse(
        capacityController.text.trim(),
      ),
    );

    await context
        .read<VehicleProvider>()
        .addVehicle(vehicle);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Vehicle Added Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Vehicle"),
        centerTitle: true,
        backgroundColor: Colors.orange,
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
                    Colors.orange.withOpacity(.15),

                child: const Icon(
                  Icons.directions_car,
                  color: Colors.orange,
                  size: 45,
                ),
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: vehicleNoController,

                decoration: InputDecoration(
                  labelText: "Vehicle Number",
                  prefixIcon: const Icon(
                    Icons.confirmation_number,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Enter Vehicle Number";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: vehicleType,

                decoration: InputDecoration(
                  labelText: "Vehicle Type",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                items: vehicleTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ),
                    )
                    .toList(),

                onChanged: (value) {
                  setState(() {
                    vehicleType = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: capacityController,
                keyboardType:
                    TextInputType.number,

                decoration: InputDecoration(
                  labelText: "Capacity",
                  prefixIcon:
                      const Icon(Icons.people),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Enter Capacity";
                  }

                  if (int.tryParse(value) ==
                      null) {
                    return "Enter Valid Number";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 35),
                            SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: saveVehicle,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "SAVE VEHICLE",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
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
                child: const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "Vehicle Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Vehicle will be available for trip assignment after saving.",
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