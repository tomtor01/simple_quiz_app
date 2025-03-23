import 'package:flutter_riverpod/flutter_riverpod.dart';

class Quiz {
  final String id;
  final String title;
  final String description;

  Quiz({required this.id, required this.title, required this.description});
}

final List<Quiz> quizzes = [
  Quiz(id: "quiz1", title: "Stolice świata", description: "Tylko odpowiedzi prawda/fałsz."),
  Quiz(id: "quiz2", title: "Układ Słoneczny", description: "Trzy możliwe odpowiedzi, jedna poprawna."),
];

class QuizRepository {
  List<Quiz> getAllQuizzes() {
    return quizzes;
  }

  Quiz? getQuizById(String quizId) {
    return quizzes.firstWhere((quiz) => quiz.id == quizId, orElse: () => Quiz(id: "unknown", title: "Nieznany quiz", description: "Brak opisu"));
  }
}

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository();
});