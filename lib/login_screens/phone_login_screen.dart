import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:fetchride/login_screens/phone_login.dart';
import 'package:fetchride/login_screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import '../components.dart';

class PhoneLoginScreen extends StatefulWidget {
  PhoneLoginScreen({this.email});
  final String email;
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  String countryCode = '+91', phoneNumber, verificationID, smsCode;
  bool codeSent = false, showSpinner = false;

  Future<void> uploadPhone () async {
    int cnt = 0;
    final snapshot = await Firestore.instance
        .collection('users')
        .getDocuments();
    for (var user in snapshot.documents) {
      if (user.data['phone'] == phoneNumber)
        cnt++;
      else
        continue;
    }
    if (cnt == 0) {
      if (widget.email == null) {
        Firestore.instance.collection('users').document('$phoneNumber').setData({
          'phone': phoneNumber,
        });
      }
      else {
        Firestore.instance.collection('users').document('${widget.email}').setData({
          'phone': phoneNumber,
          'email': widget.email,
        });
      }
    }
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      PhoneAuth().phoneSignIn(authResult).whenComplete(() => uploadPhone().whenComplete(() {
        Navigator.pop(context);
        if (widget.email != null)
          Navigator.pop(context);
      }));
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      Components().neverSatisfied('Phone verification failed', null, context);
      setState(() {
        showSpinner = false;
      });
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationID = verId;
      if (mounted) {
        setState(() {
          this.codeSent = true;
          this.showSpinner = false;
        });
      }
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationID = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
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
            onPressed: () async{
              if (widget.email != null) {
                final user = await FirebaseAuth.instance.currentUser();
                user.delete();
                Navigator.pop(context);
                Navigator.pop(context);
              }
              else
                Navigator.pop(context);
            },
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
                heroTag: 'phone',
                text: 'Continue with Phone Number',
                iconData: Icons.phone,
                navigateFunction: () {},
              ),
              Flexible(child: SizedBox(height: 40.0)),
              DisplayText(
                  text: 'Please enter your mobile number', fontSize: 30.0),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: CountryCodePicker(
                      initialSelection: 'IN',
                      favorite: ['+91', 'IN'],
                      dialogSize: Size(MediaQuery.of(context).size.width / 2,
                          MediaQuery.of(context).size.height / 2),
                      showFlag: true,
                      flagWidth: 40.0,
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400),
                      showFlagDialog: false,
                      hideSearch: true,
                      onChanged: (code) {
                        setState(() {
                          countryCode = code.dialCode.toString();
                          print(countryCode);
                        });
                      },
                    ),
                  ),
                  Flexible(child: SizedBox(width: 10.0)),
                  Flexible(
                    flex: 10,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: TextFormField(
                        maxLines: 1,
                        onChanged: (value) {
                          setState(() {
                            phoneNumber = '$countryCode$value';
                          });
                        },
                        cursorColor: Colors.black,
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 20.0),
                        keyboardType: TextInputType.number,
                        cursorWidth: 1.0,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: codeSent,
                child: Column(
                  children: [
                    SizedBox(height: 40.0),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: DisplayText(text: 'Enter OTP', fontSize: 20.0)),
                    SizedBox(height: 30.0),
                    PinEntryTextField(
                      fields: 6,
                      onSubmit: (value) {
                        setState(() {
                          this.smsCode = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(flex: 10, child: SizedBox(height: 300.0)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                          'By continuing you will receive an SMS for verification'),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 20),
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      elevation: 10.0,
                      focusElevation: 20.0,
                      child: Icon(FontAwesomeIcons.arrowRight, size: 20.0),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (phoneNumber == null || phoneNumber.length < 10) {
                          Components().neverSatisfied('Phone Number too short', null, context);
                          setState(() {
                            showSpinner = false;
                          });
                        } else {
                          setState(() {
                            showSpinner = true;
                          });
                          int cnt = 0;
                          final snapshot = await Firestore.instance
                              .collection('users')
                              .getDocuments();
                          for (var user in snapshot.documents) {
                            if (user.data['phone'] == phoneNumber)
                              cnt++;
                            else
                              continue;
                          }
                          if (cnt > 0) {
                            setState(() {
                              showSpinner = false;
                            });
                            Components().neverSatisfied('Phone already exists', null, context);
                          }
                          else {
                            if (codeSent) {
                              setState(() {
                                showSpinner = false;
                              });
                              PhoneAuth()
                                  .phoneSignInWithOTP(smsCode, verificationID).whenComplete(() => uploadPhone().whenComplete(() {
                                setState(() {
                                  showSpinner = true;
                                });
                                if (widget.email != null)
                                  Navigator.pop(context);
                              }));
//                            setState(() {
//                              showSpinner = true;
//                            });
//                            setState(() {
//                              showSpinner = false;
//                            });
                            } else {
                              setState(() {
                                showSpinner = true;
                              });
                              verifyPhone(phoneNumber);
                            }
                          }
                        }
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