class TripModel {
  final int? id;

  final String tripId;

  final int employeeId;
  final int driverId;
  final int vehicleId;

  final String pickupLocation;
  final String destination;

  final String tripDate;
  final String tripTime;

  final double totalDistance;

  final String status;

  final String remarks;

  final String createdAt;

  const TripModel({
    this.id,
    required this.tripId,
    required this.employeeId,
    required this.driverId,
    required this.vehicleId,
    required this.pickupLocation,
    required this.destination,
    required this.tripDate,
    required this.tripTime,
    required this.totalDistance,
    required this.status,
    required this.remarks,
    required this.createdAt,
  });

  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      id: map['id'] as int?,
      tripId: map['tripId'] ?? '',
      employeeId: map['employeeId'] ?? 0,
      driverId: map['driverId'] ?? 0,
      vehicleId: map['vehicleId'] ?? 0,
      pickupLocation: map['pickupLocation'] ?? '',
      destination: map['destination'] ?? '',
      tripDate: map['tripDate'] ?? '',
      tripTime: map['tripTime'] ?? '',
      totalDistance: (map['totalDistance'] ?? 0).toDouble(),
      status: map['status'] ?? '',
      remarks: map['remarks'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'employeeId': employeeId,
      'driverId': driverId,
      'vehicleId': vehicleId,
      'pickupLocation': pickupLocation,
      'destination': destination,
      'tripDate': tripDate,
      'tripTime': tripTime,
      'totalDistance': totalDistance,
      'status': status,
      'remarks': remarks,
      'createdAt': createdAt,
    };
  }

  TripModel copyWith({
    int? id,
    String? tripId,
    int? employeeId,
    int? driverId,
    int? vehicleId,
    String? pickupLocation,
    String? destination,
    String? tripDate,
    String? tripTime,
    double? totalDistance,
    String? status,
    String? remarks,
    String? createdAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      employeeId: employeeId ?? this.employeeId,
      driverId: driverId ?? this.driverId,
      vehicleId: vehicleId ?? this.vehicleId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destination: destination ?? this.destination,
      tripDate: tripDate ?? this.tripDate,
      tripTime: tripTime ?? this.tripTime,
      totalDistance: totalDistance ?? this.totalDistance,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return '''
TripModel(
  id: $id,
  tripId: $tripId,
  employeeId: $employeeId,
  driverId: $driverId,
  vehicleId: $vehicleId,
  pickupLocation: $pickupLocation,
  destination: $destination,
  tripDate: $tripDate,
  tripTime: $tripTime,
  totalDistance: $totalDistance,
  status: $status,
  remarks: $remarks,
  createdAt: $createdAt
)
''';
  }
}