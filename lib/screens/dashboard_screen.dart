import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/supabase_service.dart';
import '../utils/app_strings.dart';
import 'reports_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  List<Map<String, dynamic>> reports = [];

  bool isLoading = true;

  int totalReports = 0;
  int highImpact = 0;
  int mediumImpact = 0;
  int lowImpact = 0;

  double get totalImpact {
    return (
      highImpact +
      mediumImpact +
      lowImpact
    ).toDouble();
  }

  @override
  void initState() {
    super.initState();

    loadReports();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    loadReports();
  }

  Future<void> loadReports() async {
    setState(() {
      isLoading = true;
    });

    final data =
        await SupabaseService().getReports();

    int high = 0;
    int medium = 0;
    int low = 0;

    for (var report in data) {
      final impact =
          (report['impact'] ?? '')
              .toString()
              .toLowerCase();

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

  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,

        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: const Color(0xFF11212D),

            borderRadius:
                BorderRadius.circular(25),

            border: Border.all(
              color:
                  Colors.greenAccent.withOpacity(
                0.25,
              ),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent
                    .withOpacity(0.08),

                blurRadius: 20,
              ),
            ],
          ),

          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.greenAccent,
                size: 34,
              ),

              const SizedBox(height: 14),

              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLegend({
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,

          decoration: BoxDecoration(
            color: color,
            borderRadius:
                BorderRadius.circular(20),
          ),
        ),

        const SizedBox(width: 8),

        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget reportCard(
    Map<String, dynamic> report,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF11212D),

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color:
              Colors.greenAccent.withOpacity(
            0.2,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            report['type'] ?? 'Unknown',

            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            report['impact'] ?? '',

            style: const TextStyle(
              color: Colors.orangeAccent,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            report['description'] ?? '',

            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF07111A),

        body: Center(
          child: CircularProgressIndicator(
            color: Colors.greenAccent,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF07111A),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadReports,

          child: ListView(
            padding: const EdgeInsets.all(20),

            children: [
              Text(
                AppStrings.environmentalDashboard,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                AppStrings.dashboardSubtitle,

                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  statCard(
                    title: AppStrings.reports,
                    value:
                        totalReports.toString(),

                    icon: Icons.bar_chart,

                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const ReportsHistoryScreen(),
                        ),
                      );
                    },
                  ),

                  statCard(
                    title:
                        AppStrings.highImpact,

                    value:
                        highImpact.toString(),

                    icon: Icons
                        .warning_amber_rounded,
                  ),
                ],
              ),

              Row(
                children: [
                  statCard(
                    title: AppStrings.medium,

                    value:
                        mediumImpact.toString(),

                    icon: Icons.eco,
                  ),

                  statCard(
                    title: AppStrings.low,

                    value:
                        lowImpact.toString(),

                    icon: Icons.check_circle,
                  ),
                ],
              ),

              const SizedBox(height: 35),

              Text(
                AppStrings.impactDistribution,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                height: 280,
                padding:
                    const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color:
                      const Color(0xFF11212D),

                  borderRadius:
                      BorderRadius.circular(25),

                  border: Border.all(
                    color: Colors.greenAccent
                        .withOpacity(0.2),
                  ),
                ),

                child: Column(
                  children: [
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 55,

                          sections: [
                            PieChartSectionData(
                              value:
                                  highImpact.toDouble(),

                              color:
                                  Colors.redAccent,

                              radius: 60,

                              title:
                                  totalImpact == 0
                                      ? '0%'
                                      : '${((highImpact / totalImpact) * 100).toStringAsFixed(1)}%',

                              titleStyle:
                                  const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                            PieChartSectionData(
                              value:
                                  mediumImpact.toDouble(),

                              color:
                                  Colors.orangeAccent,

                              radius: 60,

                              title:
                                  totalImpact == 0
                                      ? '0%'
                                      : '${((mediumImpact / totalImpact) * 100).toStringAsFixed(1)}%',

                              titleStyle:
                                  const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                            PieChartSectionData(
                              value:
                                  lowImpact.toDouble(),

                              color:
                                  Colors.greenAccent,

                              radius: 60,

                              title:
                                  totalImpact == 0
                                      ? '0%'
                                      : '${((lowImpact / totalImpact) * 100).toStringAsFixed(1)}%',

                              titleStyle:
                                  const TextStyle(
                                color: Colors.black,
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceEvenly,

                      children: [
                        buildLegend(
                          color: Colors.redAccent,
                          text: AppStrings.high,
                        ),

                        buildLegend(
                          color:
                              Colors.orangeAccent,

                          text:
                              AppStrings.medium,
                        ),

                        buildLegend(
                          color:
                              Colors.greenAccent,

                          text: AppStrings.low,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              Text(
                AppStrings.recentReports,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              if (reports.isEmpty)
                Center(
                  child: Text(
                    AppStrings.noReports,

                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                    ),
                  ),
                ),

              ...reports.map(reportCard),
            ],
          ),
        ),
      ),
    );
  }
}