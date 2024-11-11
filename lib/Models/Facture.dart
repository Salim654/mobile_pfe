class Facture {
  final int id;
  final String reference;
  final String date;
  final String dueDate;
  final double? discount;
  final int clientId;
  final int? taxeId;
  final int type;

  Facture({
    required this.id,
    required this.reference,
    required this.date,
    required this.dueDate,
    this.discount,
    required this.clientId,
    this.taxeId,
    required this.type,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      id: json['id'],
      reference: json['reference'],
      date: json['date'],
      dueDate: json['due_date'],
      discount: json['discount']?.toDouble(),
      clientId: json['client_id'],
      taxeId: json['taxe_id'],
      type: json['type'],
    );
  }
}
