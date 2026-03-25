class Reporte {
  final String tipo;
  final String impacto;
  final double lat;
  final double lng;
  final String imagenUrl;

  Reporte({
    required this.tipo,
    required this.impacto,
    required this.lat,
    required this.lng,
    required this.imagenUrl,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      tipo: json['tipo_residuo'],
      impacto: json['impacto'],
      lat: json['latitud'],
      lng: json['longitud'],
      imagenUrl: json['imagen_url'],
    );
  }
}