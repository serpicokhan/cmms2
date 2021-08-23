import 'package:cmms2/Screens/login/login.dart';
import 'package:cmms2/view/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  gettoken() async {
    await Firebase.initializeApp();
    String? token = await FirebaseMessaging.instance.getToken();
    print("sarvi:  " + token.toString());
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> _counter;
  late bool isloged = false;
  // Future<bool> _islogin() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final bool counter =
  //       (prefs.getBool('_authentificated') != null) ? true : false;
  //   return counter;
  // }

  @override
  Widget build(BuildContext context) {
    if (isloged == true) {
      return FisrtHome();
    }
    return LoginScreen();
  }

  @override
  initState() {
    super.initState();
    _counter = _prefs.then((SharedPreferences prefs) {
      isloged = (prefs.getBool('_authentificated') != null) ? true : false;
      return ((prefs.getBool('_authentificated') != null) ? true : false);
    });
    // await Firebase.initializeApp();
    gettoken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        _showMyDialog(notification.title.toString());
      }
    });
  }

  Future<void> _showMyDialog(String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
