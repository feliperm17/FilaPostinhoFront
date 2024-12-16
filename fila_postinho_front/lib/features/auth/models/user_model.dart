class UserModel {
  final String name;
  final String cpf;
  final String email;
  final String password;
  final String cep;
  final String street;
  final String city;
  final String neighborhood;
  final String state;
  final String phone;
  final String birthDate;
  final String country;
  final String number;
  final String? complement;

  UserModel({
    required this.name,
    required this.cpf,
    required this.email,
    required this.password,
    required this.cep,
    required this.street,
    required this.city,
    required this.neighborhood,
    required this.state,
    required this.phone,
    required this.birthDate,
    required this.country,
    required this.number,
    this.complement,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cpf': cpf,
      'email': email,
      'password': password,
      'cep': cep,
      'street': street,
      'city': city,
      'neighborhood': neighborhood,
      'state': state,
      'phone_nr': phone,
      'birthDate': birthDate,
      'country': country,
      'number': number,
      'complement': complement,
    };
  }
}
