import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cllppwdhdzkmzbynxuuw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNsbHBwd2RoZHprbXpieW54dXV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzNjQ3ODIsImV4cCI6MjA4OTk0MDc4Mn0.5zKvg7U_ajZ_SNxogbW6CbEmtJk10PszicwN174ezoM',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoScan AI',

      theme: ThemeData.dark(),

      home: session == null
          ? const LoginScreen()
          : const HomeScreen(),
    );
  }
}