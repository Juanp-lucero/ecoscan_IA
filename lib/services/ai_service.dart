import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AIService {
  final String apiKey = "AIzaSyDHcEwKpqXq6d3zreo404CvkpktRHvBBEg";

  Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    try {
      final bytes = File(imagePath).readAsBytesSync();
      final base64Image = base64Encode(bytes);

      final url =
          "https://vision.googleapis.com/v1/images:annotate?key=$apiKey";

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "requests": [
            {
              "image": {"content": base64Image},
              "features": [
                {"type": "LABEL_DETECTION", "maxResults": 5}
              ]
            }
          ]
        }),
      );

      final data = jsonDecode(response.body);

      final labels =
          data["responses"][0]["labelAnnotations"] ?? [];

      if (labels.isEmpty) {
        return {
          "tipo": "Desconocido",
          "impacto": "medio",
          "descripcion": "No se pudo detectar claramente"
        };
      }

      final mainLabel = labels[0]["description"];

      return {
        "tipo": mainLabel,
        "impacto": _calculateImpact(mainLabel),
        "descripcion": "Detectado: $mainLabel"
      };
    } catch (e) {
      return {
        "tipo": "Error",
        "impacto": "medio",
        "descripcion": "Error al analizar imagen"
      };
    }
  }

  String _calculateImpact(String label) {
    final lower = label.toLowerCase();

    if (lower.contains("plastic") ||
        lower.contains("garbage") ||
        lower.contains("waste")) {
      return "alto";
    } else if (lower.contains("food") ||
        lower.contains("organic")) {
      return "medio";
    } else {
      return "bajo";
    }
  }
}