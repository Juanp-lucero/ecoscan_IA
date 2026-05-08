import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  Future<void> insertReport({
    required String type,
    required String impact,
    required String description,
  }) async {
    try {
      await client.from('reports').insert({
        'type': type,
        'impact': impact,
        'description': description,
      });

      print("REPORT SAVED SUCCESSFULLY");
    } catch (e) {
      print("ERROR INSERTING REPORT:");
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    try {
      final response = await client
          .from('reports')
          .select()
          .order('created_at', ascending: false);

      print("REPORTS LOADED:");
      print(response);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("ERROR LOADING REPORTS:");
      print(e);

      return [];
    }
  }
}