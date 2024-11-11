class ProductD {
  final String reference;
  final String designation;
  final String categoryId;
  final String brandId;
  final double price;
  final int tvaId;

  ProductD({
    required this.reference,
    required this.designation,
    required this.categoryId,
    required this.brandId,
    required this.price,
    required this.tvaId,
  });

  factory ProductD.fromJson(Map<String, dynamic> json) {
    return ProductD(
      reference: json['reference'],
      designation: json['designation'],
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      price: json['price'].toDouble(),
      tvaId: json['tva_id'],
    );
  }
}
