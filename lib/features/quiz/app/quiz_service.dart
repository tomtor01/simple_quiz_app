import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/question_repository.dart';
import '../domain/quiz_state.dart';

// Kontroler quizu
class QuizService extends StateNotifier<QuizState> {
  final QuestionRepository _repository;
  final Map<String, QuizState> _savedStates = {};

  QuizService(this._repository)
    : super(QuizState(
      quizId: '',
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
    _savedStates[state.quizId] = state;
  }

  // Metoda do ładowania pytań
  Future<void> loadQuestions(String quizId) async {
    if (_savedStates.containsKey(quizId)) {
      state = _savedStates[quizId]!;
      return;
    }
    await _repository.loadQuestions(quizId);
    final questions = _repository.getAllQuestions();

    if (questions.isNotEmpty) {
      state = QuizState(
        quizId: quizId,
        questions: questions,
        currentQuestionIndex: 0,
        userAnswers: List.generate(questions.length, (_) => <int>[]),
        isCompleted: false,
      );
    }
  }
  // Metoda do restartowania quizu
  void restartQuiz() {
    state = QuizState(
        quizId: state.quizId,
        questions: state.questions,
        currentQuestionIndex: 0,
        userAnswers: List.generate(state.questions.length, (_) => <int>[]),
        isCompleted: false
    );
    _savedStates[state.quizId] = state;
  }
}

// Provider kontrolera quizu
final quizServiceProvider = StateNotifierProvider<QuizService, QuizState>((ref) {
  final repository = ref.watch(questionRepositoryProvider);
  return QuizService(repository);
});
