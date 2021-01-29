import 'package:flutter/material.dart';
//import 'package:project_api/services/launchurl.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Usertarget extends StatefulWidget {
  @override
  _UsertargetState createState() => _UsertargetState();
}

class _UsertargetState extends State<Usertarget> {
  List<Gender> genders = new List<Gender>();
  List<Age> ages = new List<Age>();

  List<List<String>> adSlides = [
    [
      'https://docs.google.com/presentation/d/e/2PACX-1vSHoOqh7MRh0sXSDp4COp6PI0jo1WoJY9w-pREuBykJTEwF0MyUFZCOQcCKIjyD3yvmEZpqNRNcr8PR/pub?start=true&loop=true&delayms=3000',
      'http://www.google.lk',
      'http://www.youtube.com',
      'https://pinterest.com',
      'https://www.yahoo.com',
    ],
    [
      'https://github.com',
      'https://brilliant.org',
      'https://www.seedr.cc',
      'https://www.wikipedia.org',
      'https://www.encyclopedia.com',
    ],
    ['http://www.sundaytimes.lk']
  ];

  int genderActiveIndex;
  int ageActiveIndex = 3;
  String currentURL;

  _launchURL(int index1, int index2) async {
    currentURL = adSlides[index1][index2];

    if (await canLaunch(currentURL)) {
      await launch(currentURL);
    } else {
      throw 'Could not launch $currentURL';
    }
    print("success!!!");
  }
  /*
  Future<void> _launchApps(String url) async {
    if (await canLaunch(url)) {
      final bool appLaunchSuccess = await launch(
        url,
        forceSafariVC: false,
        forceWebView: true,
      );
      if(!appLaunchSuccess){
        await launch(url,forceSafariVC: true)
      }
    } 
  }
  */

  @override
  void initState() {
    super.initState();
    genders.add(new Gender("Male", FontAwesomeIcons.male, false));
    genders.add(new Gender("Female", FontAwesomeIcons.female, false));
    genders.add(new Gender("Generic", FontAwesomeIcons.users, false));

    ages.add(new Age("15 - 20", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("25 - 32", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("38 - 43", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("48 - 53", FontAwesomeIcons.peopleArrows, false));
    ages.add(new Age("60 - 100", FontAwesomeIcons.peopleArrows, false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create schedules"),
      ),
      body: Column(
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
                              ageActiveIndex = 3;
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
                          alignment: Alignment.center,
                          child: Text(
                            'Add advertisements',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          child: RaisedButton(
                            onPressed: () {
                              if (ageActiveIndex != 3) {
                                _launchURL(genderActiveIndex, ageActiveIndex);
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
                            child: Text('Open Google Slides'),
                          ),
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
