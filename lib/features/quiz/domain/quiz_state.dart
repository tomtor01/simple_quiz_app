import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/question_repository.dart';

part 'quiz_state.freezed.dart';

// Stan quizu - klasa domenowa implementująca immutability
@freezed
class QuizState with _$QuizState {
  const QuizState._();

  const factory QuizState({
    required List<Question> questions,
    required int currentQuestionIndex,
    required List<int> userAnswers,
    required bool isCompleted,
  }) = _QuizState;

  // Getter zwracający liczbę poprawnych odpowiedzi
  int get correctAnswersCount {
    int count = 0;
    for (int i = 0; i < userAnswers.length; i++) {
      if (userAnswers[i] == questions[i].correctAnswer) {
        count++;
      }
    }
    return count;
  }

  // Getter sprawdzający czy wszystkie pytania zostały odpowiedziane
  bool get allQuestionsAnswered => userAnswers.length == questions.length;
}
