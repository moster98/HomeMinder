import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/photo_item.dart';
import '../models/property.dart';
import '../services/storage_service.dart';
import 'photo_viewer_screen.dart';

class PhotosScreen extends StatefulWidget {
  final Property property;

  const PhotosScreen({
    super.key,
    required this.property,
  });

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  final ImagePicker picker = ImagePicker();
  final List<PhotoItem> photos = [];

  String get storageKey => 'photos_${widget.property.id}';

  @override
  void initState() {
    super.initState();
    loadPhotos();
  }

  Future<void> loadPhotos() async {
    final data = await StorageService.loadJson(storageKey);

    if (data == null) return;

    setState(() {
      photos
        ..clear()
        ..addAll((data as List).map((e) => PhotoItem.fromJson(e)).toList());
    });
  }

  Future<void> savePhotos() async {
    await StorageService.saveJson(
      storageKey,
      photos.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> addPhoto() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Photo Title'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                photos.add(
                  PhotoItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    propertyId: widget.property.id,
                    title: controller.text.isEmpty ? 'Untitled' : controller.text,
                    filePath: image.path,
                    createdAt: DateTime.now(),
                  ),
                );
              });

              await savePhotos();

              if (mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void openPhoto(PhotoItem photo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoViewerScreen(
          imagePath: photo.filePath,
          title: photo.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: Text('📷 ${widget.property.name} Photos'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addPhoto,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Add Photo'),
      ),
      body: photos.isEmpty
          ? const Center(
              child: Text(
                "No photos yet.\nTap 'Add Photo' to begin.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];

                return GestureDetector(
                  onTap: () => openPhoto(photo),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.file(
                            File(photo.filePath),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            photo.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}