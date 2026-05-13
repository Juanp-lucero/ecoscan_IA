import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class AIResult {
  final String type;
  final String impact;
  final String description;
  final String recyclingRecommendation;
  final String toxicityLevel;
  final String ecoAction;

  AIResult({
    required this.type,
    required this.impact,
    required this.description,
    required this.recyclingRecommendation,
    required this.toxicityLevel,
    required this.ecoAction,
  });
}

class AIService {
  final String apiKey = "AIzaSyDHcEwKpqXq6d3zreo404CvkpktRHvBBEg";

  Future<AIResult> analyzeImage(File image) async {
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse(
        "https://vision.googleapis.com/v1/images:annotate?key=$apiKey",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "requests": [
          {
            "image": {
              "content": base64Image,
            },
            "features": [
              {
                "type": "LABEL_DETECTION",
                "maxResults": 5,
              }
            ],
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Error IA: ${response.body}");
    }

    final data = jsonDecode(response.body);

    final annotations =
        data["responses"][0]["labelAnnotations"];

    if (annotations == null || annotations.isEmpty) {
      return _mapResult("unknown");
    }

    final label =
        annotations[0]["description"].toString();

    return _mapResult(label);
  }

  AIResult _mapResult(String label) {
    final value = label.toLowerCase();

    if (value.contains("plastic") ||
        value.contains("polyester") ||
        value.contains("packaging")) {
      return AIResult(
        type: "Plastic",
        impact: "High environmental impact",
        description:
            "Plastic can pollute rivers, oceans, and soil. It may take hundreds of years to decompose.",
        recyclingRecommendation:
            "Clean the plastic item and place it in a plastic recycling container if local recycling is available.",
        toxicityLevel:
            "Medium toxicity",
        ecoAction:
            "Reduce single-use plastics and reuse containers whenever possible.",
      );
    }

    if (value.contains("bottle")) {
      return AIResult(
        type: "Bottle",
        impact: "Medium impact",
        description:
            "Bottles can be recyclable, but when discarded incorrectly they can contaminate ecosystems.",
        recyclingRecommendation:
            "Empty and rinse the bottle before placing it in the appropriate recycling bin.",
        toxicityLevel:
            "Low to medium toxicity",
        ecoAction:
            "Use reusable bottles to reduce waste generation.",
      );
    }

    if (value.contains("paper") ||
        value.contains("cardboard") ||
        value.contains("carton")) {
      return AIResult(
        type: "Paper or cardboard",
        impact: "Low impact",
        description:
            "Paper and cardboard are biodegradable but can contribute to deforestation if not recycled.",
        recyclingRecommendation:
            "Keep the paper clean and dry, then place it in a paper recycling bin.",
        toxicityLevel:
            "Low toxicity",
        ecoAction:
            "Reuse paper when possible and avoid unnecessary printing.",
      );
    }

    if (value.contains("food") ||
        value.contains("organic") ||
        value.contains("fruit") ||
        value.contains("vegetable")) {
      return AIResult(
        type: "Organic waste",
        impact: "Low impact",
        description:
            "Organic waste decomposes naturally, but in landfills it can produce methane gas.",
        recyclingRecommendation:
            "Separate organic waste and use it for composting when possible.",
        toxicityLevel:
            "Low toxicity",
        ecoAction:
            "Create compost or use organic waste collection services.",
      );
    }

    if (value.contains("metal") ||
        value.contains("can") ||
        value.contains("aluminum") ||
        value.contains("steel")) {
      return AIResult(
        type: "Metal",
        impact: "Medium impact",
        description:
            "Metal is recyclable, but mining and improper disposal can damage ecosystems.",
        recyclingRecommendation:
            "Rinse the metal item and place it in a metal recycling container.",
        toxicityLevel:
            "Low to medium toxicity",
        ecoAction:
            "Recycle cans and avoid throwing metal waste into general trash.",
      );
    }

    if (value.contains("glass")) {
      return AIResult(
        type: "Glass",
        impact: "Medium impact",
        description:
            "Glass is highly recyclable but can be dangerous if broken and abandoned.",
        recyclingRecommendation:
            "Place glass in a glass recycling container. Handle broken glass carefully.",
        toxicityLevel:
            "Low toxicity",
        ecoAction:
            "Reuse glass containers and recycle them properly.",
      );
    }

    if (value.contains("battery") ||
        value.contains("electronics") ||
        value.contains("electronic") ||
        value.contains("device") ||
        value.contains("computer") ||
        value.contains("phone")) {
      return AIResult(
        type: "Electronic waste",
        impact: "High environmental impact",
        description:
            "Electronic waste may contain heavy metals and toxic components that can contaminate soil and water.",
        recyclingRecommendation:
            "Take electronic waste to an authorized e-waste collection point.",
        toxicityLevel:
            "High toxicity",
        ecoAction:
            "Do not throw electronics in regular trash. Use certified recycling programs.",
      );
    }

    if (value.contains("textile") ||
        value.contains("clothing") ||
        value.contains("fabric")) {
      return AIResult(
        type: "Textile waste",
        impact: "Medium impact",
        description:
            "Textile waste can take years to degrade and may release microfibers into the environment.",
        recyclingRecommendation:
            "Donate, reuse, or take textiles to a textile recycling program.",
        toxicityLevel:
            "Low to medium toxicity",
        ecoAction:
            "Repair and reuse clothing before discarding it.",
      );
    }

    return AIResult(
      type: label,
      impact: "Medium impact",
      description:
          "This material may affect the environment depending on how it is disposed of.",
      recyclingRecommendation:
          "Separate the item from general waste and check local recycling guidelines.",
      toxicityLevel:
          "Unknown toxicity",
      ecoAction:
          "Avoid dumping this item in public spaces and dispose of it responsibly.",
    );
  }
}