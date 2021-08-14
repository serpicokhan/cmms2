import 'package:cmms2/glob.dart';
import 'package:cmms2/models/assetmeter.dart';
import 'package:cmms2/models/workorderpart.dart';
import 'package:cmms2/view/wopart_detail.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'dart:convert';

import 'assetmeterdetail.dart';

class ListViewAssetMeter extends StatefulWidget {
  final int id;
  const ListViewAssetMeter({Key? key, required this.id}) : super(key: key);
  @override
  _ListViewAssetMeterState createState() => _ListViewAssetMeterState();
}

class _ListViewAssetMeterState extends State<ListViewAssetMeter>
    with AutomaticKeepAliveClientMixin<ListViewAssetMeter> {
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
      body: AssetMeterListView(id: widget.id),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: new Icon(Icons.photo),
                      title: new Text('Photo'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: new Icon(Icons.music_note),
                      title: new Text('Music'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: new Icon(Icons.videocam),
                      title: new Text('Video'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: new Icon(Icons.share),
                      title: new Text('Share'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}

class AssetMeterListView extends StatelessWidget {
  const AssetMeterListView({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  Future<List<AssetMeterReading>> _fetchAssetMeter(id) async {
    final response = await http.get(
        Uri.parse(ServerStatus.ServerAddress + '/api/v1/Asset/Meters/$id/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((task) => new AssetMeterReading.fromJson(task))
          .toList();
    } else {
      throw Exception('Failed  to load wopart from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AssetMeterReading>>(
      future: _fetchAssetMeter(this.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<AssetMeterReading>? data = snapshot.data;
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

  Card newMethod(dynamic context, AssetMeterReading index) {
    return new Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        elevation: 10.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AssetMeterDetail(id: index.id)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text(index.assetMeterMeterReading.toString() +
                    ' ' +
                    index.assetMeterMeterReadingUnit!.meterAbbr),
                subtitle:
                    Text(index.assetMeterMeterReadingUnit!.meterDescription),
                leading: CircleAvatar(backgroundColor: Colors.green[200]),
                trailing: Icon(Icons.ac_unit)),
          ),
        ));
  }
}
