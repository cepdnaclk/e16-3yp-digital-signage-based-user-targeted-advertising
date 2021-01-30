import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_api/widgets/header.dart';

import 'home.dart';

//for drop down menu
class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}

class CreateAccount extends StatefulWidget {
  final FirebaseUser dispUser;

  CreateAccount({Key key, @required this.dispUser}) : super(key: key);
  @override
  _CreateAccountSellerState createState() => _CreateAccountSellerState();
}

class _CreateAccountSellerState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  Placemark placemark;

  Position companyLocation;
  TextEditingController locationController = TextEditingController();

  String name;
  String company;
  String companyBranch;
  String jobTitle;
  String whatsappNum;
  String contactNum;

  Item selectedCategory;
  List<Item> categories = <Item>[
    const Item(
        'Food',
        Icon(
          Icons.restaurant,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'Grocery',
        Icon(
          Icons.add_shopping_cart,
          color: const Color(0xFF167F67),
        )),
    const Item(
        'Medicine',
        Icon(
          Icons.local_pharmacy,
          color: const Color(0xFF167F67),
        )),
  ];

  @override
  void initState() {
    super.initState();
    locationController.text = "Company location ?";

    getUserLocation().then((value) {
      setState(() {
        placemark = value;
        companyBranch = placemark.subAdministrativeArea;
      });
    });
  }

  submit() {
    final form = _formKey.currentState;

    if (selectedCategory == null) {
      showToast("Please Select a shop category");
    }

    if (form.validate() && selectedCategory != null) {
      form.save();
      showToast("Hi, $name");
      UserInfoDetails userInfoDetails = new UserInfoDetails(name, company,
          companyBranch,companyLocation,jobTitle, contactNum);

      userRef.document(widget.dispUser.uid).setData({
        "id": widget.dispUser.uid,
        "name": userInfoDetails.name,
        "company": userInfoDetails.company,
        "companyBranch": userInfoDetails.companyBranch,
        "jobTitle": userInfoDetails.jobTitle,
        // "whatsappNum": userInfoDetails.whatsappNum,
        "contactNum": userInfoDetails.contactNum,
        "photoUrl": widget.dispUser.photoUrl,
        "timestamp": timestamp,
        "type": "seller"
      });
      if (selectedCategory.name == "Food") {
        shopsRef
            .document('foodShops')
            .collection('shop')
            .document(widget.dispUser.uid)
            .setData({
          "name": userInfoDetails.company,
          "branch": userInfoDetails.companyBranch,
          "location": GeoPoint(userInfoDetails.companyLocation.latitude,userInfoDetails.companyLocation.longitude),
          "shopID": widget.dispUser.uid,
        });
      } else if (selectedCategory.name == "Grocery") {
        shopsRef
            .document('groceries')
            .collection('shop')
            .document(widget.dispUser.uid)
            .setData({
          "name": userInfoDetails.company,
          "branch": userInfoDetails.companyBranch,
          "location": GeoPoint(userInfoDetails.companyLocation.latitude,userInfoDetails.companyLocation.longitude),
          "shopID": widget.dispUser.uid,
        });
      } else if (selectedCategory.name == "Medicine") {
        shopsRef
            .document('pharmacies')
            .collection('pharmacy')
            .document(widget.dispUser.uid)
            .setData({
          "name": userInfoDetails.company,
          "branch": userInfoDetails.companyBranch,
          "location": GeoPoint(userInfoDetails.companyLocation.latitude,userInfoDetails.companyLocation.longitude),
          "shopID": widget.dispUser.uid,
        });
      }
      Navigator.popUntil(
        context,
        ModalRoute.withName(Home.id),
      );
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: header(context,
          titleText: "Set up your profile", removeBackbtn: false),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextFormField(
                    validator: (val) {
                      if (val.trim().length < 3 || val.trim().length == 0) {
                        return "Enter valid Name";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => name = val,
                    initialValue: widget.dispUser.displayName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Enter your name",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextFormField(
                    validator: (val) {
                      if (val.trim().length < 2 || val.trim().length == 0) {
                        return "Enter Valid Company Name";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => company = val,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Company Name",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Enter Your Company Name",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextFormField(
                    key: Key(companyBranch),
                    initialValue: companyBranch,
                    validator: (val) {
                      if (val.trim().length < 2 || val.trim().length == 0) {
                        return "Enter Valid Company Branch / City";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => companyBranch = val,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Company Branch / City",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Eg: Matara",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextFormField(
                    validator: (val) {
                      if (val.trim().length < 2 || val.trim().length == 0) {
                        return "Enter Valid Job Title";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => jobTitle = val,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Job Title",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Enter your Job Title",
                    ),
                  ),
                ),
                //whatsapp removed

                // Padding(
                //   padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                //   child: TextFormField(
                //     validator: (val) {
                //       if ((0 < val.trim().length && 10 > val.trim().length) ||
                //           val.trim().length > 10) {
                //         return "Enter valid Number";
                //       } else {
                //         return null;
                //       }
                //     },
                //     onSaved: (val) => whatsappNum = val,
                //     keyboardType: TextInputType.phone,
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: "WhatsApp Number",
                //       labelStyle: TextStyle(fontSize: 15.0),
                //       hintText: "Eg: 071-------",
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    validator: (val) {
                      if ((0 < val.trim().length && 10 > val.trim().length) ||
                          val.trim().length > 10) {
                        return "Enter valid Number";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => contactNum = val,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Contact Number (Call)",
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: "Eg: 071-------",
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.pin_drop,
                    color: Colors.orange,
                    size: 35.0,
                  ),
                  title: Container(
                    width: 250.0,
                    child: TextField(
                      enabled: false,
                      controller: locationController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  onTap: () => showToast(
                      "1. Make sure you are in the company premises\n2. Press 'Use Current Location' button"),
                ),
                Container(
                  width: 225.0,
                  height: 100.0,
                  alignment: Alignment.center,
                  child: RaisedButton.icon(
                    label: Text(
                      "Use Current Location",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.blue,
                    onPressed: getCompanyLocation,
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                  ),
                ),
                DropdownButton<Item>(
                  hint: Text("Select Your Shop Category"),
                  value: selectedCategory,
                  onChanged: (Item value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  items: categories.map((Item user) {
                    return DropdownMenuItem<Item>(
                      value: user,
                      child: Row(
                        children: <Widget>[
                          user.icon,
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            user.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void getCompanyLocation() async {
    showToast("Make Sure Device Location is turned on");
    companyLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // companyLocation = LatLng(position.latitude, position.longitude);
    locationController.text = "Location marked \u2713 ";
  }
}

Future<Placemark> getUserLocation() async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  List<Placemark> placemarks = await Geolocator()
      .placemarkFromCoordinates(position.latitude, position.longitude);
  return placemarks[0];
}

void showToast(message) {
  Fluttertoast.showToast(
      msg: message,
      // toastLength: Toast.LENGTH_SHORT,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.black,
      textColor: Colors.white);
}

class UserInfoDetails {
  UserInfoDetails(
    this.name,
    this.company,
    this.companyBranch,
    this.companyLocation,
    this.jobTitle,
    // this.whatsappNum,
    this.contactNum,
  );

  String name;
  String company;
  String companyBranch;
  Position companyLocation;
  String jobTitle;
  // String whatsappNum;
  String contactNum;
}
