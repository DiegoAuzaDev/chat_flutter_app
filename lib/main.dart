import 'package:chat_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: const Color.fromARGB(255, 38, 101, 137),
            secondary: const Color.fromARGB(255, 80, 96, 110),
            tertiary: const Color.fromARGB(255, 100, 89, 123),
            surface: const Color.fromARGB(255, 247, 249, 255),
          ),
        ),
        home: const AuthScreen());
  }
}
