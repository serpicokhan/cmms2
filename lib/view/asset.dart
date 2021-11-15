import 'package:cmms2/glob.dart';
import 'package:cmms2/models/assets.dart';
import 'package:cmms2/view/asset_detail.dart';

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

  final icons = [Icons.ac_unit, Icons.access_alarm, Icons.access_time];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: AssetListView());
  }
}

class AssetListView extends StatefulWidget {
  const AssetListView({
    Key? key,
  }) : super(key: key);

  @override
  _AssetListViewState createState() => _AssetListViewState();
}

class _AssetListViewState extends State<AssetListView> {
  bool isSwitch = false;

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
    return ListView.builder(
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Kindacode.com'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        fixedSize: Size(300, 100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                ),
              ),
            );
          }
          return newMethod(context, data[index - 1]);
        });
  }

  Card newMethod(dynamic context, Asset index) {
    try {
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
                  trailing: Switch(
                    value: index.assetStatus,
                    onChanged: ontoggle,
                  ))),
        ),
      );
    } on Exception catch (exception) {
      print(index.id);
    }
    return Card();
  }

  void ontoggle(bool value) {
    setState(() {
      if (isSwitch) {
        isSwitch = false;
      } else {
        isSwitch = true;
      }
    });
  }
}
