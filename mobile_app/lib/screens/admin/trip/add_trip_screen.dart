import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/trip_model.dart';

import '../../../providers/trip_provider.dart';
import '../../../providers/employee_provider.dart';
import '../../../providers/driver_provider.dart';
import '../../../providers/vehicle_provider.dart';

class AddTripScreen extends StatefulWidget {
  final TripModel? trip;

  const AddTripScreen({
    super.key,
    this.trip,
  });

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //----------------------------------------------------------
  // Controllers
  //----------------------------------------------------------

  final TextEditingController _tripIdController =
      TextEditingController();

  final TextEditingController _pickupController =
      TextEditingController();

  final TextEditingController _destinationController =
      TextEditingController();

  final TextEditingController _distanceController =
      TextEditingController();

  final TextEditingController _remarksController =
      TextEditingController();

  //----------------------------------------------------------
  // Variables
  //----------------------------------------------------------

  int? _employeeId;
  int? _driverId;
  int? _vehicleId;

  DateTime? _tripDate;
  TimeOfDay? _tripTime;

  bool get isEdit => widget.trip != null;

  //----------------------------------------------------------
  // INIT
  //----------------------------------------------------------

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      final trip = widget.trip!;

      _tripIdController.text = trip.tripId;
      _pickupController.text = trip.pickupLocation;
      _destinationController.text = trip.destination;
      _distanceController.text =
          trip.totalDistance.toString();
      _remarksController.text = trip.remarks;

      _employeeId = trip.employeeId;
      _driverId = trip.driverId;
      _vehicleId = trip.vehicleId;

      _tripDate = DateTime.parse(
        trip.tripDate,
      );

      final parts = trip.tripTime.split(":");

