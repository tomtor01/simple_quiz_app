import 'package:flutter/material.dart';
import 'adaptive_demo_page.dart';
import 'grid_comparison_demo.dart';
import '../../quiz/presentation/quiz_page.dart';

// Strona wyboru demonstracji
class DemoSelectionPage extends StatelessWidget {
  const DemoSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demonstracje responsywności (DemoSelectionPage)'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    Text('Demonstracje responsywnych interfejsów', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Wybierz jedną z poniższych demonstracji, aby zobaczyć różne'
                      ' podejścia do tworzenia responsywnych interfejsów użytkownika'
                      ' zgodnych z wytycznymi Material Design 3.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Przyciski do różnych demonstracji w zalecanej kolejności dydaktycznej
              _buildDemoCard(
                context,
                'Porównanie metod tworzenia siatki',
                'Porównanie dwóch podejść do tworzenia GridView: z określoną maksymalną szerokością elementu (preferowane) vs. ze stałą liczbą kolumn.',
                Icons.grid_view,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GridComparisonDemo()));
                },
              ),
              const SizedBox(height: 16),
              _buildDemoCard(
                context,
                'Adaptacyjne układy',
                'Demonstracja responsywnych układów dla różnych rozmiarów ekranu (kompaktowy, średni, rozszerzony).',
                Icons.devices,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AdaptiveDemoPage()));
                },
              ),
              const SizedBox(height: 16),
              _buildDemoCard(
                context,
                'Quiz o stolicach świata',
                'Quizowa aplikacja wykorzystująca Riverpod do zarządzania stanem i dostosowująca się do różnych rozmiarów ekranu.',
                Icons.quiz,
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
