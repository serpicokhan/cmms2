import 'dart:convert';

import 'package:cmms2/wo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TabBarWorkOrder extends StatelessWidget {
  const TabBarWorkOrder({Key? key, required this.id2}) : super(key: key);
  final int id2;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              WoDetail(id: id2),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}

class WoDetail extends StatefulWidget {
  const WoDetail({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _WoDetailState createState() => _WoDetailState();
}

Future<Job> fetchAlbum(int id) async {
  final response = await http
      .get(Uri.parse('http://192.168.1.51:8000/api/v1/wos_detail/$id'));

  print(id);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Job.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class _WoDetailState extends State<WoDetail>
    with AutomaticKeepAliveClientMixin<WoDetail> {
  late Future<Job> futureAlbum;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<Job>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(snapshot.data!.position),
                    Text(snapshot.data!.id.toString()),
                    Text(snapshot.data!.description),
                    Text(snapshot.data!.company),
                    // Text(snapshot.data!.position),
                  ],
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
