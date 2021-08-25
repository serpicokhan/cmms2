import 'dart:convert';

import 'package:cmms2/Screens/login/login.dart';
import 'package:cmms2/view/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'glob.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> _counter;
  late bool isloged = false;
  int userid = -1;
  // Future<bool> _islogin() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final bool counter =
  //       (prefs.getBool('_authentificated') != null) ? true : false;
  //   return counter;
  // }

  @override
  Widget build(BuildContext context) {
    if (isloged == true) {
      return FisrtHome(id: userid);
    }
    return LoginScreen();
  }

  @override
  initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      isloged = (prefs.getBool('_authentificated') != null) ? true : false;
      userid = prefs.getInt('userid') ?? -1;
    });
    print(isloged.toString() + '' + userid.toString() + '!!!!!!!!!!');
    // await Firebase.initializeApp();
  }
}
