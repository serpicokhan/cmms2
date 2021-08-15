import 'dart:io';

import 'package:cmms2/glob.dart';

import 'package:cmms2/models/assetfile.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'fab.dart';
import 'package:path/path.dart' as path;
// ignore: import_of_legacy_library_into_null_safe
import 'package:ext_storage/ext_storage.dart' show ExtStorage;

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
  final Dio _dio = Dio();

  // late Directory appDocDir;
  // Future<Directory?>? _appDocumentsDirectory;
  late String dir;
  var imageUrl =
      "https://www.itl.cat/pngfile/big/10-100326_desktop-wallpaper-hd-full-screen-free-download-full.jpg";
  bool downloading = true;
  String downloadingStr = "No data";
  String savePath = "";
  Future<Directory?> _requestAppDocumentsDirectory() async {
    return getExternalStorageDirectory();
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory dir2 = await getApplicationDocumentsDirectory();

    path = '${dir2.path}/$uniqueFileName';

    return path;
  }

  void getImage(String url) async {
    var uri = Uri.parse(url);

    Map body = {'Session': '123213', 'UserId': '12312321'};
    try {
      final response = await http.post(uri,
          headers: {"Content-Type": "application/json"},
          body: utf8.encode(json.encode(body)));

      if (response.contentLength == 0) {
        return;
      }
      var path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      Directory? tempDir = await getExternalStorageDirectory();
      String tempPath = path;
      File file = new File('$tempPath/123.jpg');
      await file.writeAsBytes(response.bodyBytes);
      _showAction2(context, "completed");
      _showAction2(context, '$tempPath/123.jpg');
    } catch (value) {
      _showAction2(context, value.toString());
    }
  }

  Future downloadFile() async {
    try {
      Dio dio = Dio();

      String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);

      savePath = await getFilePath(fileName);
      await dio.download(imageUrl, savePath, onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          // download = (rec / total) * 100;
          downloadingStr = "Downloading Image : $rec";
        });
      });
      setState(() {
        downloading = false;
        downloadingStr = "Completed";
      });
    } catch (e) {
      _showAction2(context, e.toString());
    }
  }

  Future<List<AssetFile>> _fetchassetFile(id) async {
    // appDocDir = await getApplicationDocumentsDirectory();
    _requestAppDocumentsDirectory().then((value) => dir = value!.path);

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

  Future<void> _download(String _fileUrl, String _fileName) async {
    final dir = await getExternalStorageDirectory();
    final isPermissionStatusGranted = await Permission.storage.request();

    if (isPermissionStatusGranted.isGranted) {
      final savePath = path.join(dir!.path, _fileName);
      await _startDownload(_fileUrl, savePath);
    } else {
      // handle the scenario when user declines the permissions
    }
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

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      // setState(() {
      //   _progress = (received / total * 100).toStringAsFixed(0) + "%";
      // });
    }
  }

  Future<void> _startDownload(String _fileUrl, String savePath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(_fileUrl, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      _showAction2(context, ex.toString());
      result['error'] = ex.toString();
    } finally {
      // await _showNotification(result);
    }
  }

  // Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
  //   final android = AndroidNotificationDetails(
  //       'channel id', 'channel name', 'channel description',
  //       priority: Priority.high, importance: Importance.max);
  //   final iOS = IOSNotificationDetails();
  //   final platform = NotificationDetails(android: android, iOS: iOS);
  //   final json = jsonEncode(downloadStatus);
  //   final isSuccess = downloadStatus['isSuccess'];

  //   await FlutterLocalNotificationsPlugin.(
  //       0, // notification id
  //       isSuccess ? 'Success' : 'Failure',
  //       isSuccess
  //           ? 'File has been downloaded successfully!'
  //           : 'There was an error while downloading the file.',
  //       platform,
  //       payload: json);
  // }

  Card newMethod(dynamic context, AssetFile index) {
    // print(ServerStatus.ServerAddress + index.assetFile);

    return new Card(
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        elevation: 10.0,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () async {
            // _download(
            //     'http://ipv4.download.thinkbroadband.com/5MB.zip', '5MB.zip');
            // downloadFile();
            getImage(
                "https://www.itl.cat/pngfile/big/10-100326_desktop-wallpaper-hd-full-screen-free-download-full.jpg");
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text(Uri.decodeFull((index.assetFile.split('/').last))),
                subtitle: Text('نام فایل'),
                leading: CircleAvatar(backgroundColor: Colors.green[200]),
                trailing: Icon(Icons.ac_unit)),
          ),
        ));
  }
}
