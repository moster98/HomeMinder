class PhotoItem {
  final String id;
  final String propertyId;
  final String title;
  final String filePath;
  final DateTime createdAt;

  PhotoItem({
    required this.id,
    required this.propertyId,
    required this.title,
    required this.filePath,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'title': title,
      'filePath': filePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PhotoItem.fromJson(Map<String, dynamic> json) {
    return PhotoItem(
      id: json['id'],
      propertyId: json['propertyId'],
      title: json['title'],
      filePath: json['filePath'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}