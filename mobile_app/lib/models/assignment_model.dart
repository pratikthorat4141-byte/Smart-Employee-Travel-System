class AssignmentModel {
  final int? id;

  final String assignmentId;

  final int tripId;

  final int driverId;

  final int vehicleId;

  final List<int> employeeIds;

  final String assignmentDate;

  final String status;

  const AssignmentModel({
    this.id,
    required this.assignmentId,
    required this.tripId,
    required this.driverId,
    required this.vehicleId,
    required this.employeeIds,
    required this.assignmentDate,
    required this.status,
  });

  factory AssignmentModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return AssignmentModel(
      id: map['id'],
      assignmentId: map['assignmentId'] ?? '',
      tripId: map['tripId'] ?? 0,
      driverId: map['driverId'] ?? 0,
      vehicleId: map['vehicleId'] ?? 0,
      employeeIds:
          (map['employeeIds'] as String)
              .split(',')
              .map(int.parse)
              .toList(),
      assignmentDate:
          map['assignmentDate'] ?? '',
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'tripId': tripId,
      'driverId': driverId,
      'vehicleId': vehicleId,
      'employeeIds':
          employeeIds.join(','),
      'assignmentDate':
          assignmentDate,
      'status': status,
    };
  }

  AssignmentModel copyWith({
    int? id,
    String? assignmentId,
    int? tripId,
    int? driverId,
    int? vehicleId,
    List<int>? employeeIds,
    String? assignmentDate,
    String? status,
  }) {
    return AssignmentModel(
      id: id ?? this.id,
      assignmentId:
          assignmentId ??
              this.assignmentId,
      tripId: tripId ?? this.tripId,
      driverId:
          driverId ?? this.driverId,
      vehicleId:
          vehicleId ?? this.vehicleId,
      employeeIds:
          employeeIds ??
              this.employeeIds,
      assignmentDate:
          assignmentDate ??
              this.assignmentDate,
      status: status ?? this.status,
    );
  }
}