import 'package:flutter/material.dart';

import '../services/dashboard_service.dart';
import '../theme/app_theme.dart';
import '../widgets/action_tile.dart';
import '../widgets/stat_card.dart';
import 'properties_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int propertyCount = 0;
  int health = 100;
  int openJobs = 0;
  double totalSpent = 0;
  int reminders = 0;
  int photos = 0;
  int documents = 0;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final loadedProperties = await DashboardService.propertyCount();
    final loadedHealth = await DashboardService.averageHealth();
    final loadedOpenJobs = await DashboardService.totalOpenJobs();
    final loadedSpent = await DashboardService.totalPortfolioSpent();
    final loadedReminders = await DashboardService.totalReminders();
    final loadedPhotos = await DashboardService.totalPhotos();
    final loadedDocuments = await DashboardService.totalDocuments();

    setState(() {
      propertyCount = loadedProperties;
      health = loadedHealth;
      openJobs = loadedOpenJobs;
      totalSpent = loadedSpent;
      reminders = loadedReminders;
      photos = loadedPhotos;
      documents = loadedDocuments;
    });
  }

  void openProperties(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PropertiesScreen()),
    ).then((_) => loadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 18
            ? 'Good Afternoon'
            : 'Good Evening';

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: loadDashboard,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 10),
            Text(
              '$greeting, James 👋',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Here’s your live portfolio overview.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.house,
                    title: propertyCount.toString(),
                    subtitle: propertyCount == 1 ? 'Property' : 'Properties',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    icon: Icons.health_and_safety,
                    title: '$health%',
                    subtitle: 'Avg Health',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.handyman,
                    title: openJobs.toString(),
                    subtitle: 'Open Jobs',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    icon: Icons.payments,
                    title: '£${totalSpent.toStringAsFixed(0)}',
                    subtitle: 'Total Spent',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.notifications,
                    title: reminders.toString(),
                    subtitle: 'Reminders',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    icon: Icons.photo_library,
                    title: photos.toString(),
                    subtitle: 'Photos',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.description,
                    title: documents.toString(),
                    subtitle: 'Documents',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    icon: Icons.dashboard_customize,
                    title: 'Live',
                    subtitle: 'Portfolio',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ActionTile(
              icon: Icons.house_rounded,
              title: 'My Properties',
              subtitle: 'Open your homes, dashboards and tools',
              onTap: () => openProperties(context),
            ),
            ActionTile(
              icon: Icons.calendar_month,
              title: 'Calendar',
              subtitle: 'See upcoming property reminders',
              onTap: () {},
            ),
            ActionTile(
              icon: Icons.timeline,
              title: 'Recent Activity',
              subtitle: 'Track jobs, costs, documents and photos',
              onTap: () {},
            ),
            ActionTile(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'Notifications, backups and preferences',
              onTap: () {},
            ),

            const SizedBox(height: 26),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: AppTheme.lightGreen,
                      child: Icon(
                        Icons.auto_awesome,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Across $propertyCount property, you have $documents documents, $photos photos and £${totalSpent.toStringAsFixed(0)} recorded.',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}