import 'package:fetchride/HomeScreens/permission_status.dart';
import 'package:fetchride/login_screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return LocationPermissionStatus().handlePermission();
          } else {
            return StartScreen();
          }
        });
  }
}