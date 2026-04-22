import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // 🔥 INSERTAR REPORTE
  Future<void> insertReport({
    required String result,
    required String imagePath,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    await supabase.from('reports').insert({
      'user_id': user.id,
      'result': result,
      'image_url': imagePath,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // 📊 OBTENER REPORTES DEL USUARIO
  Future<List<Map<String, dynamic>>> getReports() async {
    final user = supabase.auth.currentUser;

    if (user == null) return [];

    final data = await supabase
        .from('reports')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }
}