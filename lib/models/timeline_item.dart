class TimelineItem {
  final String id;
  final String propertyId;
  final String type;
  final String title;
  final String subtitle;
  final DateTime createdAt;

  TimelineItem({
    required this.id,
    required this.propertyId,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      id: json['id'],
      propertyId: json['propertyId'],
      type: json['type'],
      title: json['title'],
      subtitle: json['subtitle'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}