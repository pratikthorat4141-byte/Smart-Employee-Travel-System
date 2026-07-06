class Employee {
  int? id;
  String name;
  String email;
  String department;

  Employee({
    this.id,
    required this.name,
    required this.email,
    required this.department,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      department: map['department'],
    );
  }

  Employee copyWith({
    int? id,
    String? name,
    String? email,
    String? department,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
    );
  }
}