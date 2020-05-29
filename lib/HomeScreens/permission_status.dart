import 'package:fetchride/HomeScreens/location_request_screen.dart';
import 'package:fetchride/drawer_screen/drawer_screen.dart';
import 'package:fetchride/settings_screen/account_settings.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

class LocationPermissionStatus {
  handlePermission () {
    return StreamBuilder<bool>(
      stream: LocationPermissions().serviceStatus.map((s) => s == ServiceStatus.enabled ? true : false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active && snapshot.hasData)
          {
            if (snapshot.data)
              return DrawerScreen();
            else
              return LocationRequestScreen();
          }
        return LocationRequestScreen();
      },
    );
  }
}