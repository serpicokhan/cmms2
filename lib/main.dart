// import 'workorder.dart';

import 'package:flutter/material.dart';

import 'with_tabs.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static List<Widget> _pages = <Widget>[
    // ListViewHome(),
    CallsPage(),
    Center(
        child: Icon(
      Icons.camera,
      size: 150,
    )),
    Icon(
      Icons.chat,
      size: 150,
    ),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Job Portal',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Experter'),
          ),
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
    });
  }
}
