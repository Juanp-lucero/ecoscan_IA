import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client =
      Supabase.instance.client;

  Future<void> insertReport({
    required String type,
    required String impact,
    required String description,
    required String recyclingRecommendation,
    required String toxicityLevel,
    required String ecoAction,
    double? latitude,
    double? longitude,
  }) async {
    try {
      await client.from('reports').insert({
        'type': type,
        'impact': impact,
        'description': description,
        'recycling_recommendation':
            recyclingRecommendation,
        'toxicity_level': toxicityLevel,
        'eco_action': ecoAction,
        'latitude': latitude,
        'longitude': longitude,
      });

      print("REPORT SAVED SUCCESSFULLY");
    } catch (e) {
      print("ERROR INSERTING REPORT:");
      print(e);

      rethrow;
    }
  }

  Future<void> deleteReport(
    dynamic id,
  ) async {
    try {
      final response = await client
          .from('reports')
          .delete()
          .eq('id', id)
          .select();

      print("DELETE RESPONSE:");
      print(response);

      if (response.isEmpty) {
        throw Exception(
          "No se eliminó ningún reporte",
        );
      }

      print("REPORT DELETED SUCCESSFULLY");
    } catch (e) {
      print("ERROR DELETING REPORT:");
      print(e);

      rethrow;
    }
  }

  Future<void> updateReport({
    required dynamic id,
    required String type,
    required String impact,
    required String description,
    required String toxicityLevel,
    required String recyclingRecommendation,
    required String ecoAction,
  }) async {
    try {
      await client.from('reports').update({
        'type': type,
        'impact': impact,
        'description': description,
        'toxicity_level': toxicityLevel,
        'recycling_recommendation':
            recyclingRecommendation,
        'eco_action': ecoAction,
      }).eq('id', id);

      print(
        "REPORT UPDATED SUCCESSFULLY",
      );
    } catch (e) {
      print("ERROR UPDATING REPORT:");
      print(e);

      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>>
      getReports() async {
    try {
      final response = await client
          .from('reports')
          .select()
          .order(
            'created_at',
            ascending: false,
          );

      print("REPORTS LOADED:");
      print(response);

      return List<Map<String, dynamic>>
          .from(response);
    } catch (e) {
      print("ERROR LOADING REPORTS:");
      print(e);

      return [];
    }
  }
}