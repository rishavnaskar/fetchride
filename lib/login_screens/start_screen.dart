import 'package:fetchride/login_screens/email_login_screen.dart';
import 'package:fetchride/login_screens/google_login.dart';
import 'package:fetchride/login_screens/phone_login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(25.0)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0, 10.0),
                      blurRadius: 10.0,
                      spreadRadius: 10.0,
                      color: Colors.grey)
                ],
                image: DecorationImage(
                  image: AssetImage('assets/image1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(child: SizedBox(height: 20.0)),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text('Explore new ways with FetchRide',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 25.0,
                  )),
            ),
            Expanded(child: SizedBox(height: 20.0)),
            RaisedLoginButton(
              heroTag: 'phone',
              text: 'Continue with Phone Number',
              iconData: Icons.phone,
              navigateFunction: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                      transitionDuration: Duration(seconds: 1),
                      pageBuilder: (_, __, ___) => PhoneLoginScreen())),
            ),
            Flexible(child: SizedBox(height: 10.0)),
            RaisedLoginButton(
                heroTag: 'email',
                text: 'Continue with Email Address',
                iconData: FontAwesomeIcons.solidEnvelope,
                navigateFunction: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(seconds: 1),
                        pageBuilder: (_, __, ___) => EmailLoginScreen()))),
            Expanded(child: SizedBox(height: 10.0)),
            Container(
              height: 1.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.3),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: SignInButton(
                  Buttons.Google,
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });
                    GoogleAuth().googleLogInUser();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      side: BorderSide(color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RaisedLoginButton extends StatelessWidget {
  RaisedLoginButton(
      {@required this.heroTag,
      @required this.text,
      @required this.iconData,
      @required this.navigateFunction});
  final String heroTag;
  final String text;
  final IconData iconData;
  final Function navigateFunction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: heroTag,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.black,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(iconData, color: Colors.white),
                  Flexible(child: SizedBox(width: 20.0)),
                  FittedBox(
                    child: Text(text,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 17.0,
                        )),
                  ),
                ],
              ),
            ),
            onPressed: navigateFunction,
          ),
        ),
      ),
    );
  }
}
