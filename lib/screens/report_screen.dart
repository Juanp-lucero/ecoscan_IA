import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';
import '../services/supabase_service.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  bool hasImage = false;
  Map<String, dynamic>? result;
  bool isLoading = false;

  // 📸 Simular tomar foto
  void _takePhoto() {
    setState(() {
      hasImage = true;
      result = null;
    });
  }

  // 🤖 Analizar con IA + guardar en Supabase
  Future<void> _analyzeWithAI() async {
    if (!hasImage) return;

    setState(() => isLoading = true);

    try {
      // IA simulada
      final aiResult = await AIService().analyzeImage("fake_path");

      // 🔥 Guardar en Supabase
      await SupabaseService().insertReport(
        zone: "zone_1",
        impact: aiResult["impacto"],
      );

      setState(() {
        result = aiResult;
      });
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving report")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Waste"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 📸 PREVIEW
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(15),
              ),
              child: hasImage
                  ? const Icon(Icons.image, size: 80)
                  : const Center(
                      child: Text(
                        "No image selected",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),

            const SizedBox(height: 30),

            // 📸 BOTÓN FOTO
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Take Photo"),
              ),
            ),

            const SizedBox(height: 10),

            // 🤖 BOTÓN IA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: hasImage ? _analyzeWithAI : null,
                icon: const Icon(Icons.auto_awesome),
                label: const Text("Analyze with AI"),
              ),
            ),

            const SizedBox(height: 20),

            // ⏳ LOADING
            if (isLoading) const CircularProgressIndicator(),

            const SizedBox(height: 20),

            // 📊 RESULTADO IA
            if (result != null)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type: ${result!['tipo']}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Impact: ${result!['impacto']}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Description: ${result!['descripcion']}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}