class Vehicle {
  int? id;
  String vehicleNo;
  String type;
  int capacity;

  Vehicle({
    this.id,
    required this.vehicleNo,
    required this.type,
    required this.capacity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleNo': vehicleNo,
      'type': type,
      'capacity': capacity,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      vehicleNo: map['vehicleNo'],
      type: map['type'],
      capacity: map['capacity'],
    );
  }

  Vehicle copyWith({
    int? id,
    String? vehicleNo,
    String? type,
    int? capacity,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      type: type ?? this.type,
      capacity: capacity ?? this.capacity,
    );
  }
}