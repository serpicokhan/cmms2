// import 'workorder.dart';

import 'package:cmms2/glob.dart';
import 'package:cmms2/view/asset.dart';
import 'package:cmms2/view/qrcode.dart';
import 'package:flutter/material.dart';

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
  List<String> titles = ['دستور کارها', 'دارایی ها و تجهیزات', 'sads'];
  String appbarTitle = 'دستور کار';
  static List<Widget> _pages = <Widget>[
    // ListViewHome(),
    CallsPage(),
    ListViewAsset(),
    QRViewExample(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Job Portal',
        home: Scaffold(
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
        ));
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
      appbarTitle = titles[value];
    });
  }
}
