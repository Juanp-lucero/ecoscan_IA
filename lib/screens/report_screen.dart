import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/ai_service.dart';
import '../services/supabase_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  File? selectedImage;

  String? detectedType;
  String? impact;
  String? description;

  bool isLoading = false;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      selectedImage = File(pickedFile.path);

      detectedType = null;
      impact = null;
      description = null;
    });
  }

  Future<void> analyzeImage() async {
    if (selectedImage == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result = await AIService().analyzeImage(selectedImage!);

      await SupabaseService().insertReport(
        type: result.type,
        impact: result.impact,
        description: result.description,
      );

      setState(() {
        detectedType = result.type;
        impact = result.impact;
        description = result.description;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "AI Error: $error",
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildInfoCard({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF11212D),
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.greenAccent.withOpacity(0.25),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.08),
            blurRadius: 15,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111A),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [
            const SizedBox(height: 10),

            const Text(
              "AI Environmental Analysis",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Analyze environmental waste with artificial intelligence",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              height: 320,

              decoration: BoxDecoration(
                color: const Color(0xFF11212D),
                borderRadius: BorderRadius.circular(25),

                border: Border.all(
                  color: Colors.greenAccent.withOpacity(0.4),
                  width: 2,
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.15),
                    blurRadius: 25,
                  ),
                ],
              ),

              child: selectedImage == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.greenAccent,
                            size: 70,
                          ),

                          SizedBox(height: 15),

                          Text(
                            "No image selected",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 58,

              child: ElevatedButton.icon(
                onPressed: pickImage,

                icon: const Icon(Icons.camera_alt),

                label: const Text(
                  "Capture Image",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 58,

              child: ElevatedButton.icon(
                onPressed: isLoading ? null : analyzeImage,

                icon: const Icon(Icons.auto_awesome),

                label: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        "Analyze with AI",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1BE68C),
                  foregroundColor: Colors.black,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            if (detectedType != null) ...[
              buildInfoCard(
                title: "Detected Waste",
                value: detectedType!,
                valueColor: Colors.white,
              ),

              buildInfoCard(
                title: "Environmental Impact",
                value: impact!,
                valueColor: Colors.orangeAccent,
              ),

              buildInfoCard(
                title: "AI Description",
                value: description!,
                valueColor: Colors.white70,
              ),
            ],
          ],
        ),
      ),
    );
  }
}