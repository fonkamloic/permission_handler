import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  PermissionStatus _status;
  @override
  Widget build(BuildContext context) {
    debugPrint('Location Status $_status');
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Image.asset('assets/images/perm_icon_location.png'),
          Text(
            "LocationDialogHelper",
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "locationDialogBody",
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Colors.black,
                  onPressed: _requestPerms,
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text(
                    "allow",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      )),
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
