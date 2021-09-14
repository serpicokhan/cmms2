import 'dart:io';
import 'dart:typed_data';

import 'package:cmms2/glob.dart';
import 'package:cmms2/models/wofile.dart';
import 'package:cmms2/view/record/recorded_list_view.dart';
import 'package:cmms2/view/record/recorder_view.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import 'fab.dart';

class ListViewWorkorderFile extends StatefulWidget {
  final int id;
  const ListViewWorkorderFile({Key? key, required this.id}) : super(key: key);
  @override
  _ListViewWorkorderFileState createState() => _ListViewWorkorderFileState();
}

downloadFile2(String url, String dir, context) async {
  var httpClient = http.Client();
  var uri = Uri.parse(url);
  var request = new http.Request('GET', Uri.parse(url));
  var response = httpClient.send(request);
  // String dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage
  //     .DIRECTORY_DOWNLOADS); //(await getApplicationDocumentsDirectory()).path;
  final filename = Uri.decodeFull(path.basename(url));
  final extension = path.extension(url);

  List<List<int>> chunks = [];
  int downloaded = 0;

  response.asStream().listen((http.StreamedResponse r) {
    r.stream.listen((List<int> chunk) {
      // Display percentage of completion
      // debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

      chunks.add(chunk);
      downloaded += chunk.length;
    }, onDone: () async {
      // Display percentage of completion
      // debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

      // Save the file
      File file = new File('$dir/$filename');
      try {
        if (!await file.exists()) {
          final Uint8List bytes = Uint8List(r.contentLength!.toInt());
          int offset = 0;
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }
          await file.writeAsBytes(bytes);
          return;
        } else {
          File file2 = new File('$dir/' + Uuid().v4() + ".$extension");
          final Uint8List bytes = Uint8List(r.contentLength!.toInt());
          int offset = 0;
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }
          await file2.writeAsBytes(bytes);
        }
        _showAction2(context, 'completed');
      } catch (e) {
        _showAction2(context, e.toString());
      }
    });
  });
}

void _showAction2(BuildContext context, String index) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(index),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CLOSE'),
          ),
        ],
      );
    },
  );
}

Future<List<WorkorderFile>> _fetchwoFile(id) async {
  // appDocDir = await getApplicationDocumentsDirectory();
  // _requestAppDocumentsDirectory().then((value) => dir = value.path);

  final response = await http
      .get(Uri.parse(ServerStatus.ServerAddress + '/api/v1/WoFiles/$id/'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse
        .map((task) => new WorkorderFile.fromJson(task))
        .toList();
  } else {
    throw Exception('Failed  to load wopart from API');
  }
}

class _ListViewWorkorderFileState extends State<ListViewWorkorderFile>
    with AutomaticKeepAliveClientMixin<ListViewWorkorderFile> {
  late Directory appDirectory;
  List<String> records = [];
  List<String> rec = [];
  @override
  void initState() {
    super.initState();
    _fetchwoFile(widget.id)
        .then((value) => rec = value
            .where((element) => element.woFile.contains('.aac'))
            .map((e) => ServerStatus.ServerAddress + e.woFile)
            .toList())
        .then((value) => setState(() {}));

    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      //   for (var i = 0; i < rec.length; i++) {
      //     downloadFile2(ServerStatus.ServerAddress + '/' + rec[i],
      //         appDirectory.path, context);
      // }

      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    appDirectory.delete();
    super.dispose();
  }

  String lastFile = '';
  _onRecordComplete() {
    records.clear();

    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) {
        records.add(onData.path);
        lastFile = onData.path;
      }
    }).onDone(() {
      // records.sort();
      // records = records.reversed.toList();
      _fetchwoFile(widget.id)
          .then((value) => records = value
              .where((element) => element.woFile.contains('.aac'))
              .map((e) => ServerStatus.ServerAddress + e.woFile)
              .toList())
          .then((value) => setState(() {}));

      setState(() {});
      uploadFile(lastFile, widget.id);
    });
  }

  uploadFile(String pathfile, int id) async {
    var postUri =
        Uri.parse(ServerStatus.ServerAddress + "/api/v1/WoFile/$id/Post");
    var request = new http.MultipartRequest("POST", postUri);
    request.fields['woFile'] = 'blah';
    request.files.add(new http.MultipartFile.fromBytes(
        'woFile', await File(pathfile).readAsBytes(),
        filename: pathfile.split("/").last));
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(pathfile),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );

    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
  }

  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];
  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: RecordListView(
              records: records,
            ),
          ),
          Expanded(flex: 1, child: WorkorderFileListView(id: widget.id)),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          RecorderView(
            onSaved: _onRecordComplete,
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
    );
  }
}

class WorkorderFileListView extends StatefulWidget {
  const WorkorderFileListView({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  _WorkorderFileListViewState createState() => _WorkorderFileListViewState();
}

class _WorkorderFileListViewState extends State<WorkorderFileListView> {
  // late Directory appDocDir;
  // Future<Directory?>? _appDocumentsDirectory;
  late String dir;
  // Future<Directory> _requestAppDocumentsDirectory() async {
  //   return getApplicationDocumentsDirectory();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WorkorderFile>>(
      future: _fetchwoFile(this.widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<WorkorderFile>? data = snapshot.data;
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
          //here ....
          // if (data[index].woFile.contains('.aac')) records.add(onData.path);
          return newMethod(context, data[index]);
        });
  }

  Card newMethod(dynamic context, WorkorderFile index) {
    print(ServerStatus.ServerAddress + index.woFile);

    return new Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        elevation: 10.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () async {
            // final taskId = await FlutterDownloader.enqueue(
            //   url: ServerStatus.ServerAddress + index.woFile,
            //   savedDir: dir,
            //   // 'the path of directory where you want to save downloaded files',
            //   showNotification:
            //       true, // show download progress in status bar (for Android)
            //   openFileFromNotification:
            //       true, // click on notification to open downloaded file (for Android)
            // );
            getApplicationDocumentsDirectory().then((value) {
              downloadFile2(ServerStatus.ServerAddress + '/' + index.woFile,
                  value.path, context);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text((index.woFile.split('/').last)),
                subtitle: Text('نام فایل'),
                leading: CircleAvatar(backgroundColor: Colors.green[200]),
                trailing: Icon(Icons.ac_unit)),
          ),
        ));
  }
}
