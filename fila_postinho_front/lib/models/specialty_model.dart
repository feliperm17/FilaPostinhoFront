class Specialty {
  final int? specialtyId;
  final String specialtyName;

  Specialty({
    this.specialtyId,
    required this.specialtyName,
  });

  // Add equality checks
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Specialty &&
        other.specialtyId == specialtyId &&
        other.specialtyName == specialtyName;
  }

  @override
  int get hashCode => specialtyId.hashCode ^ specialtyName.hashCode;

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      specialtyId: json['specialty_id'] != null ? int.parse(json['specialty_id'].toString()) : null,
      specialtyName: json['specialty_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specialty_id': specialtyId,
      'specialty_name': specialtyName,
    };
  }
}