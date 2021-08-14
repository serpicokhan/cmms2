import 'package:cmms2/models/metercode.dart';

class AssetMeterReading {
  int id;
  double assetMeterMeterReading;
  int assetMeterLocation;
  MeterCode? assetMeterMeterReadingUnit;
  int assetWorkorderMeterReading;

  AssetMeterReading(
      {required this.id,
      required this.assetMeterMeterReading,
      required this.assetMeterLocation,
      required this.assetMeterMeterReadingUnit,
      required this.assetWorkorderMeterReading});
  factory AssetMeterReading.fromJson(Map<String, dynamic> json) {
    return AssetMeterReading(
        id: json['id'],
        assetMeterMeterReadingUnit: (json['assetMeterMeterReadingUnit'] != null)
            ? MeterCode.fromJson(json['assetMeterMeterReadingUnit'])
            : null,
        assetMeterLocation: (json['assetMeterLocation'] != null)
            ? json['assetMeterLocation']
            : 0,
        assetMeterMeterReading: (json['assetMeterMeterReading'] != null)
            ? json['assetMeterMeterReading']
            : 0.0,
        assetWorkorderMeterReading: (json['assetWorkorderMeterReading'] != null)
            ? json['assetWorkorderMeterReading']
            : 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['assetMeterMeterReading'] = this.assetMeterMeterReading;
    data['assetMeterLocation'] = this.assetMeterLocation;
    data['assetMeterMeterReadingUnit'] = this.assetMeterMeterReadingUnit;
    data['assetWorkorderMeterReading'] = this.assetWorkorderMeterReading;
    return data;
  }
}
