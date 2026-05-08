import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  Future<void> insertReport({
    required String type,
    required String impact,
    required String description,
  }) async {
    await client.from('reports').insert({
      'type': type,
      'impact': impact,
      'description': description,
    });
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final response = await client
        .from('reports')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}