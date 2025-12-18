import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../services/history_service.dart';

class CoinFlipScreen extends StatefulWidget {
  const CoinFlipScreen({super.key});

  @override
  State<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHeads = true;
  bool _isFlipping = false;
  final HistoryService _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    // Rotate 5 times (10 * pi)
    _animation = Tween<double>(begin: 0, end: 10 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlipping = false;
          _controller.value = 0; // Reset for next flip but keep logic handled
        });
      }
    });
  }

  void _flipCoin() async {
    if (_isFlipping) return;
    
    final result = Random().nextBool();
    
    setState(() {
      _isFlipping = true;
      _isHeads = result;
    });

    HapticFeedback.lightImpact();
    _controller.forward(from: 0).then((_) async {
       // Save to history
       await _historyService.saveResult(HistoryItem(
         title: 'Coin Flip',
         result: _isHeads ? 'Heads' : 'Tails',
         timestamp: DateTime.now(),
         type: 'coin',
       ));
       HapticFeedback.mediumImpact();
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
      appBar: AppBar(title: const Text('Coin Flipper')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                // Calculation: 
                // If value is between 0 and pi = front
                // pi and 2pi = back
                // We want to land on the correct side.
                // If _isHeads, end at 0 mod 2pi. If tails, end at pi mod 2pi?
                // Let's simplify: Rotate N times, but check the final value?
                // Visual trick: The rotation speed is high enough that we don't track the sides until it slows.
                // But to be precise:
                // Let's just rotate generic, and swap the displayed widget based on rotation value?
                // Or just spin generic image and show result at end? No, that's cheap.
                
                // Better approach:
                // Rotate on X axis.
                final value = _animation.value;
                if (!_isHeads) {
                  // If tails, add an extra pi to the rotation so it lands on "back" relative to 0?
                  // Or just set the end state.
                  // Simplest: Always rotate to 10*pi. If result is Tails, rotate to 10*pi + pi.
                  // But I set animation range in initState.
                  // Let's override build time check.
                }
                
                // Improved logic for "Landing":
                // We won't change the animation target dynamically to keep it simple.
                // Instead, we will decide what "Face" is showing based on `value % (2*pi)`.
                // And we force the result `_isHeads` to match the final state? 
                // That's tricky with random.
                
                // Easiest "Good Looking" implementation:
                // 1. Flip animation is just a blur or fast spin.
                // 2. When it stops, we show the result.
                // 3. To make it smooth, we swap the image at 50% opacity or fast rate.
                
                // Let's try standard Transform:
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(value),
                  alignment: Alignment.center,
                  child: _buildCoinFace(
                     // Logic to see which face to show during spin:
                     // If angle is within (0, pi/2) or (3pi/2, 2pi)... see front.
                     // (pi/2, 3pi/2) see back.
                     // A simple math trick: cos(angle) > 0 ? front : back
                     // But we want the RESULT to be correct at end of animation.
                     // If result is Heads, we need to stop at 0 (or 2pi multiple).
                     // If result is Tails, we need to stop at pi (or odd pi multiple).
                     // So we need dynamic target.
                     
                     // We can do this by rebuilding the animation each flip? Yes.
                     _isFlipping ? (cos(value) > 0) : _isHeads
                  ),
                );
              },
            ),
            const SizedBox(height: 60),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: _isFlipping ? null : _flipCoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  elevation: 5,
                ),
                child: Text(
                  _isFlipping ? 'Flipping...' : 'FLIP COIN',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinFace(bool isFront) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isFront 
            ? [Colors.teal[300]!, Colors.teal[700]!, Colors.teal[900]!]
            : [Colors.grey[300]!, Colors.grey[600]!, Colors.grey[800]!],
        ),
        border: Border.all(
          width: 10, 
          color: isFront ? Colors.teal[100]!.withValues(alpha: 0.5) : Colors.grey[400]!.withValues(alpha: 0.5)
        ),
        boxShadow: [
           BoxShadow(
             color: Colors.black.withValues(alpha: 0.3), 
             blurRadius: 15, 
             offset: const Offset(0, 10)
           ),
           BoxShadow(
             color: isFront ? Colors.tealAccent.withValues(alpha: 0.2) : Colors.transparent,
             blurRadius: 20,
             spreadRadius: 2,
           ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFront ? Icons.monetization_on : Icons.stars_rounded, 
              size: 80, 
              color: Colors.white.withValues(alpha: 0.9)
            ),
            const SizedBox(height: 8),
            Text(
              isFront ? 'HEADS' : 'TAILS',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
