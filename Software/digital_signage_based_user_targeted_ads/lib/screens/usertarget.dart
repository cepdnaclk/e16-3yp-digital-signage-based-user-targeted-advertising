import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_api/widgets/header.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_api/adslides.dart';
import 'package:project_api/services/web_view_container.dart';

class Usertarget extends StatefulWidget {
  @override
  _UsertargetState createState() => _UsertargetState();
}

class _UsertargetState extends State<Usertarget> {
  List<Gender> genders = new List<Gender>();
  List<Age> ages = new List<Age>();

  int genderActiveIndex = 0;
  int ageActiveIndex = 5;
  String currentURL;
  String currentPreview;

  _launchURL(int index1, int index2) async {
    currentURL = Adlist().selectAd(index1, index2);

    if (await canLaunch(currentURL)) {
      await launch(currentURL);
    } else {
      throw 'Could not launch $currentURL';
    }
    print("success!!!");
  }

  void _handleURLButtonPress(BuildContext context, int index1, int index2) {
    currentPreview = Adlist().selectPreview(index1, index2);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(currentPreview)));
  }

  @override
  void initState() {
    super.initState();
    genders.add(new Gender("Male", FontAwesomeIcons.male, true));
    genders.add(new Gender("Female", FontAwesomeIcons.female, false));
    genders.add(new Gender("Generic", FontAwesomeIcons.users, false));

    ages.add(new Age("15 - 20", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("25 - 32", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("38 - 43", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("48 - 53", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("60 - 100", FontAwesomeIcons.peopleArrows, false));

    CustomRadio(genders[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,
          titleText: "Control Assets", removeBackbtn: false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              'Select Gender category',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: genders.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        //splashColor: Colors.blue,
                        onTap: () {
                          setState(() {
                            genders
                                .forEach((gender) => gender.isSelected = false);
                            //if (index == 2) {
                            ages.forEach((age) => age.isSelected = false);
                            CustomRadio1(ages[index]);
                            if (index != 2) {
                              ageActiveIndex = 5;
                            } else {
                              ageActiveIndex = 0;
                            }
                            //}
                            genders[index].isSelected = true;
                            genderActiveIndex = index;
                            //print("Current Index = $index ");
                          });
                        },
                        child: CustomRadio(genders[index]),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Text(
                    'Select Age category',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: ages.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            ages.forEach((age) => age.isSelected = false);
                            if (genderActiveIndex != 2) {
                              ages[index].isSelected = true;
                              ageActiveIndex = index;
                            } else {
                              ageActiveIndex = 0;
                            }
                          });
                        },
                        child: CustomRadio1(ages[index]),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            'Add new assets',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              alignment: Alignment.centerLeft,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                onPressed: () {
                                  if (ageActiveIndex != 5) {
                                    _launchURL(
                                        genderActiveIndex, ageActiveIndex);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text("Alert!"),
                                        content: Text("Select age category"),
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
                                  }
                                },
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: Text(
                                        "Add assets",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                      child: Icon(
                                        Icons.add,
                                        size: 30.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 10, 5),
                              alignment: Alignment.center,
                              child: RaisedButton(
                                onPressed: () {
                                  if (ageActiveIndex != 5) {
                                    _handleURLButtonPress(context,
                                        genderActiveIndex, ageActiveIndex);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text("Alert!"),
                                        content: Text("Select age category"),
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
                                  }
                                },
                                color: Colors.blueGrey,
                                textColor: Colors.white,
                                child: Text(
                                  'Watch preview',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Gender {
  String name;
  IconData icon;
  bool isSelected;

  Gender(this.name, this.icon, this.isSelected);
}

class Age {
  String age;
  IconData icon;
  bool isSelected;

  Age(this.age, this.icon, this.isSelected);
}

class CustomRadio extends StatelessWidget {
  final Gender _gender;

  CustomRadio(this._gender);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _gender.isSelected ? Color(0xFF3B4257) : Colors.white,
      child: Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        margin: new EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              _gender.icon,
              color: _gender.isSelected ? Colors.white : Colors.grey,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              _gender.name,
              style: TextStyle(
                  color: _gender.isSelected ? Colors.white : Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

class CustomRadio1 extends StatelessWidget {
  final Age _age;

  CustomRadio1(this._age);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _age.isSelected ? Color(0xFF3B4257) : Colors.white,
      child: Container(
        height: 45,
        width: 45,
        alignment: Alignment.center,
        margin: new EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              _age.icon,
              color: _age.isSelected ? Colors.white : Colors.grey,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              _age.age,
              style: TextStyle(
                  color: _age.isSelected ? Colors.white : Colors.grey,
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
