class FactureProduct {
  final int id;
  final int quantity;
  final double discount;
  final int productId;
  final int factureId;
  final int? taxeId;
  final String productName;
  final double? taxValue;
  final int? taxValueType;
  final double? unitprice;
  final String? taxeshorname;

  FactureProduct({
    required this.id,
    required this.quantity,
    required this.discount,
    required this.productId,
    required this.factureId,
    this.taxeId,
    this.unitprice,
    this.taxeshorname,
    required this.productName,
    this.taxValue,
    this.taxValueType,
  });

  factory FactureProduct.fromJson(Map<String, dynamic> json) {
    return FactureProduct(
      id: json['id'],
      quantity: json['quantity'],
      discount: json['discount'].toDouble(),
      productId: json['product_id'],
      factureId: json['factures_id'],
      taxeId: json['taxe_id'],
      productName: json['product_name'],
      taxValue: json['tax_value']?.toDouble(),
      unitprice: json['unit_price']?.toDouble(),
      taxeshorname: json['tax_shortname'],
      taxValueType: json['tax_value_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'discount': discount,
      'product_id': productId,
      'factures_id': factureId,
      'taxe_id': taxeId,
      'product_name': productName,
      'tax_value': taxValue,
      'tax_value_type': taxValueType,
    };
  }
}
