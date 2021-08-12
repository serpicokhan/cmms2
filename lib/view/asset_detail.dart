import 'dart:convert';

import 'package:cmms2/glob.dart';
import 'package:cmms2/models/assets.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TabBarAsset extends StatelessWidget {
  const TabBarAsset({Key? key, required this.id2}) : super(key: key);
  final int id2;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              AssetDetail(id: id2),
              Icon(Icons.directions_car),
              Icon(Icons.directions_car),
              Icon(Icons.directions_car),
            ],
          ),
        ),
      ),
    );
  }
}

class AssetDetail extends StatefulWidget {
  const AssetDetail({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _AssetDetailState createState() => _AssetDetailState();
}

Future<Asset> fetchAsset(int id) async {
  final response = await http
      .get(Uri.parse(ServerStatus.ServerAddress + '/api/v1/Asset/$id/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Asset.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class _AssetDetailState extends State<AssetDetail>
    with AutomaticKeepAliveClientMixin<AssetDetail> {
  late Future<Asset> futureAlbum;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAsset(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<Asset>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new Scaffold(
                  body: new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(snapshot.data!.assetName),
                        subtitle: Text(snapshot.data!.id.toString()),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new Text(((snapshot.data!.assetStatus == true)
                            ? "online"
                            : "offline")),
                        subtitle: const Text('زمان ایجاد'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(snapshot.data!.assetDescription),
                        subtitle: const Text('دستورالعمل'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new Text(snapshot.data!.assetCategory.name),
                        subtitle: const Text('اولویت'),
                      ),
                      new ListTile(
                          leading: const Icon(Icons.email),
                          title: new Text((snapshot.data!.assetIsPartOf != null)
                              ? snapshot.data!.assetIsPartOf!.assetName
                              : "")),
                      const Divider(
                        height: 1.0,
                      ),
                      new ListTile(
                        leading: const Icon(Icons.label),
                        title: Text((snapshot.data!.assetIsLocatedAt != null)
                            ? snapshot.data!.assetIsLocatedAt!.assetName
                            : ""),
                        subtitle: const Text('کاربر اختصاص داده شده'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.today),
                        title: Text(snapshot.data!.assetModel.toString()),
                        subtitle: const Text('کاربر درخواست کننده'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.location_history),
                        title: Text(snapshot.data!.assetBarcode.toString()),
                        subtitle: const Text('Not specified'),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
