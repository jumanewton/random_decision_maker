import 'package:flutter/material.dart';
import 'dart:math';

class DiceRollScreen extends StatefulWidget {
  const DiceRollScreen({super.key});

  @override
  State<DiceRollScreen> createState() => _DiceRollScreenState();
}

class _DiceRollScreenState extends State<DiceRollScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentValue = 1;
  bool _isRolling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _controller.addListener(() {
      // Rapidly change numbers while "rolling" to give effect
      if (_controller.isAnimating) {
         setState(() {
           _currentValue = Random().nextInt(6) + 1;
         });
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isRolling = false;
        });
      }
    });
  }

  void _rollDice() {
    if (_isRolling) return;
    setState(() {
      _isRolling = true;
    });
    // Spin animation or shake?
    // Let's just run the controller forward and back to loop a bit? No, just forward.
    _controller.forward(from: 0).then((_) {
       // Final legitimate roll
       setState(() {
         _currentValue = Random().nextInt(6) + 1;
       });
    });
  }

   @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dice Roller')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dice Container
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 10)),
                ],
                border: Border.all(color: Colors.grey[200]!, width: 2),
              ),
              child: Center(
                child: _getDiceIcon(_currentValue),
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton.icon(
                onPressed: _isRolling ? null : _rollDice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.casino),
                label: Text(
                  _isRolling ? 'Rolling...' : 'ROLL DICE',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDiceIcon(int value) {
    // Flutter has looks_one, looks_two etc symbols but they are rounded square icons.
    // They look decent for a dice face.
    // Flutter has looks_one, looks_two etc symbols but they are rounded square icons.
    // They look decent for a dice face.
    
    // Actually the naming is looks_one, looks_two... looks_3 is not correct, it's looks_3.
    // Let's double check standard names.
    // Icons.looks_one, Icons.looks_two... Icons.looks_6.
    
    return Icon(
       _getIconData(value),
       size: 100,
       color: Colors.redAccent,
    );
  }

  IconData _getIconData(int value) {
     switch (value) {
      case 1: return Icons.looks_one_rounded;
      case 2: return Icons.looks_two_rounded;
      case 3: return Icons.looks_3_rounded;
      case 4: return Icons.looks_4_rounded;
      case 5: return Icons.looks_5_rounded;
      case 6: return Icons.looks_6_rounded;
      default: return Icons.error;
    } 
  }
}
