import 'package:fetchride/components.dart';
import 'package:fetchride/login_screens/phone_login_screen.dart';
import 'package:fetchride/login_screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EmailLoginScreen extends StatefulWidget {
  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  bool showSpinner = false;
  String email, password;

  Future<void> _modalBottomSheetMenu () async{
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Container(
            height: MediaQuery.of(context).size.height / 5,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BottomSheetButton(
                  text: 'Sign In',
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password).whenComplete(() {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    }
                    catch (error) {
                      Components().neverSatisfied('$error', null, context);
                    }
                  },
                ),
                SizedBox(width: 20.0),
                BottomSheetButton(
                  text: 'Sign Up',
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.trim(), password: password).whenComplete(() {
                        Navigator.pop(context);
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => PhoneLoginScreen(email: email.trim())));
                      });
                    }
                    catch (error) {
                      Components().neverSatisfied('$error', null, context);
                    }
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            iconSize: 18.0,
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: SizedBox(height: 20.0)),
              RaisedLoginButton(
                heroTag: 'email',
                text: 'Continue with Email Address',
                iconData: FontAwesomeIcons.solidEnvelope,
                navigateFunction: () {},
              ),
              Flexible(child: SizedBox(height: 50.0)),
              Align(
                  alignment: Alignment.centerLeft,
                  child: DisplayText(text: 'Your Email', fontSize: 20.0)),
              Flexible(child: SizedBox(height: 30.0)),
              InputBox(
                textInputType: TextInputType.emailAddress,
                hintText: 'fetchride@email.com',
                obscureText: false,
                letterSpacing: 2.0,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              Flexible(child: SizedBox(height: 40.0)),
              Align(
                  alignment: Alignment.centerLeft,
                  child: DisplayText(text: 'Your Password', fontSize: 20.0)),
              Flexible(child: SizedBox(height: 30.0)),
              InputBox(
                textInputType: TextInputType.visiblePassword,
                hintText: '********',
                letterSpacing: 7.0,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Expanded(flex: 10, child: SizedBox(height: 30.0)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                          'You may have to provide with your phone number later in case you haven\'t before'),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 10),
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      elevation: 10.0,
                      focusElevation: 20.0,
                      child: Icon(FontAwesomeIcons.arrowRight, size: 20.0),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (email  != null && password != null ) {
                          if (password.length >= 6)
                            _modalBottomSheetMenu();
                          else
                            Components().neverSatisfied('Password too short', null, context);
                        }
                        else
                          Components().neverSatisfied('One or more fields are empty...', null, context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

