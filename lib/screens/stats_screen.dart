import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/supabase_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int high = 0;
  int medium = 0;
  int low = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await SupabaseService().getReports();

    int h = 0, m = 0, l = 0;

    for (var r in data) {
      if (r['impact'] == "High environmental impact") h++;
      if (r['impact'] == "Medium impact") m++;
      if (r['impact'] == "Low impact") l++;
    }

    setState(() {
      high = h;
      medium = m;
      low = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: high.toDouble(),
                  color: Colors.red,
                  title: 'High',
                ),
                PieChartSectionData(
                  value: medium.toDouble(),
                  color: Colors.orange,
                  title: 'Medium',
                ),
                PieChartSectionData(
                  value: low.toDouble(),
                  color: Colors.green,
                  title: 'Low',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}