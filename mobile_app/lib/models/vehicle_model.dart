class VehicleModel {
  final int? id;
  final String vehicleNumber;
  final String vehicleName;
  final String vehicleType;
  final int seatingCapacity;
  final String fuelType;
  final String registrationDate;
  final String insuranceExpiry;
  final bool isAvailable;
  final bool isActive;

  const VehicleModel({
    this.id,
    required this.vehicleNumber,
    required this.vehicleName,
    required this.vehicleType,
    required this.seatingCapacity,
    required this.fuelType,
    required this.registrationDate,
    required this.insuranceExpiry,
    this.isAvailable = true,
    this.isActive = true,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'] as int?,
      vehicleNumber: map['vehicleNumber'] ?? '',
      vehicleName: map['vehicleName'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      seatingCapacity: map['seatingCapacity'] ?? 0,
      fuelType: map['fuelType'] ?? '',
      registrationDate: map['registrationDate'] ?? '',
      insuranceExpiry: map['insuranceExpiry'] ?? '',
      isAvailable: (map['isAvailable'] ?? 1) == 1,
      isActive: (map['isActive'] ?? 1) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleNumber': vehicleNumber,
      'vehicleName': vehicleName,
      'vehicleType': vehicleType,
      'seatingCapacity': seatingCapacity,
      'fuelType': fuelType,
      'registrationDate': registrationDate,
      'insuranceExpiry': insuranceExpiry,
      'isAvailable': isAvailable ? 1 : 0,
      'isActive': isActive ? 1 : 0,
    };
  }

  VehicleModel copyWith({
    int? id,
    String? vehicleNumber,
    String? vehicleName,
    String? vehicleType,
    int? seatingCapacity,
    String? fuelType,
    String? registrationDate,
    String? insuranceExpiry,
    bool? isAvailable,
    bool? isActive,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleName: vehicleName ?? this.vehicleName,
      vehicleType: vehicleType ?? this.vehicleType,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      fuelType: fuelType ?? this.fuelType,
      registrationDate: registrationDate ?? this.registrationDate,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      isAvailable: isAvailable ?? this.isAvailable,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return '''
VehicleModel(
  id: $id,
  vehicleNumber: $vehicleNumber,
  vehicleName: $vehicleName,
  vehicleType: $vehicleType,
  seatingCapacity: $seatingCapacity,
  fuelType: $fuelType,
  registrationDate: $registrationDate,
  insuranceExpiry: $insuranceExpiry,
  isAvailable: $isAvailable,
  isActive: $isActive
)
''';
  }
}