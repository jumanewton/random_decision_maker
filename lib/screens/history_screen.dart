import 'package:flutter/material.dart';
import '../services/history_service.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  late Future<List<HistoryItem>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _historyService.getHistory();
  }

  void _clearHistory() async {
    await _historyService.clearHistory();
    setState(() {
      _historyFuture = _historyService.getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _clearHistory,
          ),
        ],
      ),
      body: FutureBuilder<List<HistoryItem>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.history_toggle_off_rounded, size: 64, color: Colors.grey[400]),
                   const SizedBox(height: 16),
                   Text('No history yet', style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                ],
              ),
            );
          }

          final history = snapshot.data!;
          return ListView.builder(
            itemCount: history.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                leading: _getLeadingIcon(item.type),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(DateFormat('MMM d, HH:mm').format(item.timestamp)),
                trailing: Text(
                  item.result,
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getLeadingIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'coin':
        icon = Icons.monetization_on_rounded;
        color = Colors.amber;
        break;
      case 'dice':
        icon = Icons.casino_rounded;
        color = Colors.redAccent;
        break;
      case 'decision':
        icon = Icons.checklist_rounded;
        color = Colors.blueAccent;
        break;
      case 'rng':
        icon = Icons.pin_outlined;
        color = Colors.purpleAccent;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
