class Reminder {
  final String id;
  final String propertyId;
  final String title;
  final DateTime dueDate;
  final bool repeatYearly;
  final String notes;
  bool completed;

  Reminder({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.dueDate,
    required this.repeatYearly,
    required this.notes,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'repeatYearly': repeatYearly,
      'notes': notes,
      'completed': completed,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      propertyId: json['propertyId'],
      title: json['title'],
      dueDate: DateTime.parse(json['dueDate']),
      repeatYearly: json['repeatYearly'],
      notes: json['notes'],
      completed: json['completed'] ?? false,
    );
  }
}