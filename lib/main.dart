// import 'workorder.dart';

import 'package:cmms2/glob.dart';
import 'package:cmms2/view/asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

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
  List<String> titles = ['دستور کارها', 'دارایی ها و تجهیزات'];
  String appbarTitle = 'دستور کار';
  static List<Widget> _pages = <Widget>[
    // ListViewHome(),
    CallsPage(),
    ListViewAsset(),
    Icon(
      Icons.chat,
      size: 150,
    ),
  ];
  int _selectedIndex = 0;
  late SearchBar searchBar;

  _AppState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: print,
        buildDefaultAppBar: buildAppBar);
    // setState(() {});
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text(appbarTitle),
        actions: [searchBar.getSearchAction(context)]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Job Portal',
        home: Scaffold(
          appBar: searchBar.build(context),
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
