class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String taxIdentification;
  final String address;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.taxIdentification,
    required this.address,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      taxIdentification: json['taxidentification'],
      address: json['adresse'],
      role: json['role'],
    );
  }
}
