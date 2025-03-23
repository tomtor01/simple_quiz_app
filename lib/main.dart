import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/presentation/home_page.dart';

void main() {
  runApp(
    // Dodajemy ProviderScope, aby umożliwić korzystanie z Riverpod w całej aplikacji
    const ProviderScope(child: QuizApp()),
  );
}

// Klasa główna aplikacji
class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      // Używamy strony startowej, która pozwala na wybór demonstracji
      home: const HomePage(),
    );
  }
}
