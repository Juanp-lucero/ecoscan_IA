import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // 🔥 INSERTAR REPORTE
  Future<void> insertReport({
    required String zone,
    required String impact,
  }) async {
    await supabase.from('reports').insert({
      'zone': zone,
      'impact': impact,
    });
  }

  // 🔥 OBTENER REPORTES
  Future<List<Map<String, dynamic>>> getReports() async {
    final response = await supabase.from('reports').select();
    return List<Map<String, dynamic>>.from(response);
  }
}