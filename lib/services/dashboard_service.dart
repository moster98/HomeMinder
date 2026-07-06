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

    return (data as List)
        .where((item) => item['completed'] != true)
        .length;
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

  static Future<int> totalStoredItems(String propertyId) async {
    final reminders = await reminderCount(propertyId);
    final jobs = await jobCount(propertyId);
    final photos = await photoCount(propertyId);
    final documents = await documentCount(propertyId);

    return reminders + jobs + photos + documents;
  }
}