import '../models/timeline_item.dart';
import 'storage_service.dart';

class TimelineService {
  static Future<void> add({
    required String propertyId,
    required String type,
    required String title,
    required String subtitle,
  }) async {
    final key = 'timeline_$propertyId';

    final data = await StorageService.loadJson(key);

    List<TimelineItem> items = [];

    if (data != null) {
      items = (data as List)
          .map((e) => TimelineItem.fromJson(e))
          .toList();
    }

    items.add(
      TimelineItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        propertyId: propertyId,
        type: type,
        title: title,
        subtitle: subtitle,
        createdAt: DateTime.now(),
      ),
    );

    await StorageService.saveJson(
      key,
      items.map((e) => e.toJson()).toList(),
    );
  }

  static Future<List<TimelineItem>> getTimeline(
    String propertyId,
  ) async {
    final key = 'timeline_$propertyId';

    final data = await StorageService.loadJson(key);

    if (data == null) {
      return [];
    }

    final items = (data as List)
        .map((e) => TimelineItem.fromJson(e))
        .toList();

    items.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    return items;
  }

  static Future<List<TimelineItem>> recent(
    String propertyId, {
    int limit = 5,
  }) async {
    final items = await getTimeline(propertyId);

    if (items.length <= limit) {
      return items;
    }

    return items.take(limit).toList();
  }
}