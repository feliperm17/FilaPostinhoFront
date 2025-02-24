class Specialty {
  final int? specialtyId;
  final String specialtyName;
  final List<int> availableDays;
  final int estimatedTime;

  Specialty({
    this.specialtyId,
    required this.specialtyName,
    this.availableDays = const [],
    required this.estimatedTime
  });

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      specialtyId: json['specialty_id'] != null ? int.parse(json['specialty_id'].toString()) : null,
      specialtyName: json['specialty_name'],
      availableDays: json['available_days'] != null ? List<int>.from(json['available_days']) : [],
      estimatedTime: json['estimated_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specialty_id': specialtyId,
      'specialty_name': specialtyName,
      'available_days': availableDays,
      'estimated_time': estimatedTime
    };
  }
}