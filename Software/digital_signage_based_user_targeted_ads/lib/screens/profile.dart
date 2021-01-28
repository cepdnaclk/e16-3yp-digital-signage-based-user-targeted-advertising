import 'package:flutter/material.dart';
import 'package:project_api/services/authservice.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Sign Out'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Alert!"),
                content: Text("You have Logged out Successfully"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.pop(context);
                      AuthService().signOut();
                    },
                    child: Text("okay"),
                  ),
                ],
              ),
            );
            //AuthService().signOut();
            //Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
