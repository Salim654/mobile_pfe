
class Country {
  final int id;
  final String country;

  Country({
    required this.id,
    required this.country,
  });
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      country: json['country'],
    );
  }
}
