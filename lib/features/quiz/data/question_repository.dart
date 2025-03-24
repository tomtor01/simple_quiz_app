import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model klasy pytania
class Question {
  final String text;
  final List<String> answers;
  final int correctAnswer;

  Question({required this.text, required this.answers, required this.correctAnswer});
}

// Repozytorium pytań quizu
class QuestionRepository {
  List<Question> _questions = [];

  Future<void> loadQuestions(String quizId) async {
    _questions = quizDatabase[quizId] ?? [];
  }
  // Metoda zwracająca wszystkie pytania
  List<Question> getAllQuestions() {
    return _questions;
  }
}

final Map<String, List<Question>> quizDatabase = {
  "quiz1": [
    Question(text: 'Czy Warszawa jest stolicą Polski?', answers: ['Tak' , 'Nie'], correctAnswer: 0),
    Question(text: 'Czy Berlin jest stolicą Francji?', answers: ['Tak' , 'Nie'], correctAnswer: 1),
    Question(text: 'Czy Londyn jest stolicą Wielkiej Brytanii?', answers: ['Tak' , 'Nie'], correctAnswer: 0),
    Question(text: 'Czy Madryt jest stolicą Hiszpanii?', answers: ['Tak' , 'Nie'], correctAnswer: 0),
    Question(text: 'Czy Rzym jest stolicą Grecji?', answers: ['Tak' , 'Nie'], correctAnswer: 1),
    Question(text: 'Czy Paryż jest stolicą Francji?', answers: ['Tak' , 'Nie'], correctAnswer: 0),
    Question(text: 'Czy Lizbona jest stolicą Portugalii?', answers: ['Tak' , 'Nie'], correctAnswer: 0),
    Question(text: 'Czy Wiedeń jest stolicą Niemiec?', answers: ['Tak' , 'Nie'], correctAnswer: 1),
    Question(text: 'Czy Oslo jest stolicą Norwegii?', answers: ['Tak' , 'Nie'], correctAnswer: 0),
    Question(text: 'Czy Berno jest stolicą Szwajcarii?', answers: ['Tak' , 'Nie'], correctAnswer: 0),
  ],
  "quiz2": [
    Question(text: 'Którą w kolejności planetą (licząc od Słońca) jest Jowisz?', answers: ['4', '5', '6'], correctAnswer: 1),
    Question(text: 'Ile jest gazowych olbrzymów w Układzie Słonecznym?', answers: ['4', '5', '6'], correctAnswer: 0),
    Question(text: 'Która planeta znajduje się bezpośrednio za Pasem Kuipera?', answers: ['Jowisz', 'Uran', 'Żadna'], correctAnswer: 2)
  ],
};

// Provider repozytorium pytań
final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepository();
});
