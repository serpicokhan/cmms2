import 'dart:convert';

import 'package:cmms2/models/assetmeter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../glob.dart';

class AssetMeterDetail extends StatefulWidget {
  const AssetMeterDetail({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _AssetMeterDetailState createState() => _AssetMeterDetailState();
}

Future<AssetMeterReading> fetchAssetMeterDetail(int id) async {
  final response = await http
      .get(Uri.parse(ServerStatus.ServerAddress + '/api/v1/Asset/Meter/$id/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return AssetMeterReading.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class _AssetMeterDetailState extends State<AssetMeterDetail>
    with AutomaticKeepAliveClientMixin<AssetMeterDetail> {
  late Future<AssetMeterReading> futureAssetMeterDetail;
  @override
  void initState() {
    super.initState();
    futureAssetMeterDetail = fetchAssetMeterDetail(widget.id);
  }

  String dropdownvalue = '';
  String dropdownvalue2 = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('جزییات قطعات مصرفی'),
        ),
        body: Center(
          child: FutureBuilder<AssetMeterReading>(
            future: futureAssetMeterDetail,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new Scaffold(
                  body: new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new Text(
                            snapshot.data!.assetMeterMeterReading.toString()),
                        subtitle: const Text('مقدار'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new Text(snapshot.data!
                            .assetMeterMeterReadingUnit!.meterDescription),
                        subtitle: const Text('واحد'),
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
