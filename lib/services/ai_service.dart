import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AIResult {
  final String type;
  final String impact;
  final String description;

  AIResult({
    required this.type,
    required this.impact,
    required this.description,
  });
}

class AIService {
  // 🔑 TU API KEY (ya incluida)
  final String apiKey = "AIzaSyDHcEwKpqXq6d3zreo404CvkpktRHvBBEg";

  Future<AIResult> analyzeImage(File image) async {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse(
          "https://vision.googleapis.com/v1/images:annotate?key=$apiKey"),
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

    if (response.statusCode != 200) {
      throw Exception("Error IA: ${response.body}");
    }

    final data = jsonDecode(response.body);

    final label =
        data["responses"][0]["labelAnnotations"][0]["description"];

    return _mapResult(label);
  }

  // 🧠 Lógica inteligente
  AIResult _mapResult(String label) {
    final l = label.toLowerCase();

    if (l.contains("plastic")) {
      return AIResult(
        type: "Plastic",
        impact: "High environmental impact",
        description:
            "Plastic pollutes oceans and takes hundreds of years to decompose.",
      );
    }

    if (l.contains("bottle")) {
      return AIResult(
        type: "Bottle",
        impact: "Medium impact",
        description:
            "Bottles can be recycled but often end up contaminating ecosystems.",
      );
    }

    if (l.contains("paper")) {
      return AIResult(
        type: "Paper",
        impact: "Low impact",
        description:
            "Paper is biodegradable but contributes to deforestation if not recycled.",
      );
    }

    if (l.contains("food") || l.contains("organic")) {
      return AIResult(
        type: "Organic waste",
        impact: "Low impact",
        description:
            "Organic waste decomposes naturally but can produce methane.",
      );
    }

    if (l.contains("metal") || l.contains("can")) {
      return AIResult(
        type: "Metal",
        impact: "Medium impact",
        description:
            "Metal can be recycled but mining and waste affect ecosystems.",
      );
    }

    return AIResult(
      type: label,
      impact: "Medium impact",
      description:
          "This material may affect the environment depending on disposal.",
    );
  }
}