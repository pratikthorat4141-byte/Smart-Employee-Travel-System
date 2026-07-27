class EmployeeModel {
  final int? id;
  final String employeeId;
  final String name;
  final String department;
  final String designation;
  final String mobile;
  final String email;
  final String address;
  final String gender;
  final String joiningDate;
  final bool isActive;

  const EmployeeModel({
    this.id,
    required this.employeeId,
    required this.name,
    required this.department,
    required this.designation,
    required this.mobile,
    required this.email,
    required this.address,
    required this.gender,
    required this.joiningDate,
    this.isActive = true,
  });

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'] as int?,
      employeeId: map['employeeId'] ?? '',
      name: map['name'] ?? '',
      department: map['department'] ?? '',
      designation: map['designation'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      gender: map['gender'] ?? '',
      joiningDate: map['joiningDate'] ?? '',
      isActive: (map['isActive'] ?? 1) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'name': name,
      'department': department,
      'designation': designation,
      'mobile': mobile,
      'email': email,
      'address': address,
      'gender': gender,
      'joiningDate': joiningDate,
      'isActive': isActive ? 1 : 0,
    };
  }

  EmployeeModel copyWith({
    int? id,
    String? employeeId,
    String? name,
    String? department,
    String? designation,
    String? mobile,
    String? email,
    String? address,
    String? gender,
    String? joiningDate,
    bool? isActive,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      name: name ?? this.name,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      joiningDate: joiningDate ?? this.joiningDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return '''
EmployeeModel(
  id: $id,
  employeeId: $employeeId,
  name: $name,
  department: $department,
  designation: $designation,
  mobile: $mobile,
  email: $email,
  address: $address,
  gender: $gender,
  joiningDate: $joiningDate,
  isActive: $isActive
)
''';
  }
}