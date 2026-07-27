class LiveLocationModel {
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final double accuracy;
  final DateTime timestamp;

  const LiveLocationModel({
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.accuracy,
    required this.timestamp,
  });

  factory LiveLocationModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return LiveLocationModel(
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      speed: (map['speed'] ?? 0).toDouble(),
      heading: (map['heading'] ?? 0).toDouble(),
      accuracy: (map['accuracy'] ?? 0).toDouble(),
      timestamp: DateTime.tryParse(
            map['timestamp'] ?? '',
          ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'heading': heading,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  LiveLocationModel copyWith({
    double? latitude,
    double? longitude,
    double? speed,
    double? heading,
    double? accuracy,
    DateTime? timestamp,
  }) {
    return LiveLocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      accuracy: accuracy ?? this.accuracy,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return '''
LiveLocationModel(
  latitude: $latitude,
  longitude: $longitude,
  speed: $speed,
  heading: $heading,
  accuracy: $accuracy,
  timestamp: $timestamp
)
''';
  }
}