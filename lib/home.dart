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

Future<String> createUser(String token) async {
  final response = await http.post(
    Uri.parse(ServerStatus.ServerAddress + '/api/v1/Users/Add/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': token,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return '';
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class _HomeState extends State<Home> {
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
  }
}
