import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../quiz/app/quiz_service.dart';
import '../../quiz/data/quiz_repository.dart';
import '../../quiz/presentation/quiz_page.dart';

// Strona wyboru demonstracji
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizzes = ref.watch(quizRepositoryProvider).getAllQuizzes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quiz demo', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Wybierz jeden z poniższych quizów.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ListView.builder(
                shrinkWrap: true,
                //physics: const NeverScrollableScrollPhysics(),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildQuizCard(
                      context,
                      quiz,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizPage(quiz: quiz)),
                        ).then((_) {
                          if (ref.read(quizServiceProvider).isCompleted) {
                            ref.read(quizServiceProvider.notifier).restartQuiz();
                          }
                        }
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Funkcja budująca kartę dla demonstracji
  Widget _buildQuizCard(BuildContext context, Quiz quiz, VoidCallback onTap) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.quiz, size: 36, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(quiz.title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(quiz.description, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
