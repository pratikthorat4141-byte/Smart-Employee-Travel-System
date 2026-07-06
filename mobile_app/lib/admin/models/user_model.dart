class UserModel {
  int? id;
  String name;
  String email;
  String password;
  String role;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "role": role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"],
      name: map["name"],
      email: map["email"],
      password: map["password"],
      role: map["role"],
    );
  }
}