import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_quiz_app/features/quiz/app/quiz_service.dart';
import '../data/quiz_repository.dart';
import '../domain/quiz_state.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key, required this.quiz});

  final Quiz quiz;

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  @override
  void initState() {
    super.initState();
    ref.read(quizServiceProvider.notifier).loadQuestions(widget.quiz.id);
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: quizState.isCompleted
              ? _buildResultScreen(context, ref, quizState)
              : _buildQuizScreen(context, ref, quizState),
        ),
      ),
    );
  }

  // Ekran z pytaniem
  Widget _buildQuizScreen(BuildContext context, WidgetRef ref, QuizState state) {
    final currentQuestion = state.questions[state.currentQuestionIndex];
    final questionNumber = state.currentQuestionIndex + 1;
    final totalQuestions = state.questions.length;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Pytanie $questionNumber z $totalQuestions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),

          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    currentQuestion.text,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  Column(
                    children: List.generate(currentQuestion.answers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _answerQuestion(ref, index),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              backgroundColor: Colors.blue[100],
                            ),
                            child: Text(
                              currentQuestion.answers[index],
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
          LinearProgressIndicator(
            value: state.userAnswers.length / state.questions.length,
            backgroundColor: Colors.grey[300],
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // Ekran z wynikami
  Widget _buildResultScreen(BuildContext context, WidgetRef ref, QuizState state) {
    final correctAnswers = state.correctAnswersCount;
    final totalQuestions = state.questions.length;
    final percentage = (correctAnswers / totalQuestions * 100).round();

    Color resultColor = Colors.yellow;
    String resultMessage = 'Możesz poprawić!';

    if (percentage >= 80) {
      resultColor = Colors.green;
      resultMessage = 'Świetnie!';
    } else if (percentage >= 60) {
      resultColor = Colors.blue;
      resultMessage = 'Dobrze!';
    } else if (percentage < 40) {
      resultColor = Colors.red;
      resultMessage = 'Potrzebujesz więcej nauki!';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Wyniki', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          Card(
            elevation: 4,
            color: resultColor.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(resultMessage, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: resultColor.withOpacity(0.8))),
                  const SizedBox(height: 16),
                  Text('Poprawnych odpowiedzi: $correctAnswers z $totalQuestions', style: const TextStyle(fontSize: 16)),
                  Text('Wynik: $percentage%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: () => _restartQuiz(ref),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Spróbuj ponownie'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _answerQuestion(WidgetRef ref, int answer) {
    ref.read(quizServiceProvider.notifier).answerQuestion(answer);
  }

  void _restartQuiz(WidgetRef ref) {
    ref.read(quizServiceProvider.notifier).restartQuiz();
  }
}
