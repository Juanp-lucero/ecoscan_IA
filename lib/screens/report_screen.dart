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
          "Tipo: ${aiResult["tipo"]} | Impacto: ${aiResult["impacto"]}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF020617),
              Color(0xFF064E3B),
              Color(0xFF022C22),
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

                // 🔙 BOTÓN VOLVER
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 🌱 TÍTULO
                const Text(
                  "Nuevo Reporte",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Detecta contaminación con IA",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 25),

                // 📸 PREVIEW IMAGEN
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.greenAccent.withOpacity(0.3)),
                  ),
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(image!, fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image,
                                  color: Colors.white54, size: 50),
                              SizedBox(height: 10),
                              Text(
                                "No hay imagen",
                                style: TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                        ),
                ),

                const SizedBox(height: 25),

                // 📦 TARJETA BOTONES
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.greenAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [

                      // 📸 BOTÓN FOTO
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: pickImage,
                          icon: const Icon(Icons.camera_alt,
                              color: Colors.black),
                          label: const Text(
                            "Tomar Foto",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            padding:
                                const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // 🤖 BOTÓN IA
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: analizar,
                          icon: const Icon(Icons.auto_awesome,
                              color: Colors.greenAccent),
                          label: const Text(
                            "Analizar con IA",
                            style:
                                TextStyle(color: Colors.greenAccent),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Colors.greenAccent),
                            padding:
                                const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (loading)
                        const CircularProgressIndicator(),

                      const SizedBox(height: 10),

                      Text(
                        result,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                        ),
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