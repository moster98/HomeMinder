import 'package:flutter/material.dart';
import 'properties_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void openProperties(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PropertiesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F3),
      appBar: AppBar(
        title: const Text('🏡 HomeMinder'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.home_rounded, size: 70, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Welcome to HomeMinder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your home, organised and protected.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Quick Access',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          HomeButton(
            icon: Icons.house_rounded,
            label: 'My Properties',
            subtitle: 'Manage homes, reminders, jobs and documents',
            onTap: () => openProperties(context),
          ),

          HomeButton(
            icon: Icons.calendar_month,
            label: 'Calendar',
            subtitle: 'View upcoming property reminders',
            onTap: () {},
          ),

          HomeButton(
            icon: Icons.health_and_safety,
            label: 'Home Health',
            subtitle: 'See what needs attention',
            onTap: () {},
          ),

          HomeButton(
            icon: Icons.settings,
            label: 'Settings',
            subtitle: 'App preferences and account options',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const HomeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F5E9),
          child: Icon(icon, color: const Color(0xFF2E7D32)),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}