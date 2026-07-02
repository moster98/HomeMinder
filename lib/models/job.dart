class Job {
  final String id;
  final String propertyId;
  final String title;
  final String notes;
  final DateTime createdAt;
  bool completed;

  Job({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.notes,
    required this.createdAt,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'title': title,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'completed': completed,
    };
  }

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      propertyId: json['propertyId'],
      title: json['title'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      completed: json['completed'] ?? false,
    );
  }
}