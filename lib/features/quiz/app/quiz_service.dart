import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/question_repository.dart';
import '../domain/quiz_state.dart';

// Kontroler quizu
class QuizService extends StateNotifier<QuizState> {
  final QuestionRepository _repository;

  QuizService(this._repository)
    : super(QuizState(questions: _repository.getAllQuestions(), currentQuestionIndex: 0, userAnswers: [], isCompleted: false));

  // Metoda do odpowiadania na pytanie
  void answerQuestion(int answer) {
    if (state.isCompleted) return;

    final updatedAnswers = List<int>.from(state.userAnswers)..add(answer);
    final isLastQuestion = state.currentQuestionIndex == state.questions.length - 1;
    final newIndex = isLastQuestion ? state.currentQuestionIndex : state.currentQuestionIndex + 1;
    final isCompleted = updatedAnswers.length == state.questions.length;

    state = state.copyWith(userAnswers: updatedAnswers, currentQuestionIndex: newIndex, isCompleted: isCompleted);
  }

  // Metoda do ładowania pytań
  Future<void> loadQuestions(String quizId) async {
    await _repository.loadQuestions(quizId);
    state = state.copyWith(questions: _repository.getAllQuestions());
  }

  // Metoda do restartowania quizu
  void restartQuiz() {
    state = QuizState(questions: state.questions, currentQuestionIndex: 0, userAnswers: [], isCompleted: false);
  }
}

// Provider kontrolera quizu
final quizServiceProvider = StateNotifierProvider<QuizService, QuizState>((ref) {
  final repository = ref.watch(questionRepositoryProvider);
  return QuizService(repository);
});
