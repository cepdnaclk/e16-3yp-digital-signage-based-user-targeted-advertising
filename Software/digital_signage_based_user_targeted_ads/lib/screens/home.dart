import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:project_api/screens/create_account.dart';
import 'package:project_api/screens/smartpower.dart';
import 'package:project_api/screens/usertarget.dart';
import 'package:project_api/screens/dashboard.dart';
import 'package:project_api/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_api/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

final shopsRef = Firestore.instance.collection('shop details');

final int timestamp = DateTime.now().millisecondsSinceEpoch;

final userRef = Firestore.instance.collection('users');
final GoogleSignIn googleSignIn = GoogleSignIn();
FirebaseAuth _auth;
User currentUserWithInfo;

class Home extends StatefulWidget {
  static const String id = "home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  bool isAuth = true;

  // FirebaseUser mCurrentUser;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();

    // Detects when user signed in
    // googleSignIn.onCurrentUserChanged.listen((account) {
    //   addFirebaseAuth(account);
    //   handleSignIn(account);
    // }, onError: (err) {
    //   showToast('Signing In Failed');
    //   print('Error signing in: $err');
    // });
    // Reauthenticate user when app is opened
    // googleSignIn.signInSilently(suppressErrors: false).then((account) {
    //   handleSignIn(account);
    // }).catchError((err) {
    //   print('silently: $err');
    // });
  }

  _getCurrentUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedUserId = prefs.getString('loggedUserId');
    if (loggedUserId != null) {
      DocumentSnapshot documentSnapshot =
          await userRef.document(loggedUserId).get();

      if (documentSnapshot.exists) {
        setState(() {
          currentUserWithInfo = User.fromDocument(documentSnapshot);
        });
        print(currentUserWithInfo);
        // print(currentUserWithInfo.name);
        setState(() {
          isAuth = true;
        });
      } else {
        //block user => delete document/auth
        setState(() {
          isAuth = false;
        });
      }
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        // toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        textColor: Colors.white);
  }
//google stuff
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    handleSignIn(googleSignInAccount);
  }

  handleSignIn(GoogleSignInAccount googleSignInAccount) async {
    if (googleSignInAccount != null) {
      // print('User signed in!: $googleSignInAccount');

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      // showToast("Hi, " + user.displayName);
      try {
        await createUserInFirestore(user);
      } catch (err) {
        showToast(user.displayName + ", please try again");
        setState(() {
          showSpinner = false;
          isAuth = false;
        });
        _signOut();
      }

      // return 'signInWithGoogle succeeded: $user';
      shredprefUser(user.uid);

      setState(() {
        showSpinner = false;
        isAuth = true;
      });
    } else {
      setState(() {
        showSpinner = false;
        isAuth = false;
      });
    }
  }

  Future<void> shredprefUser(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedUserId', uid);
  }

  createUserInFirestore(FirebaseUser user) async {
    DocumentSnapshot documentSnapshot = await userRef.document(user.uid).get();
    //go to createAccount page - only for first reigstration
    if (!documentSnapshot.exists) {
      final userInfoDetails = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateAccount(
                    dispUser: user,
                  )));
      // userRef.document(user.uid).setData({
      //   "id": user.uid,
      //   "name": userInfoDetails.name,
      //   "company": userInfoDetails.company,
      //   "companyBranch": userInfoDetails.companyBranch,
      //   "jobTitle": userInfoDetails.jobTitle,
      //   "whatsappNum": userInfoDetails.whatsappNum,
      //   "contactNum": userInfoDetails.contactNum,
      //   "photoUrl": user.photoUrl,
      //   "timestamp": timestamp
      // });

    }
    documentSnapshot = await userRef.document(user.uid).get();

    currentUserWithInfo = User.fromDocument(documentSnapshot);
    print(currentUserWithInfo);
    print(currentUserWithInfo.name);
  }

  Future<void> _signOut() async {

    await googleSignIn.signOut();
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('loggedUserId');

    setState(() {
      isAuth = false;
    });
  }

  Widget buildAuthScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('DASHBOARD'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'DIGITAL SIGNAGE',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/FaceDetect.jpg"),
                      fit: BoxFit.cover)),
            ),
            CustomListTile(
              Icons.dashboard,
              'DASHBOARD',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                ),
              },
            ),
            CustomListTile(
              Icons.image,
              'USER TARGETED SIGNAGE',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Usertarget()),
                ),
              },
            ),
            CustomListTile(
              Icons.device_hub,
              'SMART POWER SUPPLY',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Smartpower()),
                ),
              },
            ),
            CustomListTile(
              Icons.person,
              'PROFILE',
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
      body: ModalProgressHUD(
          // color: Colors.blueAccent,
          inAsyncCall: showSpinner,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ESLE Signage',
                  style: TextStyle(
                    fontFamily: 'Signatra',
                    fontSize: 70.0,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 250.0,
                  height: 250.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/delivery_cab.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                GoogleSignInButton(
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });
                    // login();
                    signInWithGoogle();
                  },
                  darkMode: true, // default: false
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}

class CustomListTile extends StatelessWidget {
  CustomListTile(this.icon, this.text, this.onTap);

  final IconData icon;
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: InkWell(
          splashColor: Colors.blueGrey,
          onTap: onTap,
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_right,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
