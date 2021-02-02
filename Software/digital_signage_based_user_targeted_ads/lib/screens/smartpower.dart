import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_api/components/showToast.dart';
import 'package:project_api/screens/home.dart';
import 'package:project_api/widgets/rounded_btn.dart';
import '../constants.dart';
import 'package:project_api/mqttClient/mqttclient.dart';

class Smartpower extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Power Supply"),
      ),
      body: PowerPage(),
    );
  }
}

enum PowerState {
  turnOn,
  turnOff,
}

class PowerPage extends StatefulWidget {
  @override
  _PowerPageState createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {
  final macKey = GlobalKey<FormState>();

  PowerState selectState;
  final MQTTClientWrapper mqttClientWrapper = new MQTTClientWrapper();

  String deviceMAC = "";
  bool result;
  bool isVeryfied;

  setupDevice() {
    mqttClientWrapper.prepareMqttClient(deviceMAC);
  }

  Future<bool> validateMAC() async {
    try {
      DocumentSnapshot documentSnapshot =
          await powerSupplyRef.document(deviceMAC).get();

      if (documentSnapshot.exists) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } on Exception catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  addDevice() async {
    final form = macKey.currentState;
    form.save();
    if (form.validate()) {
      if (await validateMAC()) {
        setState(() {
          setupDevice();
          showToast(message: "Device added successfully");
          powerSupplyRef.document(deviceMAC).setData({
            "isVeryfied": true,
            "activeStatus": false,
            "deviceMAC": deviceMAC,
            "customerID": currentUserWithInfo?.id,
            "timestamp": timestamp,
          });
        });
      }else{
        showToast(message: "Please check the internet connectivity");
      }
    } else {
      showToast(message: "Please check the Serial number again");
    }
  }

  removeDevice() {}

  editDevices() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Form(
          key: macKey,
          autovalidateMode: AutovalidateMode.always,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              validator: (val) {
                if ((0 < val.trim().length && 4 > val.trim().length) ||
                    val.trim().length > 4) {
                  return "Enter a valid Serial";
                } else {
                  return null;
                }
              },
              onSaved: (val) => deviceMAC = val,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Device Serial",
                labelStyle: TextStyle(fontSize: 15.0),
                hintText: "serial number",
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: RoundedButton(
                title: 'Delete Device',
                minWidth: 75.0,
                height: 25.0,
                color: Colors.redAccent,
                onPressed: removeDevice,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child: RoundedButton(
                title: 'Add Device',
                minWidth: 75.0,
                height: 25.0,
                color: Theme.of(context).accentColor,
                onPressed: addDevice,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          editDevices(),
          Expanded(
            flex: 4,
            child: ReusableCard(
              onPress: () {
                setState(() {
                  if (result == true) {
                    selectState = PowerState.turnOn;
                  }
                });
              },
              colour: selectState == PowerState.turnOn
                  ? kActiveCardColourON
                  : kInactiveCardColour,
              cardChild: IconContent(
                icon: FontAwesomeIcons.powerOff,
                label: 'Screen currently ON',
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ReusableCard(
              onPress: () {
                setState(() {
                  if (result == true) {
                    selectState = PowerState.turnOff;
                  }
                });
              },
              colour: selectState == PowerState.turnOff
                  ? kInactiveCardColour
                  : kInactiveCardColour,
              cardChild: IconContent(
                icon: FontAwesomeIcons.powerOff,
                label: 'Screen currently OFF',
              ),
            ),
          ),



          Padding(
            padding: EdgeInsets.all(10),
            child: FloatingActionButton.extended(
              onPressed: () {
                if (selectState == PowerState.turnOn && result == true) {
                  print("Screen ON");
                  mqttClientWrapper.publishMessage("1");
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Alert!"),
                      content: Text("You have turned on Screen of $deviceMAC"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text(""),
                        ),
                      ],
                    ),
                  );
                } else if ((selectState == PowerState.turnOff &&
                    result == true)) {
                  print("Screen OFF");
                  mqttClientWrapper.publishMessage("0");
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Alert!"),
                      content: Text("You have turned off Screen of $deviceMAC"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text(""),
                        ),
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Alert!"),
                      content: Text(
                          "Enter Valid MacAddress and select on/off state"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text("Try again"),
                        ),
                      ],
                    ),
                  );
                  print("enter valid MacAddress or select a state");
                }
              },
              label: Text(
                'CONFIRM',
                style: TextStyle(fontSize: 30),
              ),
              icon: Icon(
                Icons.thumb_up,
                size: 30,
              ),
              backgroundColor: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  ReusableCard({@required this.colour, this.cardChild, this.onPress});

  final Color colour;
  final Widget cardChild;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

class IconContent extends StatelessWidget {
  IconContent({this.icon, this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          label,
          style: kLabelTextStyle,
        ),
      ],
    );
  }
}
