import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ai_service.dart';
import '../services/location_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  File? image;
  String result = "";
  bool loading = false;

  Future<void> pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        image = File(picked.path);
        result = "";
      });
    }
  }

  Future<void> analizar() async {
    if (image == null) return;

    setState(() {
      loading = true;
      result = "";
    });

    final aiResult = await AIService().analyzeImage(image!);
    await LocationService().getLocation();

    setState(() {
      loading = false;
      result =
          "Tipo: ${aiResult["tipo"]} - Impacto: ${aiResult["impacto"]}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo Reporte 📸"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(15),
              ),
              child: image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(image!, fit: BoxFit.cover),
                    )
                  : const Center(child: Text("No hay imagen")),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Tomar Foto"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: analizar,
              child: const Text("Analizar con IA"),
            ),

            const SizedBox(height: 20),

            if (loading)
              const CircularProgressIndicator(),

            const SizedBox(height: 10),

            Text(
              result,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}