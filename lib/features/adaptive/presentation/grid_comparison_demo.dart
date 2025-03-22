import 'package:flutter/material.dart';
import '../../../core/widgets/responsive_layout.dart';

/// Strona demonstrująca porównanie dwóch metod tworzenia siatki (GridView)
/// - Metoda preferowana: SliverGridDelegateWithMaxCrossAxisExtent
/// - Metoda starsza: SliverGridDelegateWithFixedCrossAxisCount
class GridComparisonDemo extends StatefulWidget {
  const GridComparisonDemo({super.key});

  @override
  State<GridComparisonDemo> createState() => _GridComparisonDemoState();
}

class _GridComparisonDemoState extends State<GridComparisonDemo> with SingleTickerProviderStateMixin {
  /// Kontroler do zarządzania zakładkami
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inicjalizacja kontrolera zakładek z 2 zakładkami
    // vsync: this - obiekt stanu służy jako źródło synchronizacji animacji
    // (wymaga mixina SingleTickerProviderStateMixin)
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Zwolnienie zasobów kontrolera zakładek, aby zapobiec wyciekom pamięci
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Określenie klasy rozmiaru okna na podstawie aktualnych wymiarów ekranu
    final windowSizeClass = ResponsiveLayout.getWindowSizeClass(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Porównanie metod tworzenia siatki (GridComparisonDemo)'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "Preferowana metoda"), Tab(text: "Starsza metoda")],
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pierwsza zakładka - metoda preferowana (SliverGridDelegateWithMaxCrossAxisExtent)
          _buildPreferredMethodTab(context, windowSizeClass),

          // Druga zakładka - starsza metoda (SliverGridDelegateWithFixedCrossAxisCount)
          _buildOldMethodTab(context, windowSizeClass),
        ],
      ),
    );
  }

  // Zakładka z preferowaną metodą (SliverGridDelegateWithMaxCrossAxisExtent)
  Widget _buildPreferredMethodTab(BuildContext context, WindowSizeClass windowSizeClass) {
    return Column(
      children: [
        // Panel informacyjny o metodzie
        _buildInfoPanel(
          context,
          title: 'SliverGridDelegateWithMaxCrossAxisExtent',
          description:
              'Preferowana metoda: określa maksymalną szerokość elementu, '
              'a system automatycznie dostosowuje liczbę kolumn do dostępnej przestrzeni.',
          isPreferred: true,
        ),

        // Parametry siatki
        _buildParametersPanel(
          context,
          parameters: ['maxCrossAxisExtent: 250.0', 'childAspectRatio: 1.5', 'crossAxisSpacing: 16.0', 'mainAxisSpacing: 16.0'],
        ),

        // Siatka z przykładowymi elementami
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250.0, // Maksymalna szerokość elementu
                childAspectRatio: 1.5, // Stosunek szerokości do wysokości elementu (1.5:1)
                crossAxisSpacing: 16.0, // Odstęp poziomy między elementami
                mainAxisSpacing: 16.0, // Odstęp pionowy między elementami
              ),
              itemCount: 30, // Liczba elementów w siatce
              itemBuilder: (context, index) => _buildGridItem(context, index),
            ),
          ),
        ),
      ],
    );
  }

  // Zakładka ze starszą metodą (SliverGridDelegateWithFixedCrossAxisCount)
  Widget _buildOldMethodTab(BuildContext context, WindowSizeClass windowSizeClass) {
    // Określenie liczby kolumn w zależności od klasy rozmiaru
    int columnCount = 1;
    // Dostosowanie liczby kolumn do rozmiaru ekranu
    switch (windowSizeClass) {
      case WindowSizeClass.compact:
        columnCount = 1; // Wąski ekran - 1 kolumna
        break;
      case WindowSizeClass.medium:
        columnCount = 2; // Średni ekran - 2 kolumny
        break;
      case WindowSizeClass.large:
        columnCount = 3; // Duży ekran - 3 kolumny
        break;
      case WindowSizeClass.expanded:
        columnCount = 4; // Szeroki ekran - 4 kolumny
        break;
    }

    return Column(
      children: [
        // Panel informacyjny o metodzie
        _buildInfoPanel(
          context,
          title: 'SliverGridDelegateWithFixedCrossAxisCount',
          description:
              'Starsza metoda: określa sztywną liczbę kolumn ($columnCount dla '
              'obecnego rozmiaru ekranu). Wymaga ręcznego dostosowania liczby kolumn do różnych rozmiarów ekranu.',
          isPreferred: false,
        ),

        // Parametry siatki
        _buildParametersPanel(
          context,
          parameters: ['crossAxisCount: $columnCount', 'childAspectRatio: 1.5', 'crossAxisSpacing: 16.0', 'mainAxisSpacing: 16.0'],
        ),

        // Siatka z przykładowymi elementami
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnCount, // Stała liczba kolumn określona na podstawie rozmiaru ekranu
                childAspectRatio: 1.5, // Stosunek szerokości do wysokości elementu (1.5:1)
                crossAxisSpacing: 16.0, // Odstęp poziomy między elementami
                mainAxisSpacing: 16.0, // Odstęp pionowy między elementami
              ),
              itemCount: 30, // Liczba elementów w siatce
              itemBuilder: (context, index) => _buildGridItem(context, index),
            ),
          ),
        ),
      ],
    );
  }

  // Panel informacyjny o metodzie
  Widget _buildInfoPanel(BuildContext context, {required String title, required String description, required bool isPreferred}) {
    // Kontener z informacjami o wybranej metodzie tworzenia siatki
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      decoration: BoxDecoration(
        // Kolor tła zależny od tego, czy metoda jest preferowana
        color: isPreferred ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ikona zależna od tego, czy metoda jest preferowana
              Icon(
                isPreferred ? Icons.check_circle : Icons.warning,
                color: isPreferred ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isPreferred ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  // Panel z parametrami siatki
  Widget _buildParametersPanel(BuildContext context, {required List<String> parameters}) {
    // Kontener pokazujący parametry wybranej metody tworzenia siatki
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Parametry:', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8.0),
          // Tworzenie listy punktowanej z parametrami
          ...parameters.map(
            (param) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text('• $param', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace')),
            ),
          ),
        ],
      ),
    );
  }

  // Element siatki
  Widget _buildGridItem(BuildContext context, int index) {
    // Tworzenie pojedynczego elementu siatki
    return Card(
      elevation: 2.0,
      child: Container(
        // Kolorowe obramowanie po lewej stronie, kolor zależy od indeksu elementu
        decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.primaries[index % Colors.primaries.length], width: 4.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikona z kolorem zależnym od indeksu elementu
            Icon(Icons.grid_view, color: Colors.primaries[index % Colors.primaries.length], size: 24.0),
            const SizedBox(height: 8.0),
            Text('Element ${index + 1}', style: Theme.of(context).textTheme.titleSmall),
            Text('Elastyczna szerokość', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
