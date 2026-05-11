import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/app_strings.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentPosition = const LatLng(
    6.2442,
    -75.5812,
  );

  bool isLoading = true;

  Set<Marker> get markers => {
        Marker(
          markerId: const MarkerId('zone1'),

          position: const LatLng(
            6.2500,
            -75.5700,
          ),

          infoWindow: InfoWindow(
            title: AppStrings.highPollutionArea,
          ),
        ),

        Marker(
          markerId: const MarkerId('zone2'),

          position: const LatLng(
            6.2400,
            -75.5900,
          ),

          infoWindow: InfoWindow(
            title: AppStrings.plasticWasteDetected,
          ),
        ),
      };

  @override
  void initState() {
    super.initState();

    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        isLoading = false;
      });

      return;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission ==
        LocationPermission.deniedForever) {
      setState(() {
        isLoading = false;
      });

      return;
    }

    final position =
        await Geolocator.getCurrentPosition();

    setState(() {
      currentPosition = LatLng(
        position.latitude,
        position.longitude,
      );

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.greenAccent,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF07111A),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(
              target: currentPosition,
              zoom: 14,
            ),

            markers: markers,

            myLocationEnabled: true,
            myLocationButtonEnabled: true,

            zoomControlsEnabled: false,
          ),

          Positioned(
            top: 20,
            left: 20,
            right: 20,

            child: Container(
              padding:
                  const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color:
                    const Color(0xFF11212D),

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),

                border: Border.all(
                  color: Colors.greenAccent
                      .withOpacity(0.3),
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    AppStrings.environmentalHotspots,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    AppStrings.hotspotDescription,

                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}