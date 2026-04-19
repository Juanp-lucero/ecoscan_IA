import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';
import '../providers/pollution_provider.dart';
import '../models/report_model.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  bool hasImage = false;
  Map<String, dynamic>? result;
  bool loading = false;

  void _simulateTakePhoto() {
    setState(() {
      hasImage = true;
      result = null;
    });
  }

  Future<void> _analyze() async {
    setState(() => loading = true);

    final aiResult = await AIService().analyzeImage("fake_path");

    // 🔥 GUARDAR REPORTE (SIMULADO)
    ref.read(pollutionProvider.notifier).addReport(
          ReportModel(
            zone: "zone_1",
            impact: aiResult["impacto"],
            date: DateTime.now(),
          ),
        );

    setState(() {
      result = aiResult;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Waste")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.black12,
              child: hasImage
                  ? const Icon(Icons.image, size: 80)
                  : const Center(child: Text("No image")),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simulateTakePhoto,
              child: const Text("Take Photo"),
            ),
            ElevatedButton(
              onPressed: hasImage ? _analyze : null,
              child: const Text("Analyze with AI"),
            ),
            if (loading) const CircularProgressIndicator(),
            if (result != null)
              Column(
                children: [
                  Text("Type: ${result!['tipo']}"),
                  Text("Impact: ${result!['impacto']}"),
                  Text("Description: ${result!['descripcion']}"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}