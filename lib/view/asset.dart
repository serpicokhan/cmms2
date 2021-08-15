import 'package:cmms2/glob.dart';
import 'package:cmms2/models/assets.dart';
import 'package:cmms2/view/asset_detail.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'dart:convert';

class ListViewAsset extends StatefulWidget {
  @override
  _ListViewAssetState createState() => _ListViewAssetState();
}

class _ListViewAssetState extends State<ListViewAsset>
    with AutomaticKeepAliveClientMixin<ListViewAsset> {
  @override
  bool get wantKeepAlive => true;
  final titles = ["List 1", "List 2", "List 3"];

  final subtitles = [
    "Here is list 1 subtitle",
    "Here is list 2 subtitle",
    "Here is list 3 subtitle"
  ];

  final icons = [Icons.ac_unit, Icons.access_alarm, Icons.access_time];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            AssetListView(titles: titles, subtitles: subtitles, icons: icons));
  }
}

class AssetListView extends StatelessWidget {
  const AssetListView({
    Key? key,
    required this.titles,
    required this.subtitles,
    required this.icons,
  }) : super(key: key);

  final List<String> titles;
  final List<String> subtitles;
  final List<IconData> icons;
  Future<List<Asset>> _fetchAssets() async {
    final response = await http
        .get(Uri.parse(ServerStatus.ServerAddress + '/api/v1/Assets/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((asset) => new Asset.fromJson(asset)).toList();
    } else {
      throw Exception('Failed to load Assets from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Asset>>(
      future: _fetchAssets(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Asset>? data = snapshot.data;
          return newMethod2(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
    // return newMethod2();
  }

  ListView newMethod2(data) {
    // print("1234")
    // return new GroupedListView<dynamic, String>(
    //   elements: data,
    //   groupBy: (element) => element['id'],
    //   groupComparator: (value1, value2) => value2.compareTo(value1),
    //   itemComparator: (item1, item2) => item1['id'].compareTo(item2['id']),
    //   order: GroupedListOrder.DESC,
    //   useStickyGroupSeparators: true,
    //   groupSeparatorBuilder: (String value) => Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Text(
    //       value,
    //       textAlign: TextAlign.center,
    //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //     ),
    //   ),
    //   itemBuilder: (c, element) {
    //     return newMethod(c, element);
    //   },
    // );

    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return newMethod(context, data[index]);
        });
  }

  Card newMethod(dynamic context, Asset index) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TabBarAsset(
                      id2: index.id,
                    )),
          );
        },
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text(index.assetName),
                subtitle: Text(index.assetCode.toString()),
                leading: CircleAvatar(backgroundColor: Colors.amber[100]),
                trailing: Icon(icons[0]))),
      ),
    );
  }
}
