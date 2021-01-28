import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Usertarget extends StatefulWidget {
  @override
  _UsertargetState createState() => _UsertargetState();
}

class _UsertargetState extends State<Usertarget> {
  bool showProgressloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu 1 Page"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showProgressloading,
        child: Center(
          child: RaisedButton(
            onPressed: () {
              setState(() {
                showProgressloading = true;
              });
              new Future.delayed(const Duration(seconds: 2), () {
                setState(() => showProgressloading = false);
                Navigator.pop(context);
              });
            },
            child: Text('Go back!'),
          ),
        ),
      ),
    );
  }
}

/*
class Usertarget extends StatelessWidget {
  
  bool showProgressloading = false;

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu 1 Page"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            
            //Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
*/
