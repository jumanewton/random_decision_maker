import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../services/history_service.dart';

class RngScreen extends StatefulWidget {
  const RngScreen({super.key});

  @override
  State<RngScreen> createState() => _RngScreenState();
}

class _RngScreenState extends State<RngScreen> {
  final _minController = TextEditingController(text: '1');
  final _maxController = TextEditingController(text: '100');
  int? _result;
  bool _isGenerating = false;
  final HistoryService _historyService = HistoryService();

  void _generateNumber() async {
    final int? min = int.tryParse(_minController.text);
    final int? max = int.tryParse(_maxController.text);

    if (min == null || max == null || min >= max) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid range (min < max)')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _result = null;
    });

    // Haptic feedback start
    HapticFeedback.mediumImpact();

    // Visual animation of numbers
    for (int i = 0; i < 10; i++) {
      await Future.delayed(Duration(milliseconds: 50 + (i * 10)));
      if (!mounted) return;
      setState(() {
        _result = min + Random().nextInt(max - min + 1);
      });
    }

    final finalResult = min + Random().nextInt(max - min + 1);
    
    setState(() {
      _result = finalResult;
      _isGenerating = false;
    });

    // Save to history
    await _historyService.saveResult(HistoryItem(
      title: 'Random Number ($min - $max)',
      result: finalResult.toString(),
      timestamp: DateTime.now(),
      type: 'rng',
    ));

    // Haptic feedback end
    HapticFeedback.vibrate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Number')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    decoration: const InputDecoration(
                      labelText: 'Min',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    decoration: const InputDecoration(
                      labelText: 'Max',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _result?.toString() ?? '?',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generateNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _isGenerating ? 'GENERATING...' : 'GENERATE',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
