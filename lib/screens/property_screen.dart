import 'package:flutter/material.dart';

import '../models/property.dart';
import 'costs_screen.dart';
import 'documents_screen.dart';
import 'jobs_screen.dart';
import 'photos_screen.dart';
import 'reminders_screen.dart';

class PropertyScreen extends StatelessWidget {
  final Property property;

  const PropertyScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: Text('🏡 ${property.name}'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _headerCard(),
          const SizedBox(height: 16),
          _summaryCards(),
          const SizedBox(height: 22),
          _sectionTitle('Quick Actions'),
          _actionTile(
            icon: Icons.notifications_active,
            title: 'Reminders',
            subtitle: 'Boiler, roof, garden and service reminders',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RemindersScreen(property: property)),
            ),
          ),
          _actionTile(
            icon: Icons.handyman,
            title: 'Jobs',
            subtitle: 'Track maintenance jobs and repairs',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => JobsScreen(property: property)),
            ),
          ),
          _actionTile(
            icon: Icons.payments,
            title: 'Costs',
            subtitle: 'Track spending on this property',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CostsScreen(property: property)),
            ),
          ),
          _actionTile(
            icon: Icons.photo_library,
            title: 'Photos',
            subtitle: 'Before, after and progress photos',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PhotosScreen(property: property)),
            ),
          ),
          _actionTile(
            icon: Icons.description,
            title: 'Documents',
            subtitle: 'Warranties, manuals, certificates and receipts',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DocumentsScreen(property: property)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 34,
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.home_work_rounded, color: Color(0xFF2E7D32), size: 38),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(property.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  Text(property.address),
                  Text(property.town),
                  Text(property.postcode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCards() {
    return Row(
      children: const [
        Expanded(child: _MiniCard(icon: Icons.notifications, title: '1', subtitle: 'Reminder')),
        SizedBox(width: 10),
        Expanded(child: _MiniCard(icon: Icons.handyman, title: '0', subtitle: 'Jobs')),
        SizedBox(width: 10),
        Expanded(child: _MiniCard(icon: Icons.payments, title: '£0', subtitle: 'Spent')),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F5E9),
          child: Icon(icon, color: const Color(0xFF2E7D32)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MiniCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE8F5E9),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF2E7D32)),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}