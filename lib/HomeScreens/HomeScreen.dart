import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetchride/HomeScreens/location.dart';
import 'package:fetchride/components.dart';
import 'package:fetchride/drawer_screen/drawer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({@required this.email, @required this.displayName, @required this.phoneNumber});
  final String email, displayName, phoneNumber;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  InitialLocation _initialLocation = InitialLocation();
  GoogleMapController mapController;
  double latitude, longitude;
  Firestore _firestore = Firestore.instance;
  String searchTextInput;
  Set<Marker> _markers = {};
  Set<Polyline> _polyLines = {};

  @override
  void initState() {
    super.initState();
    //_initialLocation.onLocationChanged();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
  Future<void> _addMarker(LatLng location, String address) async {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(latitude.toString()),
          position: location,
          infoWindow: InfoWindow(title: address, snippet: "go here"),
          icon: BitmapDescriptor.defaultMarker));
    });
  }
  Future<void> _currentLocation() async {
    try {
      _initialLocation.getCurrentLocation();
      setState(() {
        if (_initialLocation.latitude != null && _initialLocation.longitude != null) {
          latitude = _initialLocation.latitude;
          longitude = _initialLocation.longitude;
        }
      });
    } catch (error) {
      Components().neverSatisfied('$error', null, context);
    }
    if (latitude != null && longitude != null) {
      if (widget.email == null) {
        if (widget.phoneNumber != null) {
          _firestore.collection('users').document('${widget.phoneNumber}').updateData({
            'latitude': latitude,
            'longitude': longitude,
          });
        }
      }
      else {
        _firestore.collection('users').document('${widget.email}').updateData({
          'latitude': latitude,
          'longitude': longitude,
        });
      }

      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(latitude, longitude),
          zoom: 15.0,
        ),
      ));
    }
    else {
      //Components().neverSatisfied('Unable to locate you...', null, context);
    }
  }
  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(latitude.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black));
  }
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black, size: 30.0),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(22.142, 84.323),
              zoom: 1
            ),
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            markers: _markers,
            polylines: _polyLines,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            trafficEnabled: true,
            onCameraMove: (position) {
              setState(() {});
            },
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 2.5,
            left: MediaQuery.of(context).size.width * 0.78,
            child: OnscreenButtons(
              alignment: Alignment.centerRight,
              icon: Icon(Icons.gps_fixed),
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              onPressed: () => _currentLocation(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.8,
              decoration: BoxDecoration(
                color: Colors.transparent.withOpacity(0.9),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        widget.displayName != null
                            ? 'Welcome, ${widget.displayName}'
                            : 'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 17.0,
                          fontFamily: 'Montserrat',
                        )),
                    Flexible(child: SizedBox(height: 10.0)),
                    Container(height: 1.0, color: Colors.white),
                    Flexible(child: SizedBox(height: 20.0)),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0, left: 10.0),
                      child: TextField(
                        enabled: true,
                        enableInteractiveSelection: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'From your current location',
                          hintStyle: TextStyle(color: Colors.black),
                          contentPadding: EdgeInsets.only(left: 10.0),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          prefixIcon: Icon(FontAwesomeIcons.searchLocation,
                              color: Colors.white, size: 18.0),
                        ),
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Montserrat'),
                        onSubmitted: (value) async {
                          List<Placemark> placemark =
                              await Geolocator().placemarkFromAddress(value);
                          setState(() {
                            double destinationLatitude = placemark[0].position.latitude;
                            double destinationLongitude = placemark[0].position.longitude;
                            LatLng beginNavigationFrom = LatLng(latitude, longitude);
                            LatLng destination = LatLng(destinationLatitude, destinationLongitude);
                            mapController.animateCamera(CameraUpdate.newCameraPosition(
                              CameraPosition(
                                bearing: 0,
                                target: LatLng(destinationLatitude, destinationLongitude),
                                zoom: 17.0,
                              ),
                            ));
                            _addMarker(destination, value).whenComplete(() async {
//                              String route = await GoogleMapsServices().getRouteCoordinates(
//                                  beginNavigationFrom, destination);
//                              print(route);
//                              createRoute(route);
                            });
                          });
                        },
                      ),
                    ),

                    Flexible(child: SizedBox(height: 20.0)),
                    Flexible(
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.refresh, color: Colors.black)),
                        title: Text('Gamer\'s Paradise',
                            style:
                                TextStyle(color: Colors.white, fontSize: 19.0)),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 15.0),
                        subtitle: Text('757Kalikapur, Kolkata 80000086',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0)),
                      ),
                    ),
                    Expanded(child: SizedBox(height: 10.0)),
                    Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 1.0,
                        color: Colors.white),
                    Flexible(
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.refresh, color: Colors.black)),
                        title: Text('Coder\'s  Hub',
                            style:
                                TextStyle(color: Colors.white, fontSize: 19.0)),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 15.0),
                        subtitle: Text('757Kalikapur, Kolkata 80000086',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}