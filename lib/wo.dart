import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'dart:convert';

import 'newpage.dart';
import 'wo_detail.dart';

class ListViewHome extends StatefulWidget {
  @override
  _ListViewHomeState createState() => _ListViewHomeState();
}

class _ListViewHomeState extends State<ListViewHome>
    with AutomaticKeepAliveClientMixin<ListViewHome> {
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
    return WorkOrderListView(
        titles: titles, subtitles: subtitles, icons: icons);
  }
}

class Job {
  final int id;
  final String position;
  final String company;
  final String description;
  final String color;

  Job(
      {required this.id,
      required this.position,
      required this.company,
      required this.description,
      required this.color});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      position: json['summaryofIssue'],
      company: json['woAsset'],
      description: json['datecreated'],
      color: json['maintenanceType'],
    );
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class WorkOrderListView extends StatelessWidget {
  const WorkOrderListView({
    Key? key,
    required this.titles,
    required this.subtitles,
    required this.icons,
  }) : super(key: key);

  final List<String> titles;
  final List<String> subtitles;
  final List<IconData> icons;
  Future<List<Job>> _fetchJobs() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.51:8000/api/v1/wos/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Job>? data = snapshot.data;
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
        // itemCount: titles.length,
        itemBuilder: (context, index) {
      return newMethod(context, data[index], data[index].color);
    });
  }

  Card newMethod(dynamic context, Job index, String color) {
    return Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        elevation: 10.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TabBarWorkOrder(
                        id2: index.id,
                      )),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text(index.position),
                subtitle: Text(index.position),
                leading: CircleAvatar(backgroundColor: HexColor.fromHex(color)),
                trailing: Icon(icons[0])),
          ),
        ));
  }
}
