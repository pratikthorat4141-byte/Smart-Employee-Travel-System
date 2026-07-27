import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/vehicle_model.dart';
import '../../../providers/vehicle_provider.dart';

class AddVehicleScreen extends StatefulWidget {
  final VehicleModel? vehicle;

  const AddVehicleScreen({
    super.key,
    this.vehicle,
  });

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  final _vehicleNumberController = TextEditingController();
  final _vehicleNameController = TextEditingController();
  final _seatingController = TextEditingController();
  final _fuelController = TextEditingController();
  final _registrationController = TextEditingController();
  final _insuranceController = TextEditingController();

  String _vehicleType = "Car";

  bool _available = true;
  bool _active = true;

  bool get isEdit => widget.vehicle != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final v = widget.vehicle!;

      _vehicleNumberController.text = v.vehicleNumber;
      _vehicleNameController.text = v.vehicleName;
      _vehicleType = v.vehicleType;
      _seatingController.text = v.seatingCapacity.toString();
      _fuelController.text = v.fuelType;
      _registrationController.text = v.registrationDate;
      _insuranceController.text = v.insuranceExpiry;
      _available = v.isAvailable;
      _active = v.isActive;
    }
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _vehicleNameController.dispose();
    _seatingController.dispose();
    _fuelController.dispose();
    _registrationController.dispose();
    _insuranceController.dispose();
    super.dispose();
  }

  Future<void> _pickRegistrationDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      _registrationController.text =
          "${date.day}/${date.month}/${date.year}";
    }
  }

  Future<void> _pickInsuranceDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      _insuranceController.text =
          "${date.day}/${date.month}/${date.year}";
    }
  }

  Future<void> _saveVehicle() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<VehicleProvider>();

    final vehicle = VehicleModel(
      id: widget.vehicle?.id,
      vehicleNumber: _vehicleNumberController.text.trim(),
      vehicleName: _vehicleNameController.text.trim(),
      vehicleType: _vehicleType,
      seatingCapacity:
          int.tryParse(_seatingController.text.trim()) ?? 4,
      fuelType: _fuelController.text.trim(),
      registrationDate: _registrationController.text.trim(),
      insuranceExpiry: _insuranceController.text.trim(),
      isAvailable: _available,
      isActive: _active,
    );

    bool success;

    if (isEdit) {
      success = await provider.updateVehicle(vehicle);
    } else {
      success = await provider.addVehicle(vehicle);
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? "Vehicle Updated Successfully"
                : "Vehicle Added Successfully",
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? "Operation Failed",
          ),
        ),
      );
    }
  }

  Widget gap() => const SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Vehicle" : "Add Vehicle",
        ),
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
                  controller: _vehicleNumberController,
                  decoration: const InputDecoration(
                    labelText: "Vehicle Number",
                    prefixIcon: Icon(Icons.confirmation_number),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                TextFormField(
                  controller: _vehicleNameController,
                  decoration: const InputDecoration(
                    labelText: "Vehicle Name",
                    prefixIcon: Icon(Icons.directions_car),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                DropdownButtonFormField<String>(
                  value: _vehicleType,
                  decoration: const InputDecoration(
                    labelText: "Vehicle Type",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: "Car",
                        child: Text("Car")),
                    DropdownMenuItem(
                        value: "Sedan",
                        child: Text("Sedan")),
                    DropdownMenuItem(
                        value: "SUV",
                        child: Text("SUV")),
                    DropdownMenuItem(
                        value: "Van",
                        child: Text("Van")),
                    DropdownMenuItem(
                        value: "Mini Bus",
                        child: Text("Mini Bus")),
                    DropdownMenuItem(
                        value: "Bus",
                        child: Text("Bus")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _vehicleType = value!;
                    });
                  },
                ),

                gap(),

                TextFormField(
                  controller: _seatingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Seating Capacity",
                    prefixIcon: Icon(Icons.event_seat),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                TextFormField(
                  controller: _fuelController,
                  decoration: const InputDecoration(
                    labelText: "Fuel Type",
                    prefixIcon: Icon(Icons.local_gas_station),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                TextFormField(
                  controller: _registrationController,
                  readOnly: true,
                  onTap: _pickRegistrationDate,
                  decoration: InputDecoration(
                    labelText: "Registration Date",
                    border: const OutlineInputBorder(),
                    prefixIcon:
                        const Icon(Icons.calendar_today),
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.date_range),
                      onPressed:
                          _pickRegistrationDate,
                    ),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                TextFormField(
                  controller: _insuranceController,
                  readOnly: true,
                  onTap: _pickInsuranceDate,
                  decoration: InputDecoration(
                    labelText: "Insurance Expiry",
                    border: const OutlineInputBorder(),
                    prefixIcon:
                        const Icon(Icons.calendar_month),
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.date_range),
                      onPressed:
                          _pickInsuranceDate,
                    ),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                SwitchListTile(
                  value: _available,
                  title: const Text("Available"),
                  onChanged: (value) {
                    setState(() {
                      _available = value;
                    });
                  },
                ),

                SwitchListTile(
                  value: _active,
                  title: const Text("Active"),
                  onChanged: (value) {
                    setState(() {
                      _active = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _saveVehicle,
                    icon: Icon(
                      isEdit
                          ? Icons.edit
                          : Icons.save,
                    ),
                    label: Text(
                      isEdit
                          ? "Update Vehicle"
                          : "Save Vehicle",
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