import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const WalletTrackerApp());
}

class WalletTrackerApp extends StatelessWidget {
  const WalletTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}