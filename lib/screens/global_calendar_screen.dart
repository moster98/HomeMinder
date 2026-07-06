import 'package:flutter/material.dart';

class GlobalCalendarScreen extends StatelessWidget {
  const GlobalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F3),
      appBar: AppBar(
        title: const Text('📅 Calendar'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 70,
                    color: Color(0xFF2E7D32),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Global Calendar',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This screen will show every reminder from every property in one calendar.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _featureTile(
            Icons.notifications_active,
            'Upcoming Reminders',
          ),

          _featureTile(
            Icons.handyman,
            'Maintenance Jobs',
          ),

          _featureTile(
            Icons.payments,
            'Planned Costs',
          ),

          _featureTile(
            Icons.home,
            'Multiple Properties',
          ),

          _featureTile(
            Icons.calendar_view_month,
            'Monthly Calendar View',
          ),
        ],
      ),
    );
  }
}

class _featureTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _featureTile(
    this.icon,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F5E9),
          child: Icon(
            icon,
            color: const Color(0xFF2E7D32),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}