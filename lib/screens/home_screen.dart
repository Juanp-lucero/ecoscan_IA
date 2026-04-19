import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final screens = [
    const MapScreen(),
    const DashboardScreen(),
  ];

  void _goToReport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EcoScan AI 🌱"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: screens[index],

      // ✅ BOTÓN FLOTANTE
      floatingActionButton: FloatingActionButton(
        onPressed: _goToReport,
        backgroundColor: const Color(0xFF00E676),
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          setState(() => index = value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Dashboard",
          ),
        ],
      ),
    );
  }
}