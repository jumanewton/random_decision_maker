import 'package:flutter/material.dart';
import 'dart:math';

class DecisionMakerScreen extends StatefulWidget {
  const DecisionMakerScreen({super.key});

  @override
  State<DecisionMakerScreen> createState() => _DecisionMakerScreenState();
}

class _DecisionMakerScreenState extends State<DecisionMakerScreen> {
  final List<String> _options = [];
  final TextEditingController _textController = TextEditingController();
  String? _selectedOption;
  bool _isChoosing = false;

  void _addOption() {
    if (_textController.text.trim().isNotEmpty) {
      setState(() {
        _options.add(_textController.text.trim());
        _textController.clear();
        _selectedOption = null; // Reset selection if list changes
      });
    }
  }

  void _makeDecision() async {
    if (_options.isEmpty || _isChoosing) return;

    setState(() {
      _isChoosing = true;
      _selectedOption = null;
    });

    // Simulate a "thinking" process by cycling through options randomly
    int cycles = 10;
    for (int i = 0; i < cycles; i++) {
      await Future.delayed(Duration(milliseconds: 100 + (i * 20))); // Slow down
      if (!mounted) return;
      setState(() {
        _selectedOption = _options[Random().nextInt(_options.length)];
      });
    }

    setState(() {
      _isChoosing = false;
    });
    
    // Show a result dialog or snackbar? 
    // The visual highlighting is nice, but a dialog confirms it.
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('The decision is: $_selectedOption!'),
           backgroundColor: Colors.blueAccent,
           behavior: SnackBarBehavior.floating,
         )
       );
    }
  }

  void _removeOption(int index) {
    setState(() {
      _options.removeAt(index);
      _selectedOption = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choice Picker')),
      body: Column(
        children: [
          // Input Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter an option (e.g. Pizza)',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onSubmitted: (_) => _addOption(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addOption,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _options.isEmpty
                ? Center(
                    child: Text(
                      'Add options to make a decision!',
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _options.length,
                    itemBuilder: (context, index) {
                      final option = _options[index];
                      final isSelected = option == _selectedOption;
                      
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blueAccent : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected 
                            ? Border.all(color: Colors.blueAccent, width: 2)
                            : Border.all(color: Colors.transparent),
                           boxShadow: [
                             if (!isSelected) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: Offset(0,2))
                           ]
                        ),
                        child: ListTile(
                          title: Text(
                            option,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          trailing: isSelected 
                            ? const Icon(Icons.check_circle, color: Colors.white)
                            : IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                color: Colors.grey,
                                onPressed: _isChoosing ? null : () => _removeOption(index),
                              ),
                        ),
                      );
                    },
                  ),
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
               width: double.infinity,
               height: 56,
               child: ElevatedButton(
                 onPressed: (_options.length < 2 || _isChoosing) ? null : _makeDecision,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.blueAccent,
                   foregroundColor: Colors.white,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                   disabledBackgroundColor: Colors.grey[300],
                 ),
                 child: Text(
                   _isChoosing ? 'Deciding...' : 'MAKE DECISION', 
                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                 ),
               ),
            ),
          ),
        ],
      ),
    );
  }
}
