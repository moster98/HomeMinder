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
      appBar: AppBar(
        title: const Text('🏡 HomeMinder'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.home_rounded, size: 80, color: Color(0xFF2E7D32)),
            const SizedBox(height: 16),
            const Text(
              'Welcome to HomeMinder',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Look after your home, all in one place.'),
            const SizedBox(height: 30),
            HomeButton(
              icon: Icons.house_rounded,
              label: 'My Properties',
              onTap: () => openProperties(context),
            ),
            HomeButton(icon: Icons.notifications, label: 'Reminders', onTap: () {}),
            HomeButton(icon: Icons.handyman, label: 'Jobs', onTap: () {}),
            HomeButton(icon: Icons.settings, label: 'Settings', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const HomeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1B5E20),
            padding: const EdgeInsets.all(18),
          ),
        ),
      ),
    );
  }
}