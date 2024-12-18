class UserModel {
  final String id;
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
  final bool isAdmin;

  UserModel({
    required this.id,
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
    this.isAdmin = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'email': email,
      'password': password,
      'cep': cep,
      'street': street,
      'city': city,
      'neighborhood': neighborhood,
      'state': state,
      'phone': phone,
      'birthDate': birthDate,
      'country': country,
      'number': number,
      'complement': complement,
      'isAdmin': isAdmin,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      cpf: json['cpf'],
      email: json['email'],
      password: json['password'],
      cep: json['cep'],
      street: json['street'],
      city: json['city'],
      neighborhood: json['neighborhood'],
      state: json['state'],
      phone: json['phone'],
      birthDate: json['birthDate'],
      country: json['country'],
      number: json['number'],
      complement: json['complement'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }
}
