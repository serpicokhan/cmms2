// import 'workorder.dart';

import 'package:cmms2/glob.dart';
import 'package:cmms2/home.dart';
import 'package:cmms2/view/asset.dart';
import 'package:cmms2/view/qrcode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
