import 'package:cmms2/glob.dart';
import 'package:cmms2/models/assetpart.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'dart:convert';

class ListViewAssetPart extends StatefulWidget {
  final int id;
  const ListViewAssetPart({Key? key, required this.id}) : super(key: key);
  @override
  _ListViewAssetPartState createState() => _ListViewAssetPartState();
}

class _ListViewAssetPartState extends State<ListViewAssetPart>
    with AutomaticKeepAliveClientMixin<ListViewAssetPart> {
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
    return AssetPartListView(id: widget.id);
  }
}

class AssetPartListView extends StatelessWidget {
  const AssetPartListView({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  Future<List<AssetPart>> _fetchwoPart(id) async {
    final response = await http.get(
        Uri.parse(ServerStatus.ServerAddress + '/api/v1/Asset/Parts/$id/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((task) => new AssetPart.fromJson(task)).toList();
    } else {
      throw Exception('Failed  to load wopart from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AssetPart>>(
      future: _fetchwoPart(this.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<AssetPart>? data = snapshot.data;
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
        itemCount: data.length,
        itemBuilder: (context, index) {
          return newMethod(context, data[index]);
        });
  }

  Card newMethod(dynamic context, AssetPart index) {
    return new Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        elevation: 10.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => AssetPartDetail(id: index.id)),
            // );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text(index.assetPartPid),
                subtitle: Text(
                  index.assetPartQnty.toString(),
                  style: TextStyle(color: Colors.grey[400], fontSize: 16.0),
                ),
                leading: CircleAvatar(backgroundColor: Colors.green[200]),
                trailing: Icon(Icons.ac_unit)),
          ),
        ));
  }
}
