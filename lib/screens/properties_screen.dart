import 'package:flutter/material.dart';

import '../models/property.dart';
import '../services/storage_service.dart';
import 'add_property_screen.dart';
import 'property_screen.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  final List<Property> properties = [];

  static const String storageKey = 'properties';

  @override
  void initState() {
    super.initState();
    loadProperties();
  }

  Future<void> loadProperties() async {
    final data = await StorageService.loadJson(storageKey);

    if (data == null) {
      setState(() {
        properties.add(
          Property(
            id: '1',
            name: 'Home',
            address: '57 Peveril Bank',
            town: 'Dawley Bank, Telford',
            postcode: 'TF4 2BU',
          ),
        );
      });

      await saveProperties();
      return;
    }

    setState(() {
      properties
        ..clear()
        ..addAll(
          (data as List).map((e) => Property.fromJson(e)).toList(),
        );
    });
  }

  Future<void> saveProperties() async {
    await StorageService.saveJson(
      storageKey,
      properties.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> addProperty() async {
    final newProperty = await Navigator.push<Property>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddPropertyScreen(),
      ),
    );

    if (newProperty != null) {
      setState(() {
        properties.add(newProperty);
      });

      await saveProperties();
    }
  }

  void openProperty(Property selectedProperty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PropertyScreen(property: selectedProperty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: const Text('🏡 My Properties'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        onPressed: addProperty,
        icon: const Icon(Icons.add),
        label: const Text('Add Property'),
      ),
      body: properties.isEmpty
          ? const Center(
              child: Text(
                'No properties yet.\nTap Add Property to create one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final selectedProperty = properties[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE8F5E9),
                      child: Icon(
                        Icons.home,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    title: Text(
                      selectedProperty.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${selectedProperty.address}\n${selectedProperty.town}\n${selectedProperty.postcode}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => openProperty(selectedProperty),
                  ),
                );
              },
            ),
    );
  }
}