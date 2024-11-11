class Category {
  final int id;
  final int organization_id;
  final String category;
  final String reference;
  final String description;

  Category({
    required this.id,
    required this.organization_id,
    required this.category,
    required this.reference,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      organization_id: json['organization_id'],
      category: json['category'],
      reference: json['reference'],
      description: json['description'],
    );
  }
}
