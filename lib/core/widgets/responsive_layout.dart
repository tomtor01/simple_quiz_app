import 'package:flutter/material.dart';

// Klasy rozmiarów okna zgodne z Material Design 3
enum WindowSizeClass {
  compact, // < 600px szerokości
  medium, // 600px - 840px szerokości
  large, // 840px - 1200px szerokości
  expanded, // > 1200px szerokości
}

// Klasa pomocnicza do określania klasy rozmiaru okna
class ResponsiveLayout {
  // Wartości graniczne dla klas rozmiaru okna zgodnie z Material Design 3
  static const double _compactMaxWidth = 600;
  static const double _mediumMaxWidth = 840;
  static const double _largeMaxWidth = 1200;

  // Określa aktualną klasę rozmiaru okna na podstawie szerokości
  static WindowSizeClass getWindowSizeClass(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < _compactMaxWidth) {
      return WindowSizeClass.compact;
    } else if (width < _mediumMaxWidth) {
      return WindowSizeClass.medium;
    } else if (width < _largeMaxWidth) {
      return WindowSizeClass.large;
    } else {
      return WindowSizeClass.expanded;
    }
  }

  // Określa czy urządzenie jest w orientacji poziomej
  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  // Zwraca liczbę kolumn dla siatki w zależności od klasy rozmiaru
  static int getGridColumnCount(WindowSizeClass windowSizeClass) {
    switch (windowSizeClass) {
      case WindowSizeClass.compact:
        return 1;
      case WindowSizeClass.medium:
        return 2;
      case WindowSizeClass.large:
        return 3;
      case WindowSizeClass.expanded:
        return 4;
    }
  }

  // Zwraca odpowiednie marginesy w zależności od klasy rozmiaru
  static EdgeInsets getMarginForWindowSize(WindowSizeClass windowSizeClass) {
    switch (windowSizeClass) {
      case WindowSizeClass.compact:
        return const EdgeInsets.all(16.0);
      case WindowSizeClass.medium:
        return const EdgeInsets.all(24.0);
      case WindowSizeClass.large:
        return const EdgeInsets.all(28.0);
      case WindowSizeClass.expanded:
        return const EdgeInsets.all(32.0);
    }
  }
}

// Widget, który renderuje różne widoki w zależności od klasy rozmiaru okna
class AdaptiveLayout extends StatelessWidget {
  final Widget compactLayout;
  final Widget mediumLayout;
  final Widget expandedLayout;
  final Widget? largeLayout;

  const AdaptiveLayout({
    super.key,
    required this.compactLayout,
    required this.mediumLayout,
    required this.expandedLayout,
    this.largeLayout,
  });

  @override
  Widget build(BuildContext context) {
    final windowSizeClass = ResponsiveLayout.getWindowSizeClass(context);

    switch (windowSizeClass) {
      case WindowSizeClass.compact:
        return compactLayout;
      case WindowSizeClass.medium:
        return mediumLayout;
      case WindowSizeClass.large:
        return largeLayout ?? expandedLayout;
      case WindowSizeClass.expanded:
        return expandedLayout;
    }
  }
}

// Widget dla adaptacyjnego układu z opcjonalnym panelem bocznym
class AdaptiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<NavigationDestination>? navigationDestinations;
  final int? selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final FloatingActionButton? floatingActionButton;

  const AdaptiveScaffold({
    super.key,
    required this.title,
    required this.body,
    this.navigationDestinations,
    this.selectedIndex,
    this.onDestinationSelected,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final windowSizeClass = ResponsiveLayout.getWindowSizeClass(context);

    // Panel nawigacyjny widoczny tylko w trybie rozszerzonym (powyżej 1200px)
    final showSideNav = windowSizeClass == WindowSizeClass.expanded && navigationDestinations != null;

    return Scaffold(
      appBar: AppBar(title: Text('$title (AdaptiveScaffold)'), backgroundColor: Theme.of(context).colorScheme.primaryContainer),
      body: SafeArea(
        child:
            showSideNav
                ? Row(
                  children: [
                    // Panel boczny
                    NavigationRail(
                      selectedIndex: selectedIndex ?? 0,
                      onDestinationSelected: onDestinationSelected ?? (_) {},
                      labelType: NavigationRailLabelType.all,
                      destinations:
                          navigationDestinations!
                              .map((destination) => NavigationRailDestination(icon: destination.icon, label: Text(destination.label)))
                              .toList(),
                    ),
                    // Separator
                    const VerticalDivider(thickness: 1, width: 1),
                    // Główna zawartość
                    Expanded(child: body),
                  ],
                )
                : body,
      ),
      // Dolny pasek nawigacji widoczny tylko w trybach kompaktowym, średnim i dużym
      bottomNavigationBar:
          showSideNav || navigationDestinations == null
              ? null
              : NavigationBar(
                selectedIndex: selectedIndex ?? 0,
                onDestinationSelected: onDestinationSelected ?? (_) {},
                destinations: navigationDestinations!,
              ),
      floatingActionButton: floatingActionButton,
    );
  }
}
