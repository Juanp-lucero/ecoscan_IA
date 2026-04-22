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
  File? image;
  Map<String, dynamic>? result;
  bool isLoading = false;

  final picker = ImagePicker();

  // 📸 TOMAR FOTO
  Future<void> _takePhoto() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        result = null;
      });
    }
  }

  // 🤖 ANALIZAR + GUARDAR
  Future<void> _analyze() async {
    if (image == null) return;

    setState(() => isLoading = true);

    try {
      final aiResult = await AIService().analyzeImage(image!.path);

      // 🔥 GUARDAR EN SUPABASE
      await SupabaseService().insertReport(
        result: aiResult["tipo"] ?? "Unknown",
        imagePath: image!.path,
      );

      setState(() {
        result = aiResult;
      });
    } catch (e) {
      debugPrint("Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error analyzing image")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 📸 PREVIEW
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(15),
            ),
            child: image != null
                ? Image.file(image!, fit: BoxFit.cover)
                : const Center(child: Text("No image selected")),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: _takePhoto,
            icon: const Icon(Icons.camera_alt),
            label: const Text("Take Photo"),
          ),

          const SizedBox(height: 10),

          ElevatedButton.icon(
            onPressed: image != null ? _analyze : null,
            icon: const Icon(Icons.auto_awesome),
            label: const Text("Analyze with AI"),
          ),

          const SizedBox(height: 20),

          if (isLoading) const CircularProgressIndicator(),

          const SizedBox(height: 20),

          // 📊 RESULTADO
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
                  Text("Type: ${result!['tipo']}",
                      style: const TextStyle(color: Colors.white)),
                  Text("Impact: ${result!['impacto']}",
                      style: const TextStyle(color: Colors.white)),
                  Text("Description: ${result!['descripcion']}",
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}