import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/coin_flip_screen.dart';
import 'screens/dice_roll_screen.dart';
import 'screens/decision_maker_screen.dart';

void main() {
  runApp(const RandomDecisionMakerApp());
}

class RandomDecisionMakerApp extends StatelessWidget {
  const RandomDecisionMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Decision Maker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/coin': (context) => const CoinFlipScreen(),
        '/dice': (context) => const DiceRollScreen(),
        '/decision': (context) => const DecisionMakerScreen(),
      },
    );
  }
}
