import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/app_strings.dart';

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

  final List<Widget> screens = const [
    ReportScreen(),
    MapScreen(),
    DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111A),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.eco,
              color: Colors.greenAccent,
            ),

            const SizedBox(width: 8),

            Text(
              AppStrings.appName,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),

        actions: [
          // 🌐 LANGUAGE
          IconButton(
            icon: const Icon(
              Icons.language,
              color: Colors.greenAccent,
            ),
            onPressed: () {
              setState(() {
                AppStrings.isEnglish = !AppStrings.isEnglish;
              });
            },
          ),

          // 🔓 LOGOUT
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.redAccent,
            ),
            onPressed: () async {
              await AuthService().signOut();

              if (!mounted) return;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: screens[currentIndex],
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B24),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.greenAccent.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),

          child: BottomNavigationBar(
            currentIndex: currentIndex,

            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },

            backgroundColor: const Color(0xFF0D1B24),

            selectedItemColor: Colors.greenAccent,
            unselectedItemColor: Colors.grey,

            type: BottomNavigationBarType.fixed,

            elevation: 0,

            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.camera_alt),
                label: AppStrings.isEnglish
                    ? "Scan"
                    : "Escanear",
              ),

              BottomNavigationBarItem(
                icon: const Icon(Icons.map),
                label: AppStrings.isEnglish
                    ? "Map"
                    : "Mapa",
              ),

              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart),
                label: AppStrings.stats,
              ),
            ],
          ),
        ),
      ),
    );
  }
}