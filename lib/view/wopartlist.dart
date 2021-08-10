import 'package:cmms2/glob.dart';
import 'package:cmms2/models/workorderpart.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'dart:convert';

class ListViewWorkorderPart extends StatefulWidget {
  final int id;
  const ListViewWorkorderPart({Key? key, required this.id}) : super(key: key);
  @override
  _ListViewWorkorderPartState createState() => _ListViewWorkorderPartState();
}

class _ListViewWorkorderPartState extends State<ListViewWorkorderPart>
    with AutomaticKeepAliveClientMixin<ListViewWorkorderPart> {
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
    return WorkorderPartListView(id: widget.id);
  }
}

class WorkorderPartListView extends StatelessWidget {
  const WorkorderPartListView({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  Future<List<WorkorderPart>> _fetchwoPart(id) async {
    final response = await http
        .get(Uri.parse(ServerStatus.ServerAddress + '/api/v1/WoParts/$id'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((task) => new WorkorderPart.fromJson(task))
          .toList();
    } else {
      throw Exception('Failed  to load wopart from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WorkorderPart>>(
      future: _fetchwoPart(this.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<WorkorderPart>? data = snapshot.data;
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
      return newMethod(context, data[index]);
    });
  }

  Card newMethod(dynamic context, WorkorderPart index) {
    return new Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        elevation: 10.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => TabBarWorkOrder(
            //             id2: index.id,
            //           )),
            // );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text(index.woPartStock.stockItem.partName),
                subtitle: Text(index.woPartActulaQnty.toString()),
                leading: CircleAvatar(backgroundColor: Colors.green[200]),
                trailing: Icon(Icons.ac_unit)),
          ),
        ));
  }
}
