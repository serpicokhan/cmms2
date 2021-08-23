// import 'workorder.dart';

import 'package:cmms2/glob.dart';
import 'package:cmms2/home.dart';
import 'package:cmms2/view/asset.dart';
import 'package:cmms2/view/qrcode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Screens/login/login.dart';
import 'with_tabs.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  runApp(App());
  ServerStatus.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  gettoken() async {
    await Firebase.initializeApp();
    String? token = await FirebaseMessaging.instance.getToken();
    print("sarvi:  " + token.toString());
    createUser(token.toString());
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        _showMyDialog(notification.title.toString());
      }
    });
    gettoken();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Job Portal', home: Home()
        // home: Scaffold(
        //   body: IndexedStack(
        //     index: _selectedIndex,
        //     children: _pages,
        //   ), //New//ListViewHome(),
        //   bottomNavigationBar: BottomNavigationBar(
        //     items: const <BottomNavigationBarItem>[
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.call),
        //         label: 'Calls',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.camera),
        //         label: 'Camera',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.chat),
        //         label: 'Chats',
        //       ),
        //     ],
        //     currentIndex: _selectedIndex, //New
        //     onTap: _onItemTapped,
        //   ),
        // )
        );
  }
}
