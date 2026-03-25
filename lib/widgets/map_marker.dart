import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker buildMarker(double lat, double lng) {
  return Marker(
    markerId: MarkerId('$lat$lng'),
    position: LatLng(lat, lng),
  );
}