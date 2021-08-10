import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WorkOrder {
  final int id;
  final String summaryOfIssue;
  final String datecreated;
  final String woAsset;

  WorkOrder(
      {required this.id,
      required this.summaryOfIssue,
      required this.datecreated,
      required this.woAsset});

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      id: json['id'],
      summaryOfIssue: json['summaryofIssue'],
      woAsset: json['woAsset'],
      datecreated: json['datecraeted'],
    );
  }
}

class MyClass extends StatefulWidget {
  const MyClass({Key? key}) : super(key: key);

  @override
  _MyClassState createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Job>? data = snapshot.data;
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildSuggestions(data) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: data.length,
        itemBuilder: (context, index) {
          if (index.isOdd) return const Divider();
          return _buildRow(data[index].summaryOfIssue);
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(String pair) {
    return ListTile(
      title: Text(
        pair,
        style: TextStyle(fontSize: 10.0),
      ),
    );
  }
}

class WorkOrdersListView extends StatelessWidget {
  // final _saved = <int>{}; // NEW
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WorkOrder>>(
      future: _fetchWorkOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<WorkOrder>? data = snapshot.data;
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<WorkOrder>> _fetchWorkOrders() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.50:8000/api/v1/wos/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((job) => new WorkOrder.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: data.length,
        itemBuilder: (context, index) {
          if (index.isOdd) return const Divider();
          return _tile(data[index].id, data[index].summaryOfIssue,
              data[index].woAsset, data[index].datecreated, Icons.work);
        });
  }

  Card _tile(int id, String summary, String woAsset, String datecreated,
      IconData icon) {
    // final alreadySaved = false;
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      elevation: 10.0,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => SecondRoute()),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                summary,
                style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(
                woAsset,
                style: TextStyle(fontSize: 12.0, color: Colors.green[550]),
              ),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: IconButton(
              //     icon: const Icon(Icons.ac_unit_outlined),
              //     onPressed: () => {},
              //   ),
              // ),
              SizedBox(
                height: 16.0,
              ),
              TextButton(
                onPressed: () {}, //delete,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.delete), Text('Delete')],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
