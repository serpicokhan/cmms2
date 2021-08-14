import 'package:cmms2/glob.dart';
import 'package:cmms2/models/assetmeter.dart';
import 'package:cmms2/models/metercode.dart';

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
  Future<AssetMeterReading>? _futureAlbum;
  final TextEditingController _controller = TextEditingController();

  FutureBuilder<AssetMeterReading> buildFutureBuilder() {
    return FutureBuilder<AssetMeterReading>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.assetMeterMeterReading.toString());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }

  String dropdownvalue2 = '';
  @override
  Widget build(BuildContext context) {
    ServerStatus.meterCodes.add(new MeterCode(
        id: 0, meterCode: '', meterDescription: '', meterAbbr: ''));
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _controller,
                      decoration:
                          const InputDecoration(hintText: 'Enter Title'),
                    ),
                    new ListTile(
                      leading: const Icon(Icons.phone),
                      title: DropdownButton<String>(
                        value: '',
                        // icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue2 = newValue!;
                          });
                        },
                        items: ServerStatus.meterCodes
                            .map<DropdownMenuItem<String>>((MeterCode value) {
                          return DropdownMenuItem<String>(
                              value: value.meterDescription,
                              child: Text(value.meterDescription));
                        }).toList(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureAlbum =
                              createAlbum(int.parse(widget.id.toString()));
                        });
                      },
                      child: const Text('Create Data'),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}

Future<AssetMeterReading> createAlbum(int id) async {
  final response = await http.post(
    Uri.parse(ServerStatus.ServerAddress + '/api/v1/Asset/Meters/Add/$id/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': id.toString(),
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return AssetMeterReading.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
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
