import 'package:cmms2/task_detail.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'dart:convert';

import 'glob.dart';

class ListViewTask extends StatefulWidget {
  final int id;
  const ListViewTask({Key? key, required this.id}) : super(key: key);
  @override
  _ListViewTaskState createState() => _ListViewTaskState();
}

class _ListViewTaskState extends State<ListViewTask>
    with AutomaticKeepAliveClientMixin<ListViewTask> {
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
    return TaskListView(id: widget.id);
  }
}

class Task {
  final int id;
  final int taskTypes;
  // final int taskMetrics;
  final String taskDescription;
  final String taskAssignedToUser;
  final String taskStartDate;

  final String taskStartTime;
  final double taskTimeEstimate;
  final String taskDateCompleted;
  final String taskTimeCompleted;
  final double taskTimeSpent;
  final int workOrder;

  Task(
      {required this.id,
      required this.taskTypes,
      // required this.taskMetrics,
      required this.taskDescription,
      required this.taskAssignedToUser,
      required this.taskStartDate,
      required this.taskStartTime,
      required this.taskTimeEstimate,
      required this.taskDateCompleted,
      required this.taskTimeCompleted,
      required this.workOrder,
      required this.taskTimeSpent});

  factory Task.fromJson(Map<String, dynamic> json) {
    Task jb = Task(
        id: json['id'],
        taskAssignedToUser: json['taskAssignedToUser'],
        taskDateCompleted: (json['taskDateCompleted'] == null)
            ? 'ندارد'
            : json['taskDateCompleted'],
        taskDescription: (json['taskDescription'] == null)
            ? 'ندارد'
            : json['taskDescription'],
        // taskMetrics:
        //     (json['taskMetrics'] == null) ? 'ندارد' : json['taskMetrics'],
        taskStartDate: (json['taskStartDate'] == null)
            ? 'مشخص نشده'
            : json['taskStartDate'],
        taskStartTime: (json['taskStartTime'] == null)
            ? 'مشخص نشده'
            : json['taskStartTime'],
        taskTimeCompleted: (json['taskTimeCompleted'] == null)
            ? 'مشخص نشده'
            : json['taskTimeCompleted'],
        taskTimeEstimate:
            (json['taskTimeEstimate'] == null) ? 0 : json['taskTimeEstimate'],
        taskTimeSpent:
            (json['taskTimeSpent'] == null) ? 0 : json['taskTimeSpent'],
        workOrder: (json['workOrder'] == null) ? 1 : json['workOrder'],
        taskTypes: (json['taskTypes'] == null) ? 1 : json['taskTypes']);
    // print(jb.maintenanceType);
    return jb;
  }
}

class TaskListView extends StatelessWidget {
  const TaskListView({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  Future<List<Task>> _fetchTask(id) async {
    final response = await http
        .get(Uri.parse(ServerStatus.ServerAddress + '/api/v1/Tasks/$id/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((task) => new Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: _fetchTask(this.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Task>? data = snapshot.data;
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

  Card newMethod(dynamic context, Task index) {
    return new Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        elevation: 10.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskDetail(id: index.id)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text(index.taskDescription),
                subtitle: Column(
                  children: <Widget>[
                    Text(index.taskDescription),
                    (index.taskTypes == 3)
                        ? Align(
                            child: TextButton(
                                child: Text(
                                  'button',
                                ),
                                onPressed: () {}),
                            alignment: Alignment.centerLeft,
                          )
                        : Container()
                  ],
                ),
                leading: CircleAvatar(backgroundColor: Colors.green[200]),
                trailing: Icon(Icons.ac_unit)),
          ),
        ));
  }
}
