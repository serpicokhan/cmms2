import 'dart:convert';

import 'package:cmms2/models/user.dart';
import 'package:cmms2/view/home.dart';
import 'package:flutter/material.dart';
import 'package:cmms2/Screens/register/register.dart';
import 'package:cmms2/components/background.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../glob.dart';

Future<User> _fetchUser(String username, String password) async {
  final response = await http.get(Uri.parse(
      ServerStatus.ServerAddress + '/api/v1/Users/$username/$password/'));

  if (response.statusCode == 200) {
    User jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse;
  } else {
    throw Exception('Failed  to load wopart from API');
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late User usr;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                "سیستم مدیریت تعمیر و نگهداری",
                style: TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(labelText: "نام کاربری"),
                textDirection: TextDirection.rtl,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(labelText: "گذرواژه"),
                obscureText: true,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              // alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton(
                onPressed: () async {
                  // _fetchUser('admin', '123456Man').then((value) => usr = value);
                  usr = User(
                      id: 1,
                      password: 'password',
                      fullName: 'fullName',
                      personalCode: 'personalCode',
                      title: 'title',
                      email: 'email');
                  if (usr.id != -1) {
                    final snackBar = SnackBar(
                      content: const Text('با موفقیت وارد شدید'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FisrtHome()),
                    );
                    final SharedPreferences prefs = await _prefs;
                    prefs.setBool('_authentificated', true);
                  } else {
                    final snackBar = SnackBar(
                      content: const Text('نام کاربری یا پسورد نامتبر است!'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                  // Find the ScaffoldMessenger in the widget tree
                  // and use it to show a SnackBar.
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.green)))),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  // decoration: new BoxDecoration(
                  //     borderRadius: BorderRadius.circular(80.0),
                  //     gradient: new LinearGradient(colors: [
                  //       Color.fromARGB(186, 179, 148, 150),
                  //       Color.fromARGB(196, 179, 148, 150)
                  //     ])

                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()))
                },
                child: Text(
                  "Don't Have an Account? Sign up",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
