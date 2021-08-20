import 'package:flutter/material.dart';

import '../with_tabs.dart';
import 'asset.dart';

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
}
