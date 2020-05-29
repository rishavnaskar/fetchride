import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fetchride/HomeScreens/HomeScreen.dart';
import 'file:///C:/Users/acer/Documents/Flutter/fetchride/lib/settings_screen/account_settings.dart';
import 'package:fetchride/login_screens/google_login.dart';
import 'package:fetchride/settings_screen/settings_screen.dart';
import 'package:fetchride/trips_screen/trips_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerItem {
  String title;
  Icon icon;
  DrawerItem(this.title, this.icon);
}

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String phoneNumber, email, displayName, searchTextInput, photoUrl;
  int _selectedDrawerIndex = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomeScreen(email: email, displayName: displayName, phoneNumber: phoneNumber);
      case 1:
        return TripsScreen();
      case 2:
        return AccountSettings();
      case 3:
        return SettingsScreen();
      default:
        return new Text("Error");
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        if (user.phoneNumber != null)
          setState(() {
            phoneNumber = user.phoneNumber;
          });
        if (user.email != null)
          setState(() {
            email = user.email;
          });
        else {
          final snapshots = await Firestore.instance.collection('users').getDocuments();
          for (var snapshot in snapshots.documents) {
            if (snapshot.data['phone'] == phoneNumber)
              setState(() {
                email = snapshot.data['email'];
                displayName = snapshot.data['displayName'];
                photoUrl = snapshot.data['photoUrl'];
              });
          }
        }
        if (user.displayName != null)
          setState(() {
            displayName = user.displayName;
          });
        if (user.photoUrl != null)
          setState(() {
            photoUrl = user.photoUrl;
          });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
//      appBar: AppBar(
//        backgroundColor: Colors.transparent,
//        elevation: 0.0,
//      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 13,
              color: Colors.black,
            ),
            UserAccountsDrawerHeader(
              accountEmail: Text(email != null ? '$email' : '$phoneNumber',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold)),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              accountName: Text(displayName == null ? 'FetchRide User' : '$displayName',
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold)),
              arrowColor: Colors.black,
              currentAccountPicture: CircleAvatar(
                maxRadius: 40.0,
                backgroundImage: photoUrl == null
                    ? AssetImage('assets/image4.png')
                    : NetworkImage('$photoUrl'),
                backgroundColor: Colors.black,
              ),
              onDetailsPressed: () => onSelectItem(1),
            ),
            ListTile(
              title: Text('Book a Ride',
                  style: TextStyle(color: Colors.black, fontSize: 17.0)),
              leading: Icon(FontAwesomeIcons.calendar, color: Colors.black),
              onTap: () => onSelectItem(0),
            ),
            ListTile(
              title: Text('Your trips',
                  style: TextStyle(color: Colors.black, fontSize: 17.0)),
              leading: Icon(FontAwesomeIcons.car, color: Colors.black),
              onTap: () => onSelectItem(1),
            ),
            ListTile(
              title: Text('Account Settings',
                  style: TextStyle(color: Colors.black, fontSize: 17.0)),
              leading: Icon(FontAwesomeIcons.userAlt, color: Colors.black),
              onTap: () => onSelectItem(2),
            ),
            ListTile(
              title: Text('Settings',
                  style: TextStyle(color: Colors.black, fontSize: 17.0)),
              leading: Icon(Icons.settings, color: Colors.black),
              onTap: () => onSelectItem(3),
            ),
            Expanded(
              child: SizedBox(height: 20.0),
            ),
            Container(
              height: 1.0,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: GestureDetector(
                onTap: () => GoogleAuth().googleLogOutUser(),
                  child: Text('Log Out',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontFamily: 'Montserrat')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
