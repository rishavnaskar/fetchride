import 'package:country_code_picker/country_localizations.dart';
import 'package:fetchride/drawer_screen/drawer_screen.dart';
import 'package:fetchride/login_screens/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        cursorColor: Colors.black,
        textSelectionColor: Colors.transparent.withOpacity(0.5),
        indicatorColor: Colors.black,
        textSelectionHandleColor: Colors.grey,
      ),
      supportedLocales: [
        Locale('en'),
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuth(),
    );
  }
}
