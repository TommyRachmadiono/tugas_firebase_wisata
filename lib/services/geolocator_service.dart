import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Geolocator geolocator;
  Position currentPosition;
  var lat;
  var long;
  String currentAddress;

  initGeolocator() async {
    geolocator = Geolocator()..forceAndroidLocationManager;
  }

  Future getCurrentLocation() async {
    currentPosition = await geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    lat = currentPosition.latitude;
    long = currentPosition.longitude;
    print(currentPosition);
    return currentPosition;
  }

  Future getAddressFromLatLng() async {
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
      currentPosition.latitude,
      currentPosition.longitude,
    );
    Placemark place = p[0];

    currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
    print(currentAddress);
    return currentAddress;
  }
}
