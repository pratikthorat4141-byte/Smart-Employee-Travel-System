import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/vehicle_model.dart';
import '../../providers/vehicle_provider.dart';

class EditVehicleScreen extends StatefulWidget {
  final Vehicle vehicle;

  const EditVehicleScreen({
    super.key,
    required this.vehicle,
  });

  @override
  State<EditVehicleScreen> createState() =>
      _EditVehicleScreenState();
}

class _EditVehicleScreenState
    extends State<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController vehicleNoController;
  late TextEditingController capacityController;

  late String vehicleType;

  final vehicleTypes = [
    "Car",
    "Mini Bus",
    "Bus",
    "Van",
    "SUV",
  ];

  @override
  void initState() {
    super.initState();

    vehicleNoController =
        TextEditingController(
      text: widget.vehicle.vehicleNo,
    );

    capacityController =
        TextEditingController(
      text: widget.vehicle.capacity.toString(),
    );

    vehicleType = widget.vehicle.type;
  }

  @override
  void dispose() {
    vehicleNoController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  Future<void> updateVehicle() async {
    if (!_formKey.currentState!.validate()) return;

    final vehicle = widget.vehicle.copyWith(
      vehicleNo: vehicleNoController.text.trim(),
      type: vehicleType,
      capacity: int.parse(
        capacityController.text.trim(),
      ),
    );

    await context
        .read<VehicleProvider>()
        .updateVehicle(vehicle);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Vehicle Updated Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Vehicle"),
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
                  Icons.edit,
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
                  onPressed: updateVehicle,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "UPDATE VEHICLE",
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
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    "Vehicle Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Vehicle ID : ${widget.vehicle.id}",
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