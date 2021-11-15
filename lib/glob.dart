import 'dart:convert';
import 'package:cmms2/models/metercode.dart';
import 'package:http/http.dart' as http;

class ServerStatus {
  static int newestBinary = 20;
  static bool serverUp = false;
  static const String ServerAddress = "http://172.16.2.149:8000";
  static var priority = [
    '',
    'خیلی زیاد',
    'زیاد',
    'متوسط',
    'کم',
    'خیلی کم',
  ];
  static late List<MaintenanceType> maintenanceType = [];
  static late List<MeterCode> meterCodes = [];
  static Future<List<MaintenanceType>> initMaintenaceType() {
    return fetchMaintenaceType();
  }

  static void init() {
    fetchMaintenaceType().then<List<MaintenanceType>>((value) {
      maintenanceType = value;
      return value;
    });
    fetchMeterCode().then<List<MeterCode>>((value) {
      meterCodes = value;
      return value;
    });
  }
}

class MaintenanceType {
  final int id;
  final String color;
  final String name;

  MaintenanceType({
    required this.id,
    required this.color,
    required this.name,
  });

  factory MaintenanceType.fromJson(Map<String, dynamic> json) {
    return MaintenanceType(
      id: json['id'],
      color: json['color'],
      name: json['name'],
    );
  }
}

Future<List<MaintenanceType>> fetchMaintenaceType() async {
  print("http://{$ServerStatus.ServerAddress}/v1/mt/");
  final response =
      await http.get(Uri.parse(ServerStatus.ServerAddress + "/api/v1/mt/"));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse
        .map((job) => new MaintenanceType.fromJson(job))
        .toList();
  } else {
    throw Exception('Failed to load jobs from API');
  }
}

Future<List<MeterCode>> fetchMeterCode() async {
  // print("http://{$ServerStatus.ServerAddress}/v1/mt/");
  final response = await http
      .get(Uri.parse(ServerStatus.ServerAddress + "/api/v1/MeterCode/"));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse.map((job) => new MeterCode.fromJson(job)).toList();
  } else {
    throw Exception('Failed to load jobs from API');
  }
}
