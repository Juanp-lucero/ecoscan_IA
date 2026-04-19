import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng initialPosition = const LatLng(6.2442, -75.5812); // Medellín default

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  void loadLocation() async {
    final pos = await LocationService().getLocation();

    if (pos != null) {
      setState(() {
        initialPosition = LatLng(pos.latitude, pos.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 14,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}