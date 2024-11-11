class Product {
  final int id;
  final String reference;
  final String designation;
  final int categoryId;
  final int brandId;
  final double price;
  final int tvaId;

  Product({
    required this.id,
    required this.reference,
    required this.designation,
    required this.categoryId,
    required this.brandId,
    required this.price,
    required this.tvaId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      reference: json['reference'],
      designation: json['designation'],
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      price: json['price'].toDouble(),
      tvaId: json['tva_id'],
    );
  }
}
