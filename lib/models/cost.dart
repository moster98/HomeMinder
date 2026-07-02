class Cost {
  final String id;
  final String propertyId;
  final String title;
  final double amount;
  final String notes;
  final DateTime date;

  Cost({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.amount,
    required this.notes,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'title': title,
      'amount': amount,
      'notes': notes,
      'date': date.toIso8601String(),
    };
  }

  factory Cost.fromJson(Map<String, dynamic> json) {
    return Cost(
      id: json['id'],
      propertyId: json['propertyId'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      notes: json['notes'],
      date: DateTime.parse(json['date']),
    );
  }
}