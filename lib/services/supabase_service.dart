import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<void> saveReport({
    required File image,
    required double lat,
    required double lng,
    required String tipo,
    required String impacto,
  }) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    await supabase.storage.from('imagenes').upload(fileName, image);

    final imageUrl =
        supabase.storage.from('imagenes').getPublicUrl(fileName);

    await supabase.from('reportes').insert({
      "imagen_url": imageUrl,
      "latitud": lat,
      "longitud": lng,
      "tipo_residuo": tipo,
      "impacto": impacto,
      "fecha": DateTime.now().toIso8601String(),
    });
  }
}