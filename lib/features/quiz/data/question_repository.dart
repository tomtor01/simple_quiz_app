import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model klasy pytania
class Question {
  final String text;
  final bool correctAnswer;

  Question({required this.text, required this.correctAnswer});
}

// Repozytorium pytań quizu
class QuestionRepository {
  // Symulacja danych zewnętrznych
  final List<Question> _questions = [
    Question(text: 'Czy Warszawa jest stolicą Polski?', correctAnswer: true),
    Question(text: 'Czy Berlin jest stolicą Francji?', correctAnswer: false),
    Question(text: 'Czy Londyn jest stolicą Wielkiej Brytanii?', correctAnswer: true),
    Question(text: 'Czy Madryt jest stolicą Hiszpanii?', correctAnswer: true),
    Question(text: 'Czy Rzym jest stolicą Grecji?', correctAnswer: false),
    Question(text: 'Czy Paryż jest stolicą Francji?', correctAnswer: true),
    Question(text: 'Czy Lizbona jest stolicą Portugalii?', correctAnswer: true),
    Question(text: 'Czy Wiedeń jest stolicą Niemiec?', correctAnswer: false),
    Question(text: 'Czy Oslo jest stolicą Norwegii?', correctAnswer: true),
    Question(text: 'Czy Berno jest stolicą Szwajcarii?', correctAnswer: true),
  ];

  // Metoda zwracająca wszystkie pytania
  List<Question> getAllQuestions() {
    return _questions;
  }
}

// Provider repozytorium pytań
final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepository();
});
