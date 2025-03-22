import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/adaptive/presentation/demo_selection_page.dart';

void main() {
  runApp(
    // Dodajemy ProviderScope, aby umożliwić korzystanie z Riverpod w całej aplikacji
    const ProviderScope(child: ResponsiveApp()),
  );
}

// Klasa główna aplikacji
class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MD3 Responsive Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      // Używamy strony startowej, która pozwala na wybór demonstracji
      home: const DemoSelectionPage(),
    );
  }
}

// Wyliczenie dla klas rozmiaru okna zgodnych z Material Design 3
enum WindowSizeClass {
  compact, // Kompaktowy - głównie telefony w trybie portretowym
  medium, // Średni - telefony w trybie poziomym lub małe tablety
  expanded, // Rozszerzony - duże tablety i komputery
}

// Strona główna demonstrująca responsywność
class ResponsiveHomePage extends StatelessWidget {
  const ResponsiveHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Określenie klasy rozmiaru okna na podstawie szerokości
    WindowSizeClass windowSizeClass = _getWindowSizeClass(context);

    // Pobranie informacji o wymiarach ekranu
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final devicePixelRatio = mediaQuery.devicePixelRatio;

    // Obliczenie wymiarów w dp
    final widthDp = width / devicePixelRatio;
    final heightDp = height / devicePixelRatio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Design 3 Responsive Layout (ResponsiveHomePage)'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        // SafeArea zapewnia, że zawartość aplikacji nie będzie zasłonięta przez elementy systemowe,
        // takie jak pasek statusu na górze ekranu, "notch" czy zaokrąglone rogi ekranu.
        // Jest to szczególnie ważne na urządzeniach z nietypowymi kształtami wyświetlaczy
        // lub systemowymi paskami nawigacji, aby treść była zawsze w pełni widoczna i dostępna.
        child: Column(
          children: [
            // Panel informacyjny o aktualnej klasie rozmiaru
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.secondaryContainer,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aktualna klasa rozmiaru okna: ${windowSizeClass.name.toUpperCase()}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Wymiary ekranu: ${width.toStringAsFixed(0)} x ${height.toStringAsFixed(0)} px',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Wymiary ekranu: ${widthDp.toStringAsFixed(0)} x ${heightDp.toStringAsFixed(0)} dp',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Współczynnik gęstości pikseli: ${devicePixelRatio.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Orientacja: ${mediaQuery.orientation == Orientation.landscape ? 'Pozioma' : 'Pionowa'}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Zawartość strony zmienia się w zależności od klasy rozmiaru
            Expanded(child: _buildResponsiveContent(context, windowSizeClass)),
          ],
        ),
      ),
    );
  }

  // Funkcja określająca klasę rozmiaru okna na podstawie szerokości ekranu
  WindowSizeClass _getWindowSizeClass(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Granice klas rozmiaru zgodnie z Material Design 3
    if (width < 600) {
      return WindowSizeClass.compact;
    } else if (width < 840) {
      return WindowSizeClass.medium;
    } else {
      return WindowSizeClass.expanded;
    }
  }

  // Funkcja budująca różne układy w zależności od klasy rozmiaru
  Widget _buildResponsiveContent(BuildContext context, WindowSizeClass windowSizeClass) {
    switch (windowSizeClass) {
      // Układ kompaktowy - jedna kolumna
      case WindowSizeClass.compact:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Widok kompaktowy (< 600px)'),
              _buildInfoCard(
                context,
                'Kompaktowy układ - jedna kolumna',
                'Ten układ jest przeznaczony dla telefonów w orientacji pionowej.',
                Colors.orange,
              ),
              const SizedBox(height: 16),
              _buildCardsList(context, 1), // Lista z jedną kolumną
            ],
          ),
        );

      // Układ średni - dwie kolumny
      case WindowSizeClass.medium:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Widok średni (600px - 840px)'),
              _buildInfoCard(
                context,
                'Średni układ - dwie kolumny',
                'Ten układ jest przeznaczony dla telefonów w orientacji poziomej lub małych tabletów.',
                Colors.green,
              ),
              const SizedBox(height: 16),
              _buildCardsList(context, 2), // Lista z dwiema kolumnami
            ],
          ),
        );

      // Układ rozszerzony - trzy kolumny i panel boczny
      case WindowSizeClass.expanded:
        return Row(
          children: [
            // Panel boczny widoczny tylko w widoku rozszerzonym
            Container(
              width: 250,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Panel boczny'),
                  const SizedBox(height: 16),
                  _buildNavigationItem(context, 'Strona główna', Icons.home),
                  _buildNavigationItem(context, 'Wiadomości', Icons.message),
                  _buildNavigationItem(context, 'Ustawienia', Icons.settings),
                  _buildNavigationItem(context, 'Profil', Icons.person),
                ],
              ),
            ),
            // Główna zawartość
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, 'Widok rozszerzony (> 840px)'),
                    _buildInfoCard(
                      context,
                      'Rozszerzony układ - trzy kolumny z panelem bocznym',
                      'Ten układ jest przeznaczony dla dużych tabletów i komputerów.',
                      Colors.purple,
                    ),
                    const SizedBox(height: 16),
                    _buildCardsList(context, 3), // Lista z trzema kolumnami
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  // Funkcja budująca tytuł sekcji
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }

  // Funkcja budująca kartę informacyjną
  Widget _buildInfoCard(BuildContext context, String title, String description, Color color) {
    return Card(
      elevation: 2,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: color),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color)),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  // Funkcja budująca siatkę kart w zależności od maksymalnej szerokości elementu
  Widget _buildCardsList(BuildContext context, int columnCount) {
    // Określamy maksymalną szerokość elementu w zależności od aktualnego trybu
    // Im większy ekran, tym mniejsza maksymalna szerokość (więcej kolumn)
    double maxWidth;
    switch (columnCount) {
      case 1: // Dla trybu kompaktowego - szeroki element
        maxWidth = 600;
        break;
      case 2: // Dla trybu średniego - średni element
        maxWidth = 350;
        break;
      default: // Dla trybu rozszerzonego - wąski element
        maxWidth = 250;
        break;
    }

    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxWidth, // Maksymalna szerokość elementu
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.article, size: 32, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 8),
                  Text('Element ${index + 1}', style: Theme.of(context).textTheme.titleMedium),
                  Text('Opis elementu ${index + 1}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Funkcja budująca element nawigacji w panelu bocznym
  Widget _buildNavigationItem(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
