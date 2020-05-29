import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class Components {
  Future<void> neverSatisfied(String header, Widget body, BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            title: Text(header),
            content: body,
            actions: <Widget>[
              FlatButton(
                child: Text('OK', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class BottomSheetButton extends StatelessWidget {
  BottomSheetButton({@required this.text, @required this.onPressed});
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2.0)),
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      onPressed: onPressed,
    );
  }
}

class InputBox extends StatelessWidget {
  InputBox(
      {@required this.onChanged,
        @required this.textInputType,
        @required this.hintText,
        @required this.letterSpacing,
        @required this.obscureText});
  final Function onChanged;
  final TextInputType textInputType;
  final double letterSpacing;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        textAlign: TextAlign.center,
        cursorWidth: 1.0,
        cursorColor: Colors.black,
        keyboardType: textInputType,
        obscureText: obscureText,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, height: 1.0),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          hintText: hintText,
          hintStyle:
          TextStyle(fontFamily: 'Montserrat', letterSpacing: letterSpacing),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class DisplayText extends StatelessWidget {
  DisplayText({@required this.text, @required this.fontSize});
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class OnscreenButtons extends StatelessWidget {
  OnscreenButtons(
      {@required this.alignment,
        @required this.icon,
        @required this.onPressed,
        @required this.padding,
        @required this.backgroundColor});

  final Alignment alignment;
  final Icon icon;
  final Function onPressed;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: CircleAvatar(
          backgroundColor: backgroundColor,
          child: IconButton(
            icon: icon,
            color: Colors.black,
            iconSize: 25.0,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class FetchRideButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 40.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image2.jpg'),
          fit: BoxFit.fitWidth,
        ),
        boxShadow: [BoxShadow(blurRadius: 20.0)],
      ),
      child: RaisedButton(
        color: Colors.transparent,
        elevation: 0.0,
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          //_searchLocation(searchTextInput);
        },
      ),
    );
  }
}

class HomeSearchDummy extends StatelessWidget {
  HomeSearchDummy({@required this.hintText, @required this.icon});
  final String hintText;
  final Icon icon;
  static final String kGoogleApiKey = 'AIzaSyDidIku0MTD7XtJwniNH2qmQY09DLqSoKg';
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      final detail = await _places.getDetailsByPlaceId(p.placeId);
      if (detail.hasNoResults) {
        print('!detail.hasNoResults');
      }
      else if (detail.isDenied) {
        print('!detail.isDenied');
      }
      else if (!detail.isInvalid) {
        print('!detail.isInvalid');
      }
      else if (detail.isNotFound) {
        print('detail.isNotFound');
      }
      else if (detail.isOverQueryLimit) {
        print('detail.isOverQueryLimit');
      }
      else if (detail.unknownError) {
        print('detail.unknownError');
      }
      else {
        print(detail);
        double latitude = detail.result.geometry.location.lat;
        double longitude = detail.result.geometry.location.lng;
        print(latitude);
        print(longitude);
      }

      //var address = await Geocoder.local.findAddressesFromQuery(p.description);
      //print([[p.description]]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0, left: 10.0),
      child: GestureDetector(
        onTap: () async {
          Prediction p = await PlacesAutocomplete.show(
            context: context,
            apiKey: kGoogleApiKey,
            mode: Mode.overlay,
            language: 'en',
            components: [Component(Component.country, 'in')],
          );
          displayPrediction(p);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Row(
            children: [
              icon,
              SizedBox(width: 15.0),
              Text(hintText,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat')),
            ],
          ),
        ),
      ),
    );
  }
}

