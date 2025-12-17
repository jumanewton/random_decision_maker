import 'package:flutter/material.dart';
import 'dart:math';

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

  void _flipCoin() {
    if (_isFlipping) return;
    setState(() {
      _isFlipping = true;
      // Determine result before flip starts, update visual at the end or halfway? 
      // Actually with simple rotation, visual update at end is jarring.
      // Better: Update state immediately, but the rotation makes it blur.
      // Simpler approach: Just spin, and when stopping, land on the result.
      // But 3D rotation requires Transform.
      _isHeads = Random().nextBool();
    });
    _controller.forward(from: 0);
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
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
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
     // If we are rotating, we might see the "back" of the widget which is mirrored.
     // But since we switch the widget content based on angle, we are simulating a solid object.
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFront ? Colors.amber : Colors.grey[300],
        border: Border.all(width: 8, color: isFront ? Colors.amber[700]! : Colors.grey[500]!),
        boxShadow: [
           BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0,5))
        ],
      ),
      child: Center(
        child: isFront 
          ? const Icon(Icons.monetization_on, size: 100, color: Colors.white)
          : const Icon(Icons.remove_circle_outline, size: 100, color: Colors.grey),
      ),
    );
  }
}
