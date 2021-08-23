import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../glob.dart';
import '../with_tabs.dart';
import 'asset.dart';
import 'package:http/http.dart' as http;

class FisrtHome extends StatefulWidget {
  const FisrtHome({Key? key}) : super(key: key);

  @override
  _FisrtHomeState createState() => _FisrtHomeState();
}

class _FisrtHomeState extends State<FisrtHome> {
  List<String> titles = ['دستور کارها', 'دارایی ها و تجهیزات', 'sads'];
  String appbarTitle = 'دستور کار';
  static List<Widget> _pages = <Widget>[
    // ListViewHome(),
    CallsPage(),
    ListViewAsset(),
    Icon(Icons.ac_unit) // QRViewExample(),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ), //New//ListViewHome(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
      appbarTitle = titles[value];
    });
  }

  void _showDialog(BuildContext context, String title) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text("You are awesome!"),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  gettoken() async {
    await Firebase.initializeApp();
    String? token = await FirebaseMessaging.instance.getToken();
    print("sarvi:  " + token.toString());
    createUser(token.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        // print("Sarvi" + notification.title.toString());
        _showDialog(context, notification.title.toString());
      }
    });
    gettoken();
  }
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
