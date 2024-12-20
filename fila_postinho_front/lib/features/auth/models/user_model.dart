class UserModel {
  final int? id;
  final String name;
  final String cpf;
  final String email;
  final String number;
  final String password;
  final bool isAdmin;

  UserModel({
    this.id,
    required this.name,
    required this.cpf,
    required this.email,
    required this.number,
    this.password = '',
    this.isAdmin = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': name,
      'cpf': cpf,
      'email': email,
      'phone_nr': number,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['username'],
      cpf: json['cpf'],
      email: json['email'],
      number: json['phone_nr'],
      isAdmin: json['account_st'] == '1',
    );
  }
}
