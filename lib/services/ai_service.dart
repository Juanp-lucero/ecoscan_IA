import 'dart:io';

class AIService {
  Future<Map<String, dynamic>> analyzeImage(File image) async {
    await Future.delayed(const Duration(seconds: 2));

    return {
      "tipo": "Plástico",
      "impacto": "Alto",
    };
  }
}
