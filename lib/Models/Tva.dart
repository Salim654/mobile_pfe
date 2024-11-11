class Tva {
  final int id;
  final int countryId;
  final String? country;
  final double value;

  Tva({
    required this.id,
    required this.countryId,
    required this.value,
    this.country,
  });

  factory Tva.fromJson(Map<String, dynamic> json) {
    double value = (json['value'] as num).toDouble();

    return Tva(
      id: json['id'],
      countryId: json['country_id'],
      country: json['country_name'],
      value: value,
    );
  }
}
