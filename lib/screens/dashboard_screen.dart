import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> reports = [];

  bool isLoading = true;

  int totalReports = 0;
  int highImpact = 0;
  int mediumImpact = 0;
  int lowImpact = 0;

  @override
  void initState() {
    super.initState();

    loadReports();
  }

  Future<void> loadReports() async {
    final data = await SupabaseService().getReports();

    int high = 0;
    int medium = 0;
    int low = 0;

    for (final report in data) {
      final impact =
          (report['impact'] ?? '').toString().toLowerCase();

      if (impact.contains('high')) {
        high++;
      } else if (impact.contains('medium')) {
        medium++;
      } else if (impact.contains('low')) {
        low++;
      }
    }

    setState(() {
      reports = data;

      totalReports = data.length;
      highImpact = high;
      mediumImpact = medium;
      lowImpact = low;

      isLoading = false;
    });
  }

  Widget buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: const Color(0xFF11212D),

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: Colors.greenAccent.withOpacity(0.2),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.08),
              blurRadius: 15,
            ),
          ],
        ),

        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.greenAccent,
              size: 28,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReportCard(Map<String, dynamic> report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF11212D),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.greenAccent.withOpacity(0.2),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            report['type'] ?? 'Unknown',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            report['impact'] ?? '',
            style: const TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            report['description'] ?? '',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            report['created_at'] ?? '',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.greenAccent,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF07111A),

      body: RefreshIndicator(
        color: Colors.greenAccent,
        onRefresh: loadReports,

        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [
            const SizedBox(height: 10),

            const Text(
              "Environmental Analytics",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "AI-powered environmental monitoring dashboard",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                buildMetricCard(
                  title: "Reports",
                  value: totalReports.toString(),
                  icon: Icons.analytics,
                ),

                buildMetricCard(
                  title: "High Impact",
                  value: highImpact.toString(),
                  icon: Icons.warning_amber,
                ),
              ],
            ),

            Row(
              children: [
                buildMetricCard(
                  title: "Medium",
                  value: mediumImpact.toString(),
                  icon: Icons.eco,
                ),

                buildMetricCard(
                  title: "Low",
                  value: lowImpact.toString(),
                  icon: Icons.check_circle,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Recent Reports",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (reports.isEmpty)
              const Center(
                child: Text(
                  "No reports yet",
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),

            ...reports.map(buildReportCard),
          ],
        ),
      ),
    );
  }
}