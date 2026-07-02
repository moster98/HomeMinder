import 'package:flutter/material.dart';
import '../models/property.dart';
import '../models/reminder.dart';

class AddReminderScreen extends StatefulWidget {
  final Property property;

  const AddReminderScreen({
    super.key,
    required this.property,
  });

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final notesController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool repeatYearly = false;

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void saveReminder() {
    if (!_formKey.currentState!.validate()) return;

    final reminder = Reminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      propertyId: widget.property.id,
      title: titleController.text.trim(),
      dueDate: selectedDate,
      repeatYearly: repeatYearly,
      notes: notesController.text.trim(),
    );

    Navigator.pop(context, reminder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🔔 Add Reminder"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                widget.property.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Reminder Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? "Enter a reminder title"
                        : null,
              ),

              const SizedBox(height: 15),

              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text("Due Date"),
                subtitle: Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                ),
                trailing: ElevatedButton(
                  onPressed: pickDate,
                  child: const Text("Change"),
                ),
              ),

              SwitchListTile(
                title: const Text("Repeat Every Year"),
                value: repeatYearly,
                onChanged: (value) {
                  setState(() {
                    repeatYearly = value;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Notes",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: saveReminder,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Save Reminder",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}