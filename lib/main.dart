import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/theme.dart';
import 'providers/hydration_provider.dart';
import 'providers/settings_provider.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HydrationProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storageService, notificationService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaBloom',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {'/settings': (context) => const SettingsScreen()},
    );
  }
}
