class DriverModel {
  final int? id;
  final String driverId;
  final String name;
  final String mobile;
  final String email;
  final String licenseNumber;
  final String address;
  final String gender;
  final String joiningDate;
  final bool isAvailable;
  final bool isActive;

  const DriverModel({
    this.id,
    required this.driverId,
    required this.name,
    required this.mobile,
    required this.email,
    required this.licenseNumber,
    required this.address,
    required this.gender,
    required this.joiningDate,
    this.isAvailable = true,
    this.isActive = true,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'] as int?,
      driverId: map['driverId'] ?? '',
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      address: map['address'] ?? '',
      gender: map['gender'] ?? '',
      joiningDate: map['joiningDate'] ?? '',
      isAvailable: (map['isAvailable'] ?? 1) == 1,
      isActive: (map['isActive'] ?? 1) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driverId': driverId,
      'name': name,
      'mobile': mobile,
      'email': email,
      'licenseNumber': licenseNumber,
      'address': address,
      'gender': gender,
      'joiningDate': joiningDate,
      'isAvailable': isAvailable ? 1 : 0,
      'isActive': isActive ? 1 : 0,
    };
  }

  DriverModel copyWith({
    int? id,
    String? driverId,
    String? name,
    String? mobile,
    String? email,
    String? licenseNumber,
    String? address,
    String? gender,
    String? joiningDate,
    bool? isAvailable,
    bool? isActive,
  }) {
    return DriverModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      joiningDate: joiningDate ?? this.joiningDate,
      isAvailable: isAvailable ?? this.isAvailable,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return '''
DriverModel(
  id: $id,
  driverId: $driverId,
  name: $name,
  mobile: $mobile,
  email: $email,
  licenseNumber: $licenseNumber,
  address: $address,
  gender: $gender,
  joiningDate: $joiningDate,
  isAvailable: $isAvailable,
  isActive: $isActive
)
''';
  }
}