import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InitialLocation {
  double latitude, longitude, destinationLatitude, destinationLongitude;
  List<Placemark> placeMark;

  Future getCurrentLocation() async {
    try {
      Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high, locationPermissionLevel: GeolocationPermission.locationWhenInUse);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (error) {
      print(error);
    }
  }

  Future getLastKnownLocation() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
  }

  Future<void> getLocationFromAddress(String text) async {
    try {
      placeMark = await Geolocator().placemarkFromAddress('$text');
      destinationLatitude = placeMark[0].position.latitude;
      destinationLongitude = placeMark[0].position.longitude;
    } catch (error) {
      print(error);
    }
  }

  Future<void> onLocationChanged() async {
    var locationOptions =
    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    // ignore: cancel_subscriptions
    StreamSubscription<Position> positionStream = Geolocator()
        .getPositionStream(locationOptions)
        .listen((Position position) {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }
}

class GoogleMapsServices{
  static final String apiKey = 'AIzaSyDidIku0MTD7XtJwniNH2qmQY09DLqSoKg';
    Future<String> getRouteCoordinates(LatLng l1, LatLng l2)async{
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }
}