import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }
}