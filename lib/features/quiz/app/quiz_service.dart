import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/question_repository.dart';
import '../domain/quiz_state.dart';

// Kontroler quizu
class QuizService extends StateNotifier<QuizState> {
  final QuestionRepository _repository;

  QuizService(this._repository)
    : super(QuizState(
      questions: _repository.getAllQuestions(),
      currentQuestionIndex: 0,
      userAnswers: [],
      isCompleted: false)
  );

  // Metoda do odpowiadania na pytanie
  void answerQuestion(List<int> answer) {
    if (state.isCompleted) return;

    final updatedAnswers = List<List<int>>.from(state.userAnswers);
    updatedAnswers[state.currentQuestionIndex] = answer;
    final isLastQuestion = state.currentQuestionIndex == state.questions.length - 1;
    final newIndex = isLastQuestion ? state.currentQuestionIndex : state.currentQuestionIndex + 1;
    final isCompleted = updatedAnswers.every((answers) => answers.isNotEmpty);

    state = state.copyWith(userAnswers: updatedAnswers, currentQuestionIndex: newIndex, isCompleted: isCompleted);
  }

  // Metoda do ładowania pytań
  Future<void> loadQuestions(String quizId) async {
    await _repository.loadQuestions(quizId);
    final questions = _repository.getAllQuestions();

    if (questions.isNotEmpty) {
      state = QuizState(
        questions: questions,
        currentQuestionIndex: 0,
        userAnswers: List.generate(questions.length, (_) => <int>[]),
        isCompleted: false,
      );
    } else {

    }
  }
  // Metoda do restartowania quizu
  void restartQuiz() {
    state = QuizState(
        questions: state.questions,
        currentQuestionIndex: 0,
        userAnswers: List.generate(state.questions.length, (_) => <int>[]),
        isCompleted: false
    );
  }
}

// Provider kontrolera quizu
final quizServiceProvider = StateNotifierProvider<QuizService, QuizState>((ref) {
  final repository = ref.watch(questionRepositoryProvider);
  return QuizService(repository);
});
