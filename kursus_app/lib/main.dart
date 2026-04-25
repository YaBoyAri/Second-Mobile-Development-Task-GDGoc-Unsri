// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const KursusApp());
}

class KursusApp extends StatefulWidget {
  const KursusApp({super.key});

  @override
  State<KursusApp> createState() => _KursusAppState();
}

class _KursusAppState extends State<KursusApp> {
  // State global untuk dark mode - dikelola di root
  bool _isDarkMode = false;

  void _toggleDarkMode(bool val) {
    setState(() => _isDarkMode = val);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KursusKu',
      debugShowCheckedModeBanner: false,

      // Tema terang
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4), // Ungu GDGoc-ish
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),

      // Tema gelap
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),

      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Named routes
      routes: {
        '/': (ctx) => MainScaffold(
              isDarkMode: _isDarkMode,
              onToggleDarkMode: _toggleDarkMode,
            ),
      },
    );
  }
}

// Scaffold utama dengan bottom navigation
class MainScaffold extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;

  const MainScaffold({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _halamanAktif = 0;

  @override
  Widget build(BuildContext context) {
    final halaman = [
      const HomeScreen(),
      SettingsScreen(
        isDarkMode: widget.isDarkMode,
        onToggleDarkMode: widget.onToggleDarkMode,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _halamanAktif,
        children: halaman,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _halamanAktif,
        onDestinationSelected: (i) => setState(() => _halamanAktif = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
