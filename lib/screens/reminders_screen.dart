import 'package:flutter/material.dart';

import '../models/property.dart';
import '../models/reminder.dart';
import '../services/storage_service.dart';
import 'add_reminder_screen.dart';

class RemindersScreen extends StatefulWidget {
  final Property property;

  const RemindersScreen({
    super.key,
    required this.property,
  });

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
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
    });
  }

  Future<void> saveReminders() async {
    await StorageService.saveJson(
      storageKey,
      reminders.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> addReminder() async {
    final reminder = await Navigator.push<Reminder>(
      context,
      MaterialPageRoute(
        builder: (_) => AddReminderScreen(property: widget.property),
      ),
    );

    if (reminder != null) {
      setState(() {
        reminders.add(reminder);
      });

      await saveReminders();
    }
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    reminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Scaffold(
      appBar: AppBar(
        title: Text('🔔 ${widget.property.name}'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addReminder,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Reminder'),
      ),
      body: reminders.isEmpty
          ? const Center(
              child: Text(
                "No reminders yet.\nTap 'Add Reminder' to create one.",
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
                    leading: const Icon(
                      Icons.notifications_active,
                      color: Color(0xFF2E7D32),
                    ),
                    title: Text(reminder.title),
                    subtitle: Text(
                      'Due: ${formatDate(reminder.dueDate)}'
                      '${reminder.repeatYearly ? "\nRepeats every year" : ""}',
                    ),
                    trailing: reminder.completed
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.schedule),
                  ),
                );
              },
            ),
    );
  }
}