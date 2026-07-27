class UserModel {
  final int? id;
  final String name;
 final String email;
  final String mobile;
  final String password;
  final String role;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'password': password,
      'role': role,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? mobile,
    String? password,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return '''
UserModel(
  id: $id,
  name: $name,
  email: $email,
  mobile: $mobile,
  role: $role
)
''';
  }
}