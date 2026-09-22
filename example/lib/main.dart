import 'package:flutter/material.dart';

import 'screens/button_demo_screen.dart';
import 'screens/form_demo_screen.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  ThemeMode _mode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Devant Components',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: _mode,
      home: HomeScreen(
        isDark: _mode == ThemeMode.dark,
        onToggleTheme: () => setState(() {
          _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        }),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devant Components'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.smart_button),
            title: const Text('Buttons'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ButtonDemoScreen(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit_note),
            title: const Text('Forms'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const FormDemoScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
