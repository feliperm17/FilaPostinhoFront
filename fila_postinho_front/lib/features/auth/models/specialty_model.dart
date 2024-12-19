class SpecialtyModel {
  final int id;
  final String specialtyName;

  SpecialtyModel({
    required this.id,
    required this.specialtyName,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id'],
      specialtyName: json['specialty_name'],
    );
  }
}