      _tripTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } else {
      _tripIdController.text =
          "TRIP-${DateTime.now().millisecondsSinceEpoch}";
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context
          .read<EmployeeProvider>()
          .loadEmployees();

      await context
          .read<DriverProvider>()
          .loadDrivers();

      await context
          .read<VehicleProvider>()
          .loadVehicles();

      if (mounted) {
        setState(() {});
      }
    });
  }

  //----------------------------------------------------------
  // DISPOSE
  //----------------------------------------------------------

  @override
  void dispose() {
    _tripIdController.dispose();
    _pickupController.dispose();
    _destinationController.dispose();
    _distanceController.dispose();
    _remarksController.dispose();

    super.dispose();
  }
    //----------------------------------------------------------
  // DATE PICKER
  //----------------------------------------------------------

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tripDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _tripDate = picked;
      });
    }
  }

  //----------------------------------------------------------
  // TIME PICKER
  //----------------------------------------------------------

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _tripTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _tripTime = picked;
      });
    }
  }

  //----------------------------------------------------------
  // SAVE TRIP
  //----------------------------------------------------------

  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_employeeId == null ||
        _driverId == null ||
        _vehicleId == null ||
        _tripDate == null ||
        _tripTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please complete all required fields.",
          ),
        ),
      );
      return;
    }

    final provider = context.read<TripProvider>();

    final trip = TripModel(
      id: widget.trip?.id,
      tripId: _tripIdController.text.trim(),
      employeeId: _employeeId!,
      driverId: _driverId!,
      vehicleId: _vehicleId!,
      pickupLocation: _pickupController.text.trim(),
      destination: _destinationController.text.trim(),
      tripDate: DateFormat(
        "yyyy-MM-dd",
      ).format(_tripDate!),
      tripTime:
          "${_tripTime!.hour.toString().padLeft(2, '0')}:${_tripTime!.minute.toString().padLeft(2, '0')}",
      totalDistance: double.parse(
        _distanceController.text.trim(),
      ),
      status: widget.trip?.status ?? "Assigned",
      remarks: _remarksController.text.trim(),
      createdAt:
          widget.trip?.createdAt ??
              DateTime.now().toIso8601String(),
    );

    bool success;

    if (isEdit) {
      success = await provider.updateTrip(trip);
    } else {
      success = await provider.addTrip(trip);
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                "Unable to save trip.",
          ),
        ),
      );
    }
  }

  //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final employeeProvider =
        context.watch<EmployeeProvider>();

    final driverProvider =
        context.watch<DriverProvider>();

    final vehicleProvider =
        context.watch<VehicleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Update Trip" : "Add Trip",
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
                            //----------------------------------------------------------
              // TRIP ID
              //----------------------------------------------------------

              TextFormField(
                controller: _tripIdController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Trip ID",
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
              ),

              const SizedBox(height: 16),

              //----------------------------------------------------------
              // EMPLOYEE
              //----------------------------------------------------------

              DropdownButtonFormField<int>(
                isExpanded: true,
                value: employeeProvider.employees.any(
                        (e) => e.id == _employeeId)
                    ? _employeeId
                    : null,
                decoration: const InputDecoration(
                  labelText: "Employee",
                  prefixIcon: Icon(Icons.person),
                ),
                items: employeeProvider.employees
                    .map(
                      (employee) => DropdownMenuItem<int>(
                        value: employee.id,
                        child: Text(
                          employee.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _employeeId = value;
                  });
                },
                validator: (value) =>
                    value == null
                        ? "Select Employee"
                        : null,
              ),

              const SizedBox(height: 16),

              //----------------------------------------------------------
              // DRIVER
              //----------------------------------------------------------

              DropdownButtonFormField<int>(
                isExpanded: true,
                value: driverProvider.drivers.any(
                        (d) => d.id == _driverId)
                    ? _driverId
                    : null,
                decoration: const InputDecoration(
                  labelText: "Driver",
                  prefixIcon: Icon(Icons.drive_eta),
                ),
                items: driverProvider.drivers
                    .map(
                      (driver) => DropdownMenuItem<int>(
                        value: driver.id,
                        child: Text(
                          driver.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _driverId = value;
                  });
                },
                validator: (value) =>
                    value == null
                        ? "Select Driver"
                        : null,
              ),

              const SizedBox(height: 16),

              //----------------------------------------------------------
              // VEHICLE
              //----------------------------------------------------------

              DropdownButtonFormField<int>(
                isExpanded: true,
                value: vehicleProvider.vehicles.any(
                        (v) => v.id == _vehicleId)
                    ? _vehicleId
                    : null,
                decoration: const InputDecoration(
                  labelText: "Vehicle",
                  prefixIcon: Icon(Icons.directions_car),
                ),
                items: vehicleProvider.vehicles
                    .map(
                      (vehicle) => DropdownMenuItem<int>(
                        value: vehicle.id,
                        child: Text(
                          "${vehicle.vehicleNumber} (${vehicle.vehicleType})",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _vehicleId = value;
                  });
                },
                validator: (value) =>
                    value == null
                        ? "Select Vehicle"
                        : null,
              ),

              const SizedBox(height: 16),

              //----------------------------------------------------------
              // PICKUP LOCATION
              //----------------------------------------------------------

              TextFormField(
                controller: _pickupController,
                decoration: const InputDecoration(
                  labelText: "Pickup Location",
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Enter Pickup Location";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              //----------------------------------------------------------
              // DESTINATION
              //----------------------------------------------------------

              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: "Destination",
                  prefixIcon: Icon(Icons.flag),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Enter Destination";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
                            //----------------------------------------------------------
              // DISTANCE
              //----------------------------------------------------------

              TextFormField(
                controller: _distanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: "Distance (KM)",
                  prefixIcon: Icon(Icons.route),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter Distance";
                  }

                  if (double.tryParse(value.trim()) == null) {
                    return "Invalid Distance";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              //----------------------------------------------------------
              // TRIP DATE (FIXED)
              //----------------------------------------------------------

              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Trip Date",
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _tripDate == null
                        ? "Select Trip Date"
                        : DateFormat("dd MMM yyyy")
                            .format(_tripDate!),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //----------------------------------------------------------
              // TRIP TIME (FIXED)
              //----------------------------------------------------------

              InkWell(
                onTap: _pickTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Trip Time",
                    prefixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _tripTime == null
                        ? "Select Trip Time"
                        : _tripTime!.format(context),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //----------------------------------------------------------
              // REMARKS
              //----------------------------------------------------------

              TextFormField(
                controller: _remarksController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Remarks",
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 30),
                            //----------------------------------------------------------
              // SAVE BUTTON
              //----------------------------------------------------------

              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton.icon(
                  onPressed: _saveTrip,
                  icon: Icon(
                    isEdit
                        ? Icons.edit
                        : Icons.save,
                  ),
                  label: Text(
                    isEdit
                        ? "Update Trip"
                        : "Save Trip",
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}