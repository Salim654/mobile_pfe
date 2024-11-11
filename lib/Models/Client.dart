class Client {
  final int id;
  final int organization_id;
  final String name;
  final String identification;
  final String email;
  final String phone;
  final String address;

  Client({
    required this.id,
    required this.organization_id,
    required this.name,
    required this.identification,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      organization_id: json['organization_id'],
      name: json['name'],
      identification: json['identification'],
      email: json['email'],
      phone: json['phone'],
      address: json['adresse'],
    );
  }
}
