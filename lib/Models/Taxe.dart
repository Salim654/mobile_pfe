class Taxe {
  final String wording;
  final String shortName;
  final double value;
  final int valueType;
  final int application;
  final int organizationId;
  final int id;

  Taxe({
    required this.wording,
    required this.shortName,
    required this.value,
    required this.valueType,
    required this.application,
    required this.organizationId,
    required this.id,
  });

  factory Taxe.fromJson(Map<String, dynamic> json) {
    return Taxe(
      wording: json['wording'],
      shortName: json['short_name'],
      value: json['value'].toDouble(),
      valueType: json['value_type'],
      application: json['application'],
      organizationId: json['organization_id'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wording': wording,
      'short_name': shortName,
      'value': value,
      'value_type': valueType,
      'application': application,
      'organization_id': organizationId,
      'id': id,
    };
  }
}
