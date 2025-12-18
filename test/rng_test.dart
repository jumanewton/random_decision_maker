import 'package:flutter_test/flutter_test.dart';
import 'dart:math';

void main() {
  group('RNG Logic Tests', () {
    test('Generated numbers stay within range [1, 100]', () {
      final min = 1;
      final max = 100;
      final random = Random();
      
      for (int i = 0; i < 1000; i++) {
        final result = min + random.nextInt(max - min + 1);
        expect(result, greaterThanOrEqualTo(min));
        expect(result, lessThanOrEqualTo(max));
      }
    });

    test('Generated numbers stay within range [50, 60]', () {
      final min = 50;
      final max = 60;
      final random = Random();
      
      for (int i = 0; i < 1000; i++) {
        final result = min + random.nextInt(max - min + 1);
        expect(result, greaterThanOrEqualTo(min));
        expect(result, lessThanOrEqualTo(max));
      }
    });

    test('Single value range [10, 10] always returns 10', () {
      final min = 10;
      final max = 10;
      final random = Random();
      
      // Note: nextInt(1) returns 0. So 10 + 0 = 10.
      for (int i = 0; i < 100; i++) {
        final result = min + random.nextInt(max - min + 1);
        expect(result, equals(10));
      }
    });
  });
}
