import 'package:flutter/material.dart';

import 'LoginScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(primary: Colors.green),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
      ),
      home: const LoginScreen(),
    );
  }
}