import 'storage_service.dart';

class DashboardService {
  static Future<int> reminderCount(String propertyId) async {
    final data =
        await StorageService.loadJson('reminders_$propertyId');

    if (data == null) return 0;

    return (data as List).length;
  }

  static Future<int> jobCount(String propertyId) async {
    final data =
        await StorageService.loadJson('jobs_$propertyId');

    if (data == null) return 0;

    return (data as List).length;
  }

  static Future<int> photoCount(String propertyId) async {
    final data =
        await StorageService.loadJson('photos_$propertyId');

    if (data == null) return 0;

    return (data as List).length;
  }

  static Future<int> documentCount(String propertyId) async {
    final data =
        await StorageService.loadJson('documents_$propertyId');

    if (data == null) return 0;

    return (data as List).length;
  }

  static Future<double> totalSpent(String propertyId) async {
    final data =
        await StorageService.loadJson('costs_$propertyId');

    if (data == null) return 0;

    double total = 0;

    for (final item in data) {
      total += (item['amount'] as num).toDouble();
    }

    return total;
  }
}