class Brand {
  final int id;
  final int organization_id;
  final String name;
  final String description;

  Brand({
    required this.id,
    required this.organization_id,
    required this.name,
    required this.description,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      organization_id: json['organization_id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
