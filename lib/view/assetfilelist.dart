import 'dart:io';

import 'package:cmms2/glob.dart';
import 'package:cmms2/models/assetfile.dart';
import 'package:cmms2/models/wofile.dart';

import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

import 'fab.dart';

class ListViewAssetFile extends StatefulWidget {
  final int id;
  const ListViewAssetFile({Key? key, required this.id}) : super(key: key);
  @override
  _ListViewAssetFileState createState() => _ListViewAssetFileState();
}

class _ListViewAssetFileState extends State<ListViewAssetFile>
    with AutomaticKeepAliveClientMixin<ListViewAssetFile> {
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
      body: AssetFileListView(id: widget.id),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.format_size),
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

class AssetFileListView extends StatefulWidget {
  const AssetFileListView({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  _AssetFileListViewState createState() => _AssetFileListViewState();
}

class _AssetFileListViewState extends State<AssetFileListView> {
  // late Directory appDocDir;
  // Future<Directory?>? _appDocumentsDirectory;
  late String dir;
  Future<Directory> _requestAppDocumentsDirectory() async {
    return getApplicationDocumentsDirectory();
  }

  Future<List<AssetFile>> _fetchassetFile(id) async {
    // appDocDir = await getApplicationDocumentsDirectory();
    _requestAppDocumentsDirectory().then((value) => dir = value.path);

    final response = await http.get(
        Uri.parse(ServerStatus.ServerAddress + '/api/v1/Asset/Files/$id/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((task) => new AssetFile.fromJson(task)).toList();
    } else {
      throw Exception('Failed  to load wopart from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AssetFile>>(
      future: _fetchassetFile(this.widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<AssetFile>? data = snapshot.data;
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

  Card newMethod(dynamic context, AssetFile index) {
    print(ServerStatus.ServerAddress + index.assetFile);

    return new Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        elevation: 10.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () async {
            final taskId = await FlutterDownloader.enqueue(
              url: ServerStatus.ServerAddress + index.assetFile,
              savedDir: dir,
              // 'the path of directory where you want to save downloaded files',
              showNotification:
                  true, // show download progress in status bar (for Android)
              openFileFromNotification:
                  true, // click on notification to open downloaded file (for Android)
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text((index.assetFile.split('/').last)),
                subtitle: Text('نام فایل'),
                leading: CircleAvatar(backgroundColor: Colors.green[200]),
                trailing: Icon(Icons.ac_unit)),
          ),
        ));
  }
}
