class Trip {
  int? id;
  String employee;
  String driver;
  String vehicle;
  String source;
  String destination;
  String status;

  Trip({
    this.id,
    required this.employee,
    required this.driver,
    required this.vehicle,
    required this.source,
    required this.destination,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee': employee,
      'driver': driver,
      'vehicle': vehicle,
      'source': source,
      'destination': destination,
      'status': status,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      employee: map['employee'],
      driver: map['driver'],
      vehicle: map['vehicle'],
      source: map['source'],
      destination: map['destination'],
      status: map['status'],
    );
  }

  Trip copyWith({
    int? id,
    String? employee,
    String? driver,
    String? vehicle,
    String? source,
    String? destination,
    String? status,
  }) {
    return Trip(
      id: id ?? this.id,
      employee: employee ?? this.employee,
      driver: driver ?? this.driver,
      vehicle: vehicle ?? this.vehicle,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      status: status ?? this.status,
    );
  }
}