class Driver {
  int? id;
  String name;
  String phone;
  String licenseNo;

  Driver({
    this.id,
    required this.name,
    required this.phone,
    required this.licenseNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'licenseNo': licenseNo,
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      licenseNo: map['licenseNo'],
    );
  }

  Driver copyWith({
    int? id,
    String? name,
    String? phone,
    String? licenseNo,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      licenseNo: licenseNo ?? this.licenseNo,
    );
  }
}