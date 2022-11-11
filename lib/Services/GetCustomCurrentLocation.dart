import 'package:geolocator/geolocator.dart';

// Future<Position>  getCustomCurrentLocation() async {
//   Position position = await GeolocatorPlatform.instance
//       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high,forceAndroidLocationManager: true);
//
//   return position;
// }
Future<Position> getCustomCurrentLocation() async {
  // Position position = await GeolocatorPlatform.instance
  //     .getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high,));
  Position position = await Geolocator.getCurrentPosition();
  return position;
}
