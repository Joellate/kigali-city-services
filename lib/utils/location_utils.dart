import 'package:geolocator/geolocator.dart';

String formatDistance(double startLat, double startLon, double endLat, double endLon) {
  final meters = Geolocator.distanceBetween(startLat, startLon, endLat, endLon);
  if (meters < 1000) {
    return '${meters.toStringAsFixed(0)} m';
  }
  return '${(meters / 1000).toStringAsFixed(1)} km';
}
