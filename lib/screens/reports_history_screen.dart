import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class ReportsHistoryScreen extends StatefulWidget {
  const ReportsHistoryScreen({super.key});

  @override
  State<ReportsHistoryScreen> createState() =>
      _ReportsHistoryScreenState();
}

class _ReportsHistoryScreenState
    extends State<ReportsHistoryScreen> {
  List<Map<String, dynamic>> reports = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadReports();
  }

  Future<void> loadReports() async {
    try {
      final data =
          await SupabaseService().getReports();

      setState(() {
        reports = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  Color getImpactColor(String impact) {
    final value = impact.toLowerCase();

    if (value.contains('high')) {
      return Colors.redAccent;
    }

    if (value.contains('medium')) {
      return Colors.orangeAccent;
    }

    return Colors.greenAccent;
  }

  IconData getImpactIcon(String impact) {
    final value = impact.toLowerCase();

    if (value.contains('high')) {
      return Icons.warning_rounded;
    }

    if (value.contains('medium')) {
      return Icons.info_rounded;
    }

    return Icons.eco_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF07111A),
        elevation: 0,

        title: const Text(
          "Reports History",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.greenAccent,
              ),
            )

          : reports.isEmpty
              ? const Center(
                  child: Text(
                    "No reports found",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                )

              : ListView.builder(
                  padding: const EdgeInsets.all(20),

                  itemCount: reports.length,

                  itemBuilder: (context, index) {
                    final report = reports[index];

                    final impact =
                        report['impact'] ?? '';

                    return Container(
                      margin:
                          const EdgeInsets.only(bottom: 18),

                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: const Color(0xFF11212D),

                        borderRadius:
                            BorderRadius.circular(22),

                        border: Border.all(
                          color: Colors.greenAccent
                              .withOpacity(0.15),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.2),

                            blurRadius: 10,
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Row(
                            children: [

                              Container(
                                padding:
                                    const EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                  color: getImpactColor(
                                    impact,
                                  ).withOpacity(0.15),

                                  borderRadius:
                                      BorderRadius.circular(
                                    14,
                                  ),
                                ),

                                child: Icon(
                                  getImpactIcon(impact),
                                  color:
                                      getImpactColor(impact),
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(
                                      report['type'] ??
                                          'Unknown',

                                      style:
                                          const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      impact,

                                      style: TextStyle(
                                        color:
                                            getImpactColor(
                                          impact,
                                        ),

                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          Container(
                            width: double.infinity,

                            padding:
                                const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withOpacity(
                                0.03,
                              ),

                              borderRadius:
                                  BorderRadius.circular(18),
                            ),

                            child: Text(
                              report['description'] ??
                                  '',

                              style: const TextStyle(
                                color: Colors.white70,
                                height: 1.5,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,

                            children: [

                              const Icon(
                                Icons.calendar_month,
                                color: Colors.white38,
                                size: 16,
                              ),

                              const SizedBox(width: 6),

                              Text(
                                report['created_at']
                                        ?.toString()
                                        .substring(0, 10) ??
                                    '',

                                style: const TextStyle(
                                  color: Colors.white38,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}