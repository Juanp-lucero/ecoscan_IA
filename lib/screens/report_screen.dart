import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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

    setState(() {
      result = aiResult;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A0F1C),
              Color(0xFF0F1B2D),
              Color(0xFF00E676),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 🔙 Back
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  "Report Waste",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // 📸 Fake image preview
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: hasImage
                      ? const Center(
                          child: Icon(
                            Icons.image,
                            size: 80,
                            color: Colors.white54,
                          ),
                        )
                      : const Center(
                          child: Text(
                            "No image selected",
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                ),

                const SizedBox(height: 25),

                // 📸 Take photo button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _simulateTakePhoto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Take Photo",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 🤖 Analyze button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: hasImage ? _analyze : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text("Analyze with AI"),
                  ),
                ),

                const SizedBox(height: 25),

                if (loading)
                  const CircularProgressIndicator(color: Colors.greenAccent),

                if (result != null)
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
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
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}