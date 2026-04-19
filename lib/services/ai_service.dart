class AIService {
  Future<Map<String, dynamic>> analyzeImage(String path) async {
    await Future.delayed(const Duration(seconds: 2));

    return {
      "tipo": "Plástico",
      "impacto": "Alto",
      "descripcion": "Residuos plásticos detectados"
    };
  }
}