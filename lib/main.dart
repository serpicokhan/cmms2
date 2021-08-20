// import 'workorder.dart';

// import 'package:cmms2/Screens/Welcome/welcome_screen.dart';
// import 'package:cmms2/Screens/Login/login_screen.dart';
import 'package:cmms2/glob.dart';
import 'package:cmms2/view/asset.dart';
import 'package:cmms2/view/qrcode.dart';
import 'package:flutter/material.dart';

import 'Screens/login/login.dart';
import 'with_tabs.dart';

void main() {
  runApp(App());
  ServerStatus.init();
  print(ServerStatus.maintenanceType);
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Job Portal', home: LoginScreen()
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
