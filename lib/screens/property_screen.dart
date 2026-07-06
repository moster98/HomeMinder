import 'package:flutter/material.dart';

import '../models/property.dart';
import '../models/timeline_item.dart';
import '../services/dashboard_service.dart';
import '../services/timeline_service.dart';
import 'calendar_screen.dart';
import 'costs_screen.dart';
import 'documents_screen.dart';
import 'jobs_screen.dart';
import 'photos_screen.dart';
import 'reminders_screen.dart';
import 'timeline_screen.dart';

class PropertyScreen extends StatefulWidget {
  final Property property;

  const PropertyScreen({
    super.key,
    required this.property,
  });

  @override
  State<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  int reminders = 0;
  int jobs = 0;
  int photos = 0;
  int documents = 0;
  double spent = 0;
  List<TimelineItem> recentActivity = [];

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final reminderCount =
        await DashboardService.reminderCount(widget.property.id);
    final jobCount = await DashboardService.jobCount(widget.property.id);
    final photoCount = await DashboardService.photoCount(widget.property.id);
    final documentCount =
        await DashboardService.documentCount(widget.property.id);
    final totalSpent = await DashboardService.totalSpent(widget.property.id);
    final recent = await TimelineService.recent(widget.property.id);

    setState(() {
      reminders = reminderCount;
      jobs = jobCount;
      photos = photoCount;
      documents = documentCount;
      spent = totalSpent;
      recentActivity = recent;
    });
  }

  Future<void> openPage(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );

    await loadDashboard();
  }

  int get healthScore {
    int score = 100;

    if (reminders > 5) score -= 10;
    if (jobs > 3) score -= 10;
    if (documents == 0) score -= 5;
    if (photos == 0) score -= 5;

    return score.clamp(50, 100);
  }@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F3),
      appBar: AppBar(
        title: Text('🏡 ${widget.property.name}'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: loadDashboard,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _heroCard(),
            const SizedBox(height: 16),
            _healthCard(),
            const SizedBox(height: 16),
            _statsGrid(),
            const SizedBox(height: 22),
            _sectionTitle('Quick Actions'),
            _quickActions(),
            const SizedBox(height: 22),
            _sectionTitle('Recent Activity'),
            _recentActivityCard(),
            const SizedBox(height: 22),
            _sectionTitle('Property Tools'),
            _toolTile(
              icon: Icons.notifications_active,
              title: 'Reminders',
              subtitle: '$reminders saved reminders',
              onTap: () => openPage(RemindersScreen(property: widget.property)),
            ),
            _toolTile(
              icon: Icons.calendar_month,
              title: 'Calendar',
              subtitle: 'See upcoming reminders by date',
              onTap: () => openPage(CalendarScreen(property: widget.property)),
            ),
            _toolTile(
              icon: Icons.timeline,
              title: 'Timeline',
              subtitle: 'See property activity history',
              onTap: () => openPage(TimelineScreen(property: widget.property)),
            ),
            _toolTile(
              icon: Icons.handyman,
              title: 'Jobs',
              subtitle: '$jobs jobs recorded',
              onTap: () => openPage(JobsScreen(property: widget.property)),
            ),
            _toolTile(
              icon: Icons.payments,
              title: 'Costs',
              subtitle: '£${spent.toStringAsFixed(2)} total spending',
              onTap: () => openPage(CostsScreen(property: widget.property)),
            ),
            _toolTile(
              icon: Icons.photo_library,
              title: 'Photos',
              subtitle: '$photos property photos',
              onTap: () => openPage(PhotosScreen(property: widget.property)),
            ),
            _toolTile(
              icon: Icons.description,
              title: 'Documents',
              subtitle: '$documents saved documents',
              onTap: () => openPage(DocumentsScreen(property: widget.property)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF66BB6A),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 8),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.home_work_rounded,
              color: Color(0xFF2E7D32),
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.property.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.property.address,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  widget.property.town,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  widget.property.postcode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _healthCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: const Color(0xFFE8F5E9),
              child: Text(
                '$healthScore%',
                style: const TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Property Health',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Based on reminders, jobs, photos and documents.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }Widget _statsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _statCard(Icons.notifications, reminders.toString(), 'Reminders'),
        _statCard(Icons.handyman, jobs.toString(), 'Jobs'),
        _statCard(Icons.photo_library, photos.toString(), 'Photos'),
        _statCard(Icons.description, documents.toString(), 'Documents'),
        _statCard(Icons.payments, '£${spent.toStringAsFixed(0)}', 'Spent'),
        _statCard(Icons.timeline, 'View', 'Timeline'),
      ],
    );
  }

  Widget _statCard(IconData icon, String number, String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF2E7D32)),
            const SizedBox(height: 8),
            Text(
              number,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: _quickButton(
            Icons.notifications_active,
            'Reminder',
            () => openPage(RemindersScreen(property: widget.property)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickButton(
            Icons.handyman,
            'Job',
            () => openPage(JobsScreen(property: widget.property)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickButton(
            Icons.add_a_photo,
            'Photo',
            () => openPage(PhotosScreen(property: widget.property)),
          ),
        ),
      ],
    );
  }

  Widget _quickButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF2E7D32)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _recentActivityCard() {
    if (recentActivity.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text('No recent activity yet.', style: TextStyle(fontSize: 16)),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: recentActivity.map((item) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE8F5E9),
              child: Icon(
                _iconForType(item.type),
                color: const Color(0xFF2E7D32),
              ),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(item.subtitle),
          );
        }).toList(),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'Job':
        return Icons.handyman;
      case 'Cost':
        return Icons.payments;
      case 'Reminder':
        return Icons.notifications_active;
      case 'Photo':
        return Icons.photo_library;
      case 'Document':
        return Icons.description;
      default:
        return Icons.history;
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _toolTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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