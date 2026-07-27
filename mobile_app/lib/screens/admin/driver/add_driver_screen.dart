import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/driver_model.dart';
import '../../../providers/driver_provider.dart';

class AddDriverScreen extends StatefulWidget {
  final DriverModel? driver;

  const AddDriverScreen({
    super.key,
    this.driver,
  });

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final _formKey = GlobalKey<FormState>();

  final _driverIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _licenseController = TextEditingController();
  final _addressController = TextEditingController();
  final _joiningDateController = TextEditingController();

  String _gender = "Male";
  bool _available = true;
  bool _active = true;

  bool get isEdit => widget.driver != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final d = widget.driver!;

      _driverIdController.text = d.driverId;
      _nameController.text = d.name;
      _mobileController.text = d.mobile;
      _emailController.text = d.email;
      _licenseController.text = d.licenseNumber;
      _addressController.text = d.address;
      _joiningDateController.text = d.joiningDate;

      _gender = d.gender;
      _available = d.isAvailable;
      _active = d.isActive;
    }
  }

  @override
  void dispose() {
    _driverIdController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _licenseController.dispose();
    _addressController.dispose();
    _joiningDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    _joiningDateController.text =
        "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<DriverProvider>();

    final driver = DriverModel(
      id: widget.driver?.id,
      driverId: _driverIdController.text.trim(),
      name: _nameController.text.trim(),
      mobile: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      address: _addressController.text.trim(),
      gender: _gender,
      joiningDate: _joiningDateController.text.trim(),
      isAvailable: _available,
      isActive: _active,
    );

    bool success;

    if (isEdit) {
      success = await provider.updateDriver(driver);
    } else {
      success = await provider.addDriver(driver);
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? "Driver Updated Successfully"
                : "Driver Added Successfully",
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
          isEdit ? "Edit Driver" : "Add Driver",
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
                  controller: _driverIdController,
                  decoration: const InputDecoration(
                    labelText: "Driver ID",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Driver Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Mobile",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (v) {
                    if (v == null || v.length != 10) {
                      return "Enter valid mobile";
                    }
                    return null;
                  },
                ),

                gap(),

                TextFormField(
                  controller: _emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                TextFormField(
                  controller: _licenseController,
                  decoration: const InputDecoration(
                    labelText: "License Number",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Male",
                      child: Text("Male"),
                    ),
                    DropdownMenuItem(
                      value: "Female",
                      child: Text("Female"),
                    ),
                    DropdownMenuItem(
                      value: "Other",
                      child: Text("Other"),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() {
                      _gender = v!;
                    });
                  },
                ),

                gap(),

                TextFormField(
                  controller: _joiningDateController,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: InputDecoration(
                    labelText: "Joining Date",
                    border: const OutlineInputBorder(),
                    prefixIcon:
                        const Icon(Icons.calendar_today),
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.date_range),
                      onPressed: _pickDate,
                    ),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? "Required" : null,
                ),

                gap(),

                SwitchListTile(
                  value: _available,
                  title: const Text("Available"),
                  onChanged: (v) {
                    setState(() {
                      _available = v;
                    });
                  },
                ),

                SwitchListTile(
                  value: _active,
                  title: const Text("Active"),
                  onChanged: (v) {
                    setState(() {
                      _active = v;
                    });
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: Icon(
                      isEdit
                          ? Icons.edit
                          : Icons.save,
                    ),
                    label: Text(
                      isEdit
                          ? "Update Driver"
                          : "Save Driver",
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