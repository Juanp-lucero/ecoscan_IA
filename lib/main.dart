import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cllppwdhdzkmzbynxuuw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNsbHBwd2RoZHprbXpieW54dXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNjQ3ODIsImV4cCI6MjA4OTk0MDc4Mn0.5zKvg7U_ajZ_SNxogbW6CbEmtJk10PszicwN174ezoM',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoScan AI',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF020617),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF064E3B),
          elevation: 0,
        ),

        colorScheme: const ColorScheme.dark(
          primary: Colors.greenAccent,
        ),
      ),

      home: const LoginScreen(),
    );
  }
}