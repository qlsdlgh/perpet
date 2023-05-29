import 'package:geolocator/geolocator.dart';

class MyLocation {
  late double latitude;
  late double longitude;

  Future<void> getMyCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print('Geolocator 연결 오류 : $e');
    }
  }
}
