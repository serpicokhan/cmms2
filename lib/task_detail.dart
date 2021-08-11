import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'glob.dart';
import 'tasklist.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

Future<Task> fetchTask(int id) async {
  final response = await http
      .get(Uri.parse(ServerStatus.ServerAddress + '/api/v1/Task/$id/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Task.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class _TaskDetailState extends State<TaskDetail>
    with AutomaticKeepAliveClientMixin<TaskDetail> {
  late Future<Task> futureTaskDetail;
  @override
  void initState() {
    super.initState();
    futureTaskDetail = fetchTask(widget.id);
  }

  var items = ['', 'عمومی', 'متنی', 'متریک'];

  String selectText(int index) {
    return 'درخواست شده';
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
          title: Text('جزییات فعالیت'),
        ),
        body: Center(
          child: FutureBuilder<Task>(
            future: futureTaskDetail,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new Scaffold(
                  body: new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new Text(items[snapshot.data!.taskTypes]),
                        subtitle: const Text('نوع فعالیت'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new Text(snapshot.data!.taskDescription),
                        subtitle: const Text('شرح'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(snapshot.data!.taskTimeEstimate.toString()),
                        subtitle: const Text('زمان تخمینی'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new Text(snapshot.data!.taskAssignedToUser),
                        subtitle: const Text('اختصاص به کاربر'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new TextField(
                          controller: TextEditingController()
                            ..text = snapshot.data!.taskStartDate,
                        ),
                        subtitle: const Text('تاریخ شروع'),
                      ),
                      new ListTile(
                        leading: const Icon(Icons.phone),
                        title: new TextField(
                          controller: TextEditingController()
                            ..text = snapshot.data!.taskStartTime,
                        ),
                        subtitle: const Text('زمان شروع'),
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
