// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:random_decision_maker/main.dart';

void main() {
  testWidgets('Home Screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RandomDecisionMakerApp());
    await tester.pumpAndSettle();

    // Verify that the title is present (using textContaining for robustness)
    expect(find.textContaining('Random Decisions'), findsOneWidget);

    // Verify that menu items are present
    expect(find.text('Coin Flipper'), findsOneWidget);
    expect(find.text('Dice Roller'), findsOneWidget);
    expect(find.text('Choice Picker'), findsOneWidget);
    expect(find.text('Random Number'), findsOneWidget);

    // Verify that the history button is present
    expect(find.byIcon(Icons.history_rounded), findsOneWidget);
  });
}
