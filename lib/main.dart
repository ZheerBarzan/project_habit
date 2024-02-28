import 'package:flutter/material.dart';
import 'package:project_habit/database/habit_database.dart';
import 'package:project_habit/pages/hompage.dart';
import 'package:project_habit/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLuanchDate();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => HabitDatabase()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
