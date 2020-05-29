import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_ha/nextPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationDialog(),
    );
  }
}

class LocationDialog extends StatefulWidget {
  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog>
    with SingleTickerProviderStateMixin {
  PermissionStatus _status;

  @override
  void initState() {
    runFirst();
    super.initState();
  }

  runFirst() async {
    await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus);
    await _requestPerms();
    if (_status == PermissionStatus.granted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NextPage()));
    } else if (_status == PermissionStatus.denied) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.red : Colors.green,
          ),
        );
      },
    );
  }

  void _requestPerms() async {
    Map<PermissionGroup, PermissionStatus> statuses = await PermissionHandler()
        .requestPermissions([
      PermissionGroup.locationWhenInUse,
      PermissionGroup.locationAlways
    ]);

    final status = statuses[PermissionGroup.locationWhenInUse];
    switch (status) {
      case PermissionStatus.disabled:
        await PermissionHandler().openAppSettings();
        break;
    }
    _updateStatus(status);
  }

  void _updateStatus(PermissionStatus value) {
    setState(() {
      _status = value;
    });
  }
}
