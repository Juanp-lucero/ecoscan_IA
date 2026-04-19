import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/pollution_provider.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pollution = ref.watch(pollutionProvider);

    final zone = "zone_1";
    final notifier = ref.read(pollutionProvider.notifier);

    final level = notifier.getZoneLevel(zone);
    final isCritical = notifier.isCriticalZone(zone);

    Color zoneColor;
    if (level == "high") {
      zoneColor = Colors.red;
    } else if (level == "medium") {
      zoneColor = Colors.orange;
    } else {
      zoneColor = Colors.green;
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(6.2442, -75.5812),
            zoom: 14,
          ),
        ),

        // 🔥 ALERTA
        if (isCritical)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "⚠ High risk pollution zone",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),

        // 🔥 INDICADOR DE NIVEL
        Positioned(
          bottom: 30,
          left: 20,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: zoneColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Zone Level: $level",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}