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

  List<Map<String, dynamic>> filteredReports = [];

  bool isLoading = true;

  final TextEditingController searchController =
      TextEditingController();

  String selectedImpact = 'All';

  String selectedOrder = 'Latest';

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

        filteredReports = data;

        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  void filterReports() {
    List<Map<String, dynamic>> tempReports =
        List.from(reports);

    final query =
        searchController.text.toLowerCase();

    if (query.isNotEmpty) {
      tempReports = tempReports.where((report) {

        final type =
            (report['type'] ?? '')
                .toString()
                .toLowerCase();

        final impact =
            (report['impact'] ?? '')
                .toString()
                .toLowerCase();

        final description =
            (report['description'] ?? '')
                .toString()
                .toLowerCase();

        return type.contains(query) ||
            impact.contains(query) ||
            description.contains(query);

      }).toList();
    }

    if (selectedImpact != 'All') {
      tempReports = tempReports.where((report) {

        final impact =
            (report['impact'] ?? '')
                .toString()
                .toLowerCase();

        return impact.contains(
          selectedImpact.toLowerCase(),
        );

      }).toList();
    }

    tempReports.sort((a, b) {

      final dateA =
          DateTime.tryParse(
            a['created_at'] ?? '',
          ) ??
          DateTime.now();

      final dateB =
          DateTime.tryParse(
            b['created_at'] ?? '',
          ) ??
          DateTime.now();

      if (selectedOrder == 'Latest') {
        return dateB.compareTo(dateA);
      }

      return dateA.compareTo(dateB);
    });

    setState(() {
      filteredReports = tempReports;
    });
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

          : Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [

                      TextField(
                        controller: searchController,

                        onChanged: (value) {
                          filterReports();
                        },

                        style: const TextStyle(
                          color: Colors.white,
                        ),

                        decoration: InputDecoration(
                          hintText:
                              "Search reports...",

                          hintStyle:
                              const TextStyle(
                            color: Colors.white38,
                          ),

                          prefixIcon: const Icon(
                            Icons.search,
                            color:
                                Colors.greenAccent,
                          ),

                          filled: true,

                          fillColor:
                              const Color(0xFF11212D),

                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),

                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [

                          Expanded(
                            child:
                                DropdownButtonFormField<
                                    String>(
                              value:
                                  selectedImpact,

                              dropdownColor:
                                  const Color(
                                0xFF11212D,
                              ),

                              style:
                                  const TextStyle(
                                color: Colors.white,
                              ),

                              decoration:
                                  InputDecoration(
                                filled: true,

                                fillColor:
                                    const Color(
                                  0xFF11212D,
                                ),

                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    18,
                                  ),

                                  borderSide:
                                      BorderSide
                                          .none,
                                ),
                              ),

                              items: const [

                                DropdownMenuItem(
                                  value: 'All',
                                  child: Text(
                                    "All Impacts",
                                  ),
                                ),

                                DropdownMenuItem(
                                  value: 'High',
                                  child: Text(
                                    "High",
                                  ),
                                ),

                                DropdownMenuItem(
                                  value: 'Medium',
                                  child: Text(
                                    "Medium",
                                  ),
                                ),

                                DropdownMenuItem(
                                  value: 'Low',
                                  child: Text(
                                    "Low",
                                  ),
                                ),
                              ],

                              onChanged: (value) {
                                selectedImpact =
                                    value!;

                                filterReports();
                              },
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child:
                                DropdownButtonFormField<
                                    String>(
                              value:
                                  selectedOrder,

                              dropdownColor:
                                  const Color(
                                0xFF11212D,
                              ),

                              style:
                                  const TextStyle(
                                color: Colors.white,
                              ),

                              decoration:
                                  InputDecoration(
                                filled: true,

                                fillColor:
                                    const Color(
                                  0xFF11212D,
                                ),

                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    18,
                                  ),

                                  borderSide:
                                      BorderSide
                                          .none,
                                ),
                              ),

                              items: const [

                                DropdownMenuItem(
                                  value: 'Latest',
                                  child: Text(
                                    "Latest",
                                  ),
                                ),

                                DropdownMenuItem(
                                  value: 'Oldest',
                                  child: Text(
                                    "Oldest",
                                  ),
                                ),
                              ],

                              onChanged: (value) {
                                selectedOrder =
                                    value!;

                                filterReports();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: filteredReports.isEmpty
                      ? const Center(
                          child: Text(
                            "No reports found",
                            style: TextStyle(
                              color:
                                  Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                        )

                      : ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),

                          itemCount:
                              filteredReports.length,

                          itemBuilder:
                              (context, index) {

                            final report =
                                filteredReports[
                                    index];

                            final impact =
                                report['impact'] ??
                                    '';

                            return Container(
                              margin:
                                  const EdgeInsets.only(
                                bottom: 18,
                              ),

                              padding:
                                  const EdgeInsets.all(
                                18,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: const Color(
                                  0xFF11212D,
                                ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  22,
                                ),

                                border: Border.all(
                                  color:
                                      Colors.greenAccent
                                          .withOpacity(
                                    0.15,
                                  ),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors
                                        .black
                                        .withOpacity(
                                      0.2,
                                    ),

                                    blurRadius: 10,
                                  ),
                                ],
                              ),

                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Row(
                                    children: [

                                      Container(
                                        padding:
                                            const EdgeInsets
                                                .all(
                                          10,
                                        ),

                                        decoration:
                                            BoxDecoration(
                                          color:
                                              getImpactColor(
                                            impact,
                                          ).withOpacity(
                                            0.15,
                                          ),

                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            14,
                                          ),
                                        ),

                                        child: Icon(
                                          getImpactIcon(
                                            impact,
                                          ),

                                          color:
                                              getImpactColor(
                                            impact,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 14,
                                      ),

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
                                                color:
                                                    Colors.white,

                                                fontSize:
                                                    18,

                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 4,
                                            ),

                                            Text(
                                              impact,

                                              style:
                                                  TextStyle(
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

                                  const SizedBox(
                                    height: 18,
                                  ),

                                  Container(
                                    width:
                                        double.infinity,

                                    padding:
                                        const EdgeInsets
                                            .all(
                                      16,
                                    ),

                                    decoration:
                                        BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(
                                        0.03,
                                      ),

                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        18,
                                      ),
                                    ),

                                    child: Text(
                                      report[
                                              'description'] ??
                                          '',

                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white70,

                                        height: 1.5,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 14,
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .end,

                                    children: [

                                      const Icon(
                                        Icons
                                            .calendar_month,

                                        color:
                                            Colors.white38,

                                        size: 16,
                                      ),

                                      const SizedBox(
                                        width: 6,
                                      ),

                                      Text(
                                        report['created_at']
                                                ?.toString()
                                                .substring(
                                                  0,
                                                  10,
                                                ) ??
                                            '',

                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white38,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}