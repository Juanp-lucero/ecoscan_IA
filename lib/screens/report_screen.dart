import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import '../services/ai_service.dart';
import '../services/supabase_service.dart';
import '../utils/app_strings.dart';

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
  String? recyclingRecommendation;
  String? toxicityLevel;
  String? ecoAction;

  bool isLoading = false;

  double? latitude;
  double? longitude;

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
      recyclingRecommendation = null;
      toxicityLevel = null;
      ecoAction = null;
    });
  }

  Future<void> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();

    latitude = position.latitude;
    longitude = position.longitude;
  }

  Future<void> analyzeImage() async {
    if (selectedImage == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result = await AIService().analyzeImage(selectedImage!);

      setState(() {
        detectedType = result.type;
        impact = result.impact;
        description = result.description;
        recyclingRecommendation = result.recyclingRecommendation;
        toxicityLevel = result.toxicityLevel;
        ecoAction = result.ecoAction;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("AI Error: $error"),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveReport() async {
    if (detectedType == null ||
        impact == null ||
        description == null ||
        recyclingRecommendation == null ||
        toxicityLevel == null ||
        ecoAction == null) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await getCurrentLocation();

      await SupabaseService().insertReport(
        type: detectedType!,
        impact: impact!,
        description: description!,
        recyclingRecommendation: recyclingRecommendation!,
        toxicityLevel: toxicityLevel!,
        ecoAction: ecoAction!,
        latitude: latitude,
        longitude: longitude,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(AppStrings.reportSaved),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error guardando reporte: $e"),
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

            Text(
              AppStrings.aiEnvironmentalAnalysis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              AppStrings.analyzeEnvironmentalWaste,
              style: const TextStyle(
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
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            color: Colors.greenAccent,
                            size: 70,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            AppStrings.noImageSelected,
                            style: const TextStyle(
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
                label: Text(
                  AppStrings.captureImage,
                  style: const TextStyle(
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
                    : Text(
                        AppStrings.analyze,
                        style: const TextStyle(
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

            const SizedBox(height: 20),

            if (detectedType != null)
              SizedBox(
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : saveReport,
                  icon: const Icon(Icons.save),
                  label: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          AppStrings.saveReport,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
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
                title: AppStrings.detectedWaste,
                value: detectedType!,
                valueColor: Colors.white,
              ),
              buildInfoCard(
                title: AppStrings.environmentalImpact,
                value: impact!,
                valueColor: Colors.orangeAccent,
              ),
              buildInfoCard(
                title: AppStrings.aiDescription,
                value: description!,
                valueColor: Colors.white70,
              ),
              buildInfoCard(
                title: "Recycling recommendation",
                value: recyclingRecommendation!,
                valueColor: Colors.greenAccent,
              ),
              buildInfoCard(
                title: "Toxicity level",
                value: toxicityLevel!,
                valueColor: Colors.redAccent,
              ),
              buildInfoCard(
                title: "Suggested eco action",
                value: ecoAction!,
                valueColor: Colors.lightBlueAccent,
              ),
            ],
          ],
        ),
      ),
    );
  }
}