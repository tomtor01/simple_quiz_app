import 'package:flutter/material.dart';
import '../../quiz/presentation/quiz_page.dart';

// Strona wyboru demonstracji
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Karta informacyjna
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
                      'Wybierz jednen z poniższych quizów.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildDemoCard(
                context,
                'Quiz o stolicach świata',
                'Tylko odpowiedzi typu prawda/fałsz',
                Icons.quiz,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizPage()));
                },
              ),
              const SizedBox(height: 8),
              _buildDemoCard(
                context,
                'Quiz o planetach układu słonecznego',
                '3 odpowiedzi, jedna poprawna',
                Icons.face,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Funkcja budująca kartę dla demonstracji
  Widget _buildDemoCard(BuildContext context, String title, String description, IconData icon, VoidCallback onTap) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(description, style: Theme.of(context).textTheme.bodySmall),
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
