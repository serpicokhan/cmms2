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
      .get(Uri.parse('http://192.168.2.175:8000/api/v1/wos_detail/$id'));

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

  var items = [
    '',
    'درخواست شده',
    'متوقف',
    'درفت',
    'تخصیص داده شده',
    'باز',
    'در حال پیشرفت',
    'بسته شده کامل',
    'بسته شده ناقص',
    'در انتظار قطعه',
  ];
  String selectText(int index) {
    return 'درخواست شده';
  }

  String dropdownvalue = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<Job>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new Scaffold(
                  body: new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: DropdownButton<String>(
                          value: items[snapshot.data!.woStatus],
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                          items: items
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new Text(snapshot.data!.datecreated +
                            ' ,' +
                            snapshot.data!.timecreated.substring(0, 8)),
                        subtitle: const Text('زمان ایجاد'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(snapshot.data!.description),
                        subtitle: const Text('دستورالعمل'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new Text(snapshot.data!.priority.toString()),
                        subtitle: const Text('اولویت'),
                      ),
                      new ListTile(
                          leading: const Icon(Icons.email),
                          title: new Text(snapshot.data!.maintenanceType)),
                      const Divider(
                        height: 1.0,
                      ),
                      new ListTile(
                        leading: const Icon(Icons.label),
                        title: Text(snapshot.data!.assignedTo),
                        subtitle: const Text('کاربر اختصاص داده شده'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.today),
                        title: Text(snapshot.data!.reqUser),
                        subtitle: const Text('کاربر درخواست کننده'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.location_history),
                        title: Text(snapshot.data!.company),
                        subtitle: const Text('Not specified'),
                      )
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
