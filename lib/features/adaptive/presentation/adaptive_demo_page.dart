import 'package:flutter/material.dart';
import '../../../core/widgets/responsive_layout.dart';

// Strona demonstracyjna używająca adaptywnego układu
// Demonstruje różne sposoby wyświetlania treści w zależności od rozmiaru ekranu:
// - kompaktowy: lista jednowierszowa (< 600px)
// - średni: siatka z dwoma kolumnami (600px - 840px)
// - duży: siatka z trzema kolumnami (840px - 1200px)
// - rozszerzony: siatka z czterema kolumnami (> 1200px)
class AdaptiveDemoPage extends StatefulWidget {
  const AdaptiveDemoPage({super.key});

  @override
  State<AdaptiveDemoPage> createState() => _AdaptiveDemoPageState();
}

class _AdaptiveDemoPageState extends State<AdaptiveDemoPage> {
  // Przechowuje indeks aktualnie wybranego elementu nawigacji
  int _selectedIndex = 0;

  // Lista elementów nawigacji wyświetlanych w dolnym pasku (tryb kompaktowy/średni/duży)
  // lub w bocznym panelu (tryb rozszerzony)
  final List<NavigationDestination> _destinations = const [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
    NavigationDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.bookmark), label: 'Saved'),
    NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    // Określenie klasy rozmiaru okna (compact, medium, large, expanded)
    // na podstawie aktualnej szerokości ekranu
    final windowSizeClass = ResponsiveLayout.getWindowSizeClass(context);

    // AdaptiveScaffold automatycznie dostosowuje nawigację do rozmiaru ekranu:
    // - Na ekranach kompaktowych, średnich i dużych (< 1200px): dolny pasek nawigacji (NavigationBar)
    // - Na ekranach rozszerzonych (> 1200px): boczny panel nawigacji (NavigationRail)
    return AdaptiveScaffold(
      title: 'Adaptive Layout Demo (AdaptiveDemoPage)',
      navigationDestinations: _destinations,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      floatingActionButton: FloatingActionButton(onPressed: () {}, tooltip: 'Dodaj', child: const Icon(Icons.add)),
      body: _buildBody(context, windowSizeClass),
    );
  }

  // Budowanie zawartości strony w zależności od klasy rozmiaru okna
  // Dodaje marginesy dostosowane do rozmiaru ekranu i wyświetla panel informacyjny
  Widget _buildBody(BuildContext context, WindowSizeClass windowSizeClass) {
    return Padding(
      // Zastosowanie marginesów odpowiednich dla danej klasy rozmiaru
      padding: ResponsiveLayout.getMarginForWindowSize(windowSizeClass),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel informacyjny o aktualnej klasie rozmiaru
          _buildWindowSizeInfo(context, windowSizeClass),
          const SizedBox(height: 16),

          // AdaptiveLayout automatycznie wybiera odpowiedni układ
          // w zależności od rozmiaru ekranu
          Expanded(
            child: AdaptiveLayout(
              // Układ dla kompaktowego rozmiaru (< 600px) - lista jednowierszowa
              compactLayout: _buildCompactLayout(context),

              // Układ dla średniego rozmiaru (600px - 840px) - siatka z dwoma kolumnami
              mediumLayout: _buildMediumLayout(context),

              // Układ dla dużego rozmiaru (840px - 1200px) - siatka z trzema kolumnami
              largeLayout: _buildLargeLayout(context),

              // Układ dla rozszerzonego rozmiaru (> 1200px) - siatka z czterema kolumnami
              expandedLayout: _buildExpandedLayout(context),
            ),
          ),
        ],
      ),
    );
  }

  // Informacja o aktualnej klasie rozmiaru okna i parametrach wyświetlacza
  // Wyświetla dane diagnostyczne pomocne przy projektowaniu responsywnych interfejsów
  Widget _buildWindowSizeInfo(BuildContext context, WindowSizeClass windowSizeClass) {
    // Pobieramy wymiary ekranu i inne parametry z MediaQuery
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final devicePixelRatio = mediaQuery.devicePixelRatio;

    // Obliczamy szerokość i wysokość w dp (density-independent pixels)
    // dzieląc piksele fizyczne przez współczynnik gęstości
    final widthDp = width / devicePixelRatio;
    final heightDp = height / devicePixelRatio;

    // Panel informacyjny z danymi o wymiarach ekranu
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aktualna klasa rozmiaru okna: ${windowSizeClass.name.toUpperCase()}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Wymiary ekranu: ${width.toStringAsFixed(0)} × ${height.toStringAsFixed(0)} px',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Wymiary ekranu: ${widthDp.toStringAsFixed(0)} × ${heightDp.toStringAsFixed(0)} dp',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text('Współczynnik gęstości pikseli: ${devicePixelRatio.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium),
          Text(
            'Orientacja: ${ResponsiveLayout.isLandscape(context) ? 'Pozioma' : 'Pionowa'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // Układ dla kompaktowego rozmiaru (< 600px)
  // Wyświetla listę jednowierszową elementów z avatar, tytułem i opisem
  Widget _buildCompactLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kompaktowy układ (< 600px)', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text('Układ jednowierszowy', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        // ListView.builder efektywnie tworzy elementy tylko gdy są widoczne,
        // co oszczędza pamięć przy dużej liczbie elementów
        Expanded(child: ListView.builder(itemCount: 10, itemBuilder: (context, index) => _buildListItem(context, index))),
      ],
    );
  }

  // Układ dla średniego rozmiaru (600px - 840px)
  // Wyświetla siatkę z elementami w formie kart, z maksymalną szerokością elementu
  Widget _buildMediumLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Średni układ (600px - 840px)', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text('Siatka z elementami o maksymalnej szerokości', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        // GridView.builder z określoną maksymalną szerokością elementu (300dp)
        // System automatycznie dopasuje liczbę kolumn w zależności od dostępnej przestrzeni
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300, // Maksymalna szerokość elementu
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 10,
            itemBuilder: (context, index) => _buildGridItem(context, index),
          ),
        ),
      ],
    );
  }

  // Układ dla dużego rozmiaru (840px - 1200px)
  // Wyświetla siatkę z elementami w formie kart, z trzema kolumnami
  Widget _buildLargeLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Duży układ (840px - 1200px)', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text('Siatka z trzema kolumnami', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        // GridView.builder z trzema kolumnami
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300, // Maksymalna szerokość elementu
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 10,
            itemBuilder: (context, index) => _buildGridItem(context, index),
          ),
        ),
      ],
    );
  }

  // Układ dla rozszerzonego rozmiaru (> 1200px)
  // Wyświetla siatkę z elementami w formie kart, z czterema kolumnami
  Widget _buildExpandedLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rozszerzony układ (> 1200px)', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text('Siatka z czterema kolumnami i boczny panel nawigacji', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        // GridView.builder z mniejszą maksymalną szerokością elementu (220dp)
        // Na większych ekranach zmieści się więcej kolumn
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220, // Mniejsza maksymalna szerokość dla trybu rozszerzonego
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 10,
            itemBuilder: (context, index) => _buildGridItem(context, index),
          ),
        ),
      ],
    );
  }

  // Element listy dla układu kompaktowego
  // Tworzy kartę z ListTile zawierającą avatar, tytuł, opis i ikonę akcji
  Widget _buildListItem(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        // Avatar z kolorem zależnym od indeksu elementu
        leading: CircleAvatar(backgroundColor: Colors.primaries[index % Colors.primaries.length], child: Text('${index + 1}')),
        title: Text('Element ${index + 1}'),
        subtitle: Text('Opis elementu ${index + 1}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  // Element siatki dla układów średniego i rozszerzonego
  // Tworzy kartę z ikoną, tytułem i opisem ułożonymi pionowo
  Widget _buildGridItem(BuildContext context, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikona z kolorem zależnym od indeksu elementu
            Icon(Icons.photo, size: 32, color: Colors.primaries[index % Colors.primaries.length]),
            const SizedBox(height: 8),
            Text('Element ${index + 1}', style: Theme.of(context).textTheme.titleMedium),
            Text('Opis elementu ${index + 1}', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
