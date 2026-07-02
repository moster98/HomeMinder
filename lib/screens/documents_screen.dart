import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/document_item.dart';
import '../models/property.dart';
import '../services/storage_service.dart';

class DocumentsScreen extends StatefulWidget {
  final Property property;

  const DocumentsScreen({
    super.key,
    required this.property,
  });

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final List<DocumentItem> documents = [];

  String get storageKey => 'documents_${widget.property.id}';

  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    final data = await StorageService.loadJson(storageKey);

    if (data == null) return;

    setState(() {
      documents
        ..clear()
        ..addAll(
          (data as List)
              .map((e) => DocumentItem.fromJson(e))
              .toList(),
        );
    });
  }

  Future<void> saveDocuments() async {
    await StorageService.saveJson(
      storageKey,
      documents.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> addDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Document Title"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Title",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                documents.add(
                  DocumentItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    propertyId: widget.property.id,
                    title: controller.text.isEmpty
                        ? result.files.single.name
                        : controller.text,
                    filePath: result.files.single.path!,
                    createdAt: DateTime.now(),
                  ),
                );
              });

              await saveDocuments();

              if (mounted) Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: Text("📄 ${widget.property.name} Documents"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addDocument,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file),
        label: const Text("Add Document"),
      ),
      body: documents.isEmpty
          ? const Center(
              child: Text(
                "No documents yet.\nTap 'Add Document' to begin.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: Color(0xFF2E7D32),
                    ),
                    title: Text(document.title),
                    subtitle: Text(
                      File(document.filePath).uri.pathSegments.last,
                    ),
                  ),
                );
              },
            ),
    );
  }
}