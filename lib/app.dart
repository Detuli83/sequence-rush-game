import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/settings_provider.dart';
import 'screens/main_menu_screen.dart';

/// Root application widget
class SequenceRushApp extends StatelessWidget {
  const SequenceRushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Sequence Rush',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MainMenuScreen(),
        );
      },
    );
  }
}
