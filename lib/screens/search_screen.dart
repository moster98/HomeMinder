import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class SearchResult {
  final String type;
  final String title;
  final String subtitle;
  final IconData icon;

  SearchResult({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List<SearchResult> allResults = [];
  List<SearchResult> filteredResults = [];

  @override
  void initState() {
    super.initState();
    loadSearchData();
  }

  Future<void> loadSearchData() async {
    final keys = await StorageService.getKeys();
    final List<SearchResult> results = [];

    for (final key in keys) {
      final data = await StorageService.loadJson(key);

      if (data is! List) continue;

      for (final item in data) {
        if (item is! Map) continue;

        if (key.startsWith('reminders_')) {
          results.add(
            SearchResult(
              type: 'Reminder',
              title: item['title'] ?? 'Untitled reminder',
              subtitle: 'Property reminder',
              icon: Icons.notifications_active,
            ),
          );
        }

        if (key.startsWith('jobs_')) {
          results.add(
            SearchResult(
              type: 'Job',
              title: item['title'] ?? 'Untitled job',
              subtitle: item['notes'] ?? 'Maintenance job',
              icon: Icons.handyman,
            ),
          );
        }

        if (key.startsWith('costs_')) {
          results.add(
            SearchResult(
              type: 'Cost',
              title: item['title'] ?? 'Untitled cost',
              subtitle: '£${item['amount'] ?? 0}',
              icon: Icons.payments,
            ),
          );
        }

        if (key.startsWith('photos_')) {
          results.add(
            SearchResult(
              type: 'Photo',
              title: item['title'] ?? 'Untitled photo',
              subtitle: 'Saved property photo',
              icon: Icons.photo_library,
            ),
          );
        }

        if (key.startsWith('documents_')) {
          results.add(
            SearchResult(
              type: 'Document',
              title: item['title'] ?? 'Untitled document',
              subtitle: 'Saved property document',
              icon: Icons.description,
            ),
          );
        }
      }
    }

    setState(() {
      allResults = results;
      filteredResults = results;
    });
  }

  void filterSearch(String value) {
    final query = value.toLowerCase();

    setState(() {
      filteredResults = allResults.where((result) {
        return result.title.toLowerCase().contains(query) ||
            result.subtitle.toLowerCase().contains(query) ||
            result.type.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F3),
      appBar: AppBar(
        title: const Text('🔍 Search'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: InputDecoration(
                hintText: 'Search reminders, jobs, costs, photos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: loadSearchData,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredResults.isEmpty
                ? const Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      final result = filteredResults[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFE8F5E9),
                            child: Icon(
                              result.icon,
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                          title: Text(
                            result.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('${result.type} • ${result.subtitle}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}