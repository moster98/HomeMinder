class Property {
  final String id;
  final String name;
  final String address;
  final String town;
  final String postcode;

  Property({
    required this.id,
    required this.name,
    required this.address,
    required this.town,
    required this.postcode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'town': town,
      'postcode': postcode,
    };
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      town: json['town'],
      postcode: json['postcode'],
    );
  }
}