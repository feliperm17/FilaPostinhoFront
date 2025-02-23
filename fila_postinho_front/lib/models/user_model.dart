class User {
  final int? id;
  final String name;
  final String cpf;
  final String email;
  final String number;
  final String password;
  final bool isAdmin;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['username'],
      cpf: json['cpf'],
      email: json['email'],
      number: json['phone_nr'],
      isAdmin: json['is_admin'],
    );
  }
}
