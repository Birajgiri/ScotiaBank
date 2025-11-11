import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const BankingApp());
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scotiabank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFEC0712),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEC0712),
          primary: const Color(0xFFEC0712),
          secondary: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFEC0712),
          foregroundColor: Colors.white,
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
