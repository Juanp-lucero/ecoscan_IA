import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'report_screen.dart';
import 'dashboard_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final screens = [
    const ReportScreen(),
    const MapScreen(),
    const DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EcoScan AI 🌱"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.greenAccent),
            onPressed: () async {
              await AuthService().signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          )
        ],
      ),

      body: screens[currentIndex],

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(color: Colors.greenAccent, blurRadius: 10)
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: "Scan",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Stats",
            ),
          ],
        ),
      ),
    );
  }
}