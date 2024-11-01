import 'package:cahatbot/consts.dart';
import 'package:cahatbot/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );
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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 16, 17, 59)),
        useMaterial3: true,
      ),
      home: const Homepage(),
    );
  }
}
