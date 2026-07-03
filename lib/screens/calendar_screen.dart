import 'package:flutter/material.dart';

import '../models/property.dart';
import '../models/reminder.dart';
import '../services/storage_service.dart';

class CalendarScreen extends StatefulWidget {
  final Property property;

  const CalendarScreen({
    super.key,
    required this.property,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<Reminder> reminders = [];

  String get storageKey => 'reminders_${widget.property.id}';

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  Future<void> loadReminders() async {
    final data = await StorageService.loadJson(storageKey);

    if (data == null) return;

    setState(() {
      reminders
        ..clear()
        ..addAll(
          (data as List).map((e) => Reminder.fromJson(e)).toList(),
        );

      reminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int daysUntil(DateTime date) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final dueOnly = DateTime(date.year, date.month, date.day);
    return dueOnly.difference(todayOnly).inDays;
  }

  String dueText(DateTime date) {
    final days = daysUntil(date);

    if (days < 0) return 'Overdue by ${days.abs()} day(s)';
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    return 'Due in $days days';
  }

  Color dueColor(DateTime date) {
    final days = daysUntil(date);

    if (days < 0) return Colors.red;
    if (days <= 7) return Colors.orange;
    return const Color(0xFF2E7D32);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: Text('📅 ${widget.property.name} Calendar'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: reminders.isEmpty
          ? const Center(
              child: Text(
                'No reminders yet.\nAdd reminders to see them here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: dueColor(reminder.dueDate),
                      foregroundColor: Colors.white,
                      child: Text(reminder.dueDate.day.toString()),
                    ),
                    title: Text(
                      reminder.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${formatDate(reminder.dueDate)}\n${dueText(reminder.dueDate)}',
                    ),
                    trailing: reminder.repeatYearly
                        ? const Icon(Icons.repeat, color: Color(0xFF2E7D32))
                        : const Icon(Icons.event),
                  ),
                );
              },
            ),
    );
  }
}