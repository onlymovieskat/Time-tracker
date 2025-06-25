// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/screens/HomeScreen.dart';
import 'providers/time_entry_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()..load()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..load()),
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()..load()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Time Tracking',
    theme: ThemeData(primarySwatch: Colors.teal),
    home: const HomeScreen(),
  );
}
