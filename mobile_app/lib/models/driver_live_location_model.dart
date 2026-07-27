class DriverLiveLocationModel {
  final int? id;
  final String driverId;
  final int? tripId;

  final double latitude;
  final double longitude;

  final double speed;
  final double heading;
  final double accuracy;

  final DateTime createdAt;

  const DriverLiveLocationModel({
    this.id,
    required this.driverId,
    this.tripId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.accuracy,
    required this.createdAt,
  });

  factory DriverLiveLocationModel.fromMap(
      Map<String, dynamic> map) {
    return DriverLiveLocationModel(
      id: map['id'] as int?,
      driverId: map['driverId'] ?? '',
      tripId: map['tripId'] as int?,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      speed: (map['speed'] as num).toDouble(),
      heading: (map['heading'] as num).toDouble(),
      accuracy: (map['accuracy'] as num).toDouble(),
      createdAt: DateTime.parse(
        map['createdAt'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driverId': driverId,
      'tripId': tripId,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'heading': heading,
      'accuracy': accuracy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  DriverLiveLocationModel copyWith({
    int? id,
    String? driverId,
    int? tripId,
    double? latitude,
    double? longitude,
    double? speed,
    double? heading,
    double? accuracy,
    DateTime? createdAt,
  }) {
    return DriverLiveLocationModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      tripId: tripId ?? this.tripId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      accuracy: accuracy ?? this.accuracy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}