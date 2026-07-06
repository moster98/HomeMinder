import 'package:flutter/material.dart';

import '../models/job.dart';
import '../models/property.dart';
import '../services/storage_service.dart';
import '../services/timeline_service.dart';

class JobsScreen extends StatefulWidget {
  final Property property;

  const JobsScreen({
    super.key,
    required this.property,
  });

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final List<Job> jobs = [];

  String get storageKey => 'jobs_${widget.property.id}';

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  Future<void> loadJobs() async {
    final data = await StorageService.loadJson(storageKey);

    if (data == null) return;

    setState(() {
      jobs
        ..clear()
        ..addAll((data as List).map((e) => Job.fromJson(e)).toList());
    });
  }

  Future<void> saveJobs() async {
    await StorageService.saveJson(
      storageKey,
      jobs.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> addJob() async {
    final titleController = TextEditingController();
    final notesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Job'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Job title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty) return;

                final newJob = Job(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  propertyId: widget.property.id,
                  title: titleController.text.trim(),
                  notes: notesController.text.trim(),
                  createdAt: DateTime.now(),
                );

                setState(() {
                  jobs.add(newJob);
                });

                await saveJobs();

                await TimelineService.add(
                  propertyId: widget.property.id,
                  type: 'Job',
                  title: newJob.title,
                  subtitle: 'Job created',
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: Text('🛠 ${widget.property.name} Jobs'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addJob,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Job'),
      ),
      body: jobs.isEmpty
          ? const Center(
              child: Text(
                'No jobs yet.\nTap "Add Job" to create one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: CheckboxListTile(
                    value: job.completed,
                    activeColor: const Color(0xFF2E7D32),
                    title: Text(
                      job.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: job.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      '${job.notes.isEmpty ? "No notes" : job.notes}\nCreated: ${formatDate(job.createdAt)}',
                    ),
                    onChanged: (value) async {
                      final wasCompleted = job.completed;

                      setState(() {
                        job.completed = value ?? false;
                      });

                      await saveJobs();

                      if (!wasCompleted && job.completed) {
                        await TimelineService.add(
                          propertyId: widget.property.id,
                          type: 'Job',
                          title: job.title,
                          subtitle: 'Job completed',
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}