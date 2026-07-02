import 'package:flutter/material.dart';

import '../models/property.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final townController = TextEditingController();
  final postcodeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    townController.dispose();
    postcodeController.dispose();
    super.dispose();
  }

  void saveProperty() {
    final property = Property(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      address: addressController.text.trim(),
      town: townController.text.trim(),
      postcode: postcodeController.text.trim(),
    );

    Navigator.pop(context, property);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏡 Add Property'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Property name'),
          ),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(labelText: 'Address'),
          ),
          TextField(
            controller: townController,
            decoration: const InputDecoration(labelText: 'Town / Area'),
          ),
          TextField(
            controller: postcodeController,
            decoration: const InputDecoration(labelText: 'Postcode'),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: saveProperty,
            icon: const Icon(Icons.save),
            label: const Text('Save Property'),
          ),
        ],
      ),
    );
  }
}