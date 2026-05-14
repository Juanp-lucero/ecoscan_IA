import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class ReportEditScreen extends StatefulWidget {
  final Map<String, dynamic> report;

  const ReportEditScreen({
    super.key,
    required this.report,
  });

  @override
  State<ReportEditScreen> createState() =>
      _ReportEditScreenState();
}

class _ReportEditScreenState
    extends State<ReportEditScreen> {
  late TextEditingController typeController;

  late TextEditingController impactController;

  late TextEditingController
      descriptionController;

  late TextEditingController
      toxicityController;

  late TextEditingController
      recyclingController;

  late TextEditingController
      ecoActionController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    typeController = TextEditingController(
      text:
          widget.report['type']?.toString() ??
          '',
    );

    impactController =
        TextEditingController(
      text:
          widget.report['impact']
              ?.toString() ??
          '',
    );

    descriptionController =
        TextEditingController(
      text:
          widget.report['description']
              ?.toString() ??
          '',
    );

    toxicityController =
        TextEditingController(
      text:
          widget.report['toxicity_level']
              ?.toString() ??
          '',
    );

    recyclingController =
        TextEditingController(
      text: widget
              .report[
                  'recycling_recommendation']
              ?.toString() ??
          '',
    );

    ecoActionController =
        TextEditingController(
      text:
          widget.report['eco_action']
              ?.toString() ??
          '',
    );
  }

  @override
  void dispose() {
    typeController.dispose();

    impactController.dispose();

    descriptionController.dispose();

    toxicityController.dispose();

    recyclingController.dispose();

    ecoActionController.dispose();

    super.dispose();
  }

  InputDecoration buildDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,

      labelStyle: const TextStyle(
        color: Colors.white70,
      ),

      prefixIcon: Icon(
        icon,
        color: Colors.greenAccent,
      ),

      filled: true,

      fillColor: const Color(
        0xFF11212D,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: const BorderSide(
          color: Colors.greenAccent,
        ),
      ),
    );
  }

  Future<void> updateReport() async {
    setState(() {
      isLoading = true;
    });

    try {
      await SupabaseService().updateReport(
        id: widget.report['id'],

        type: typeController.text.trim(),

        impact:
            impactController.text.trim(),

        description:
            descriptionController.text.trim(),

        toxicityLevel:
            toxicityController.text.trim(),

        recyclingRecommendation:
            recyclingController.text.trim(),

        ecoAction:
            ecoActionController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Report updated successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
              Colors.redAccent,

          content: Text(
            'Error updating report: $e',
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF07111A),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF07111A),

        elevation: 0,

        title: const Text(
          'Edit Report',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.greenAccent,
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          TextField(
            controller: typeController,

            style: const TextStyle(
              color: Colors.white,
            ),

            decoration: buildDecoration(
              'Type',
              Icons.category_rounded,
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: impactController,

            style: const TextStyle(
              color: Colors.white,
            ),

            decoration: buildDecoration(
              'Impact',
              Icons.warning_rounded,
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller:
                descriptionController,

            maxLines: 4,

            style: const TextStyle(
              color: Colors.white,
            ),

            decoration: buildDecoration(
              'Description',
              Icons.description_rounded,
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller:
                toxicityController,

            style: const TextStyle(
              color: Colors.white,
            ),

            decoration: buildDecoration(
              'Toxicity',
              Icons.dangerous_rounded,
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller:
                recyclingController,

            maxLines: 3,

            style: const TextStyle(
              color: Colors.white,
            ),

            decoration: buildDecoration(
              'Recycling recommendation',
              Icons.recycling_rounded,
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller:
                ecoActionController,

            maxLines: 3,

            style: const TextStyle(
              color: Colors.white,
            ),

            decoration: buildDecoration(
              'Eco action',
              Icons.task_alt_rounded,
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 58,

            child: ElevatedButton.icon(
              onPressed:
                  isLoading
                      ? null
                      : updateReport,

              icon: const Icon(
                Icons.save_rounded,
              ),

              label: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.black,
                    )
                  : const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.greenAccent,

                foregroundColor:
                    Colors.black,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}