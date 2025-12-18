import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryItem {
  final String title;
  final String result;
  final DateTime timestamp;
  final String type; // 'coin', 'dice', 'decision', 'rng'

  HistoryItem({
    required this.title,
    required this.result,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'result': result,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
  };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
    title: json['title'],
    result: json['result'],
    timestamp: DateTime.parse(json['timestamp']),
    type: json['type'],
  );
}

class HistoryService {
  static const String _key = 'decision_history';
  static const int _maxItems = 20;

  Future<void> saveResult(HistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final List<HistoryItem> history = await getHistory();
    
    history.insert(0, item);
    if (history.length > _maxItems) {
      history.removeLast();
    }

    final String encoded = jsonEncode(history.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  Future<List<HistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_key);
    if (encoded == null) return [];

    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.map((e) => HistoryItem.fromJson(e)).toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
