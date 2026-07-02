import 'package:flutter/material.dart';

import '../models/cost.dart';
import '../models/property.dart';
import '../services/storage_service.dart';

class CostsScreen extends StatefulWidget {
  final Property property;

  const CostsScreen({
    super.key,
    required this.property,
  });

  @override
  State<CostsScreen> createState() => _CostsScreenState();
}

class _CostsScreenState extends State<CostsScreen> {
  final List<Cost> costs = [];

  String get storageKey => 'costs_${widget.property.id}';

  @override
  void initState() {
    super.initState();
    loadCosts();
  }

  Future<void> loadCosts() async {
    final data = await StorageService.loadJson(storageKey);

    if (data == null) return;

    setState(() {
      costs
        ..clear()
        ..addAll(
          (data as List).map((e) => Cost.fromJson(e)).toList(),
        );
    });
  }

  Future<void> saveCosts() async {
    await StorageService.saveJson(
      storageKey,
      costs.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> addCost() async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final notesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Cost"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  prefixText: "£ ",
                  labelText: "Amount",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Notes",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount =
                  double.tryParse(amountController.text) ?? 0;

              setState(() {
                costs.add(
                  Cost(
                    id: DateTime.now()
                        .millisecondsSinceEpoch
                        .toString(),
                    propertyId: widget.property.id,
                    title: titleController.text,
                    amount: amount,
                    notes: notesController.text,
                    date: DateTime.now(),
                  ),
                );
              });

              await saveCosts();

              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  double get totalSpent {
    return costs.fold(
      0,
      (sum, item) => sum + item.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: Text("💷 ${widget.property.name} Costs"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addCost,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Add Cost"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            color: const Color(0xFFE8F5E9),
            child: ListTile(
              leading: const Icon(
                Icons.account_balance_wallet,
                color: Color(0xFF2E7D32),
              ),
              title: const Text(
                "Total Spent",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "£${totalSpent.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: costs.isEmpty
                ? const Center(
                    child: Text(
                      "No costs recorded yet.",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: costs.length,
                    itemBuilder: (context, index) {
                      final cost = costs[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.payments,
                            color: Color(0xFF2E7D32),
                          ),
                          title: Text(cost.title),
                          subtitle: Text(cost.notes),
                          trailing: Text(
                            "£${cost.amount.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
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