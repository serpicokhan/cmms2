import 'dart:convert';

import 'package:cmms2/models/workorderpart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WorkorderPartDetail extends StatefulWidget {
  const WorkorderPartDetail({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _WorkorderPartDetailState createState() => _WorkorderPartDetailState();
}

Future<WorkorderPart> fetchWorkorderPart(int id) async {
  final response =
      await http.get(Uri.parse('http://192.168.1.50:8000/api/v1/WoPart/$id/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return WorkorderPart.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class _WorkorderPartDetailState extends State<WorkorderPartDetail>
    with AutomaticKeepAliveClientMixin<WorkorderPartDetail> {
  late Future<WorkorderPart> futureWorkorderPartDetail;
  @override
  void initState() {
    super.initState();
    futureWorkorderPartDetail = fetchWorkorderPart(widget.id);
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
          child: FutureBuilder<WorkorderPart>(
            future: futureWorkorderPartDetail,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new Scaffold(
                  body: new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new Text(
                            snapshot.data!.woPartStock.stockItem.partName),
                        subtitle: const Text('نام قطعه'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new Text(
                            snapshot.data!.woPartPlannedQnty.toString()),
                        subtitle: const Text('کمیت پیشنهادی'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(snapshot.data!.woPartActulaQnty.toString()),
                        subtitle: const Text('کمیت مرود استفاده'),
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
