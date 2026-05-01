import 'package:flutter/material.dart';
import 'models.dart';
import 'screens.dart';

void main() {
  runApp(const PashuAushadhiApp());
}

class PashuAushadhiApp extends StatefulWidget {
  const PashuAushadhiApp({super.key});

  @override
  State<PashuAushadhiApp> createState() => _PashuAushadhiAppState();
}

class _PashuAushadhiAppState extends State<PashuAushadhiApp> {
  final AppState appState = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pashu Aushadhi Vikray Kendra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
          secondary: Colors.orange,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: MainScreen(appState: appState),
    );
  }
}

class MainScreen extends StatefulWidget {
  final AppState appState;
  const MainScreen({super.key, required this.appState});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(appState: widget.appState),
      POSScreen(appState: widget.appState),
      InventoryScreen(appState: widget.appState),
      PurchasesScreen(appState: widget.appState),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined), 
            selectedIcon: Icon(Icons.dashboard), 
            label: 'Dashboard'
          ),
          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined), 
            selectedIcon: Icon(Icons.point_of_sale), 
            label: 'POS'
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined), 
            selectedIcon: Icon(Icons.inventory_2), 
            label: 'Inventory'
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined), 
            selectedIcon: Icon(Icons.shopping_cart), 
            label: 'Purchases'
          ),
        ],
      ),
    );
  }
}