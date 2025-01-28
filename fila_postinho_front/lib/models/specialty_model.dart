class Specialty {
  final int? specialtyId;
  final String specialtyName;

  Specialty({
    this.specialtyId,
    required this.specialtyName,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) {
    return Specialty(
      specialtyId: json['specialty_id'],
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