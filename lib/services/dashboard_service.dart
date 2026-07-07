import 'storage_service.dart';

class DashboardService {
  static Future<int> reminderCount(String propertyId) async {
    final data = await StorageService.loadJson('reminders_$propertyId');
    if (data == null) return 0;
    return (data as List).length;
  }

  static Future<int> jobCount(String propertyId) async {
    final data = await StorageService.loadJson('jobs_$propertyId');
    if (data == null) return 0;
    return (data as List).length;
  }

  static Future<int> photoCount(String propertyId) async {
    final data = await StorageService.loadJson('photos_$propertyId');
    if (data == null) return 0;
    return (data as List).length;
  }

  static Future<int> documentCount(String propertyId) async {
    final data = await StorageService.loadJson('documents_$propertyId');
    if (data == null) return 0;
    return (data as List).length;
  }

  static Future<double> totalSpent(String propertyId) async {
    final data = await StorageService.loadJson('costs_$propertyId');
    if (data == null) return 0;

    double total = 0;
    for (final item in data) {
      total += (item['amount'] as num).toDouble();
    }
    return total;
  }

  static Future<int> openJobs(String propertyId) async {
    final data = await StorageService.loadJson('jobs_$propertyId');
    if (data == null) return 0;

    return (data as List).where((item) => item['completed'] != true).length;
  }

  static Future<int> propertyHealth(String propertyId) async {
    final reminders = await reminderCount(propertyId);
    final open = await openJobs(propertyId);
    final photos = await photoCount(propertyId);
    final documents = await documentCount(propertyId);

    int score = 100;
    if (reminders > 5) score -= 10;
    if (open > 3) score -= 10;
    if (photos == 0) score -= 5;
    if (documents == 0) score -= 5;

    return score.clamp(50, 100);
  }

  static Future<List<String>> propertyIds() async {
    final properties = await StorageService.loadJson('properties');

    if (properties == null) return ['1'];

    final ids = (properties as List)
        .map((item) => item['id'].toString())
        .toList();

    return ids.isEmpty ? ['1'] : ids;
  }

  static Future<int> propertyCount() async {
    final ids = await propertyIds();
    return ids.length;
  }

  static Future<int> totalOpenJobs() async {
    final ids = await propertyIds();
    int total = 0;

    for (final id in ids) {
      total += await openJobs(id);
    }

    return total;
  }

  static Future<double> totalPortfolioSpent() async {
    final ids = await propertyIds();
    double total = 0;

    for (final id in ids) {
      total += await totalSpent(id);
    }

    return total;
  }

  static Future<int> totalPhotos() async {
    final ids = await propertyIds();
    int total = 0;

    for (final id in ids) {
      total += await photoCount(id);
    }

    return total;
  }

  static Future<int> totalDocuments() async {
    final ids = await propertyIds();
    int total = 0;

    for (final id in ids) {
      total += await documentCount(id);
    }

    return total;
  }

  static Future<int> totalReminders() async {
    final ids = await propertyIds();
    int total = 0;

    for (final id in ids) {
      total += await reminderCount(id);
    }

    return total;
  }

  static Future<int> averageHealth() async {
    final ids = await propertyIds();

    if (ids.isEmpty) return 100;

    int total = 0;

    for (final id in ids) {
      total += await propertyHealth(id);
    }

    return (total / ids.length).round();
  }

  static Future<int> totalStoredItems(String propertyId) async {
    final reminders = await reminderCount(propertyId);
    final jobs = await jobCount(propertyId);
    final photos = await photoCount(propertyId);
    final documents = await documentCount(propertyId);

    return reminders + jobs + photos + documents;
  }
}