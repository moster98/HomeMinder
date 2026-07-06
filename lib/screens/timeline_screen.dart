import 'package:flutter/material.dart';

import '../models/property.dart';
import '../models/timeline_item.dart';
import '../services/storage_service.dart';

class TimelineScreen extends StatefulWidget {
  final Property property;

  const TimelineScreen({
    super.key,
    required this.property,
  });

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final List<TimelineItem> timeline = [];

  String get storageKey => 'timeline_${widget.property.id}';

  @override
  void initState() {
    super.initState();
    loadTimeline();
  }

  Future<void> loadTimeline() async {
    final data = await StorageService.loadJson(storageKey);

    if (data == null) return;

    setState(() {
      timeline
        ..clear()
        ..addAll(
          (data as List)
              .map((e) => TimelineItem.fromJson(e))
              .toList(),
        );

      timeline.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
    });
  }

  IconData iconForType(String type) {
    switch (type) {
      case 'Reminder':
        return Icons.notifications_active;
      case 'Job':
        return Icons.handyman;
      case 'Cost':
        return Icons.payments;
      case 'Photo':
        return Icons.photo_library;
      case 'Document':
        return Icons.description;
      default:
        return Icons.history;
    }
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F3),
      appBar: AppBar(
        title: Text('📈 ${widget.property.name} Timeline'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: timeline.isEmpty
          ? const Center(
              child: Text(
                'No activity yet.\nAs you use HomeMinder, activity will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: timeline.length,
              itemBuilder: (context, index) {
                final item = timeline[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE8F5E9),
                      child: Icon(
                        iconForType(item.type),
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${item.subtitle}\n${formatDate(item.createdAt)}',
                    ),
                    trailing: Text(item.type),
                  ),
                );
              },
            ),
    );
  }
}