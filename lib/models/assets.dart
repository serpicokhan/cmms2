import 'package:cmms2/models/assetcategory.dart';

class Asset {
  int id;
  Asset? assetIsPartOf;
  Asset? assetIsLocatedAt;
  AssetCategory assetCategory;
  int assetTypes;
  String assetName;
  String assetDescription;
  String? assetCode;
  String assetAddress;
  String assetCity;
  String assetState;
  String assetZipcode;
  String assetCountry;
  String assetAccount;
  String assetChargeDepartment;
  String? assetNotes;
  String? assetBarcode;
  bool? assetHasPartOf;
  int? assetAisel;
  int? assetRow;
  int? assetBin;
  String? assetManufacture;
  String? assetModel;
  String? assetSerialNumber;
  bool? assetStatus;
  bool? assetIsStock;
  int? assetMachineCategory;

  Asset(
      {required this.id,
      required this.assetIsPartOf,
      required this.assetIsLocatedAt,
      required this.assetCategory,
      required this.assetTypes,
      required this.assetName,
      required this.assetDescription,
      required this.assetCode,
      required this.assetAddress,
      required this.assetCity,
      required this.assetState,
      required this.assetZipcode,
      required this.assetCountry,
      required this.assetAccount,
      required this.assetChargeDepartment,
      required this.assetNotes,
      required this.assetBarcode,
      required this.assetHasPartOf,
      required this.assetAisel,
      required this.assetRow,
      required this.assetBin,
      required this.assetManufacture,
      required this.assetModel,
      required this.assetSerialNumber,
      required this.assetStatus,
      required this.assetIsStock,
      required this.assetMachineCategory});

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
        id: json['id'],
        assetIsPartOf: json['assetIsPartOf'] != null
            ? new Asset.fromJson(json['assetIsPartOf'])
            : null,
        assetIsLocatedAt: json['assetIsLocatedAt'] != null
            ? new Asset.fromJson(json['assetIsLocatedAt'])
            : null,
        assetCategory: json['assetCategory'] != null
            ? new AssetCategory.fromJson(json['assetCategory'])
            : new AssetCategory(
                id: 1,
                name: 'name',
                code: 'code',
                description: 'description',
                priority: 1,
              ),
        assetTypes: json['assetTypes'] != null ? (json['assetTypes']) : 1,
        assetName: json['assetName'] != null ? (json['assetName']) : 'نامشخص',
        assetDescription: json['assetDescription'] != null
            ? (json['assetDescription'])
            : 'نامشخص',
        assetCode: json['assetCode'] != null ? (json['assetCode']) : 'نامشخص',
        assetAddress:
            json['assetAddress'] != null ? (json['assetAddress']) : 'نامشخص',
        assetCity: json['assetCity'] != null ? (json['assetCity']) : 'نامشخص',
        assetState:
            json['assetState'] != null ? (json['assetState']) : 'نامشخص',
        assetZipcode:
            json['assetZipcode'] != null ? (json['assetZipcode']) : 'نامشخص',
        assetCountry:
            json['assetCountry'] != null ? (json['assetCountry']) : 'نامشخص',
        assetAccount:
            json['assetAccount'] != null ? (json['assetAccount']) : 'نامشخص',
        assetChargeDepartment: json['assetChargeDepartment'] != null
            ? (json['assetChargeDepartment'])
            : 'نامشخص',
        assetNotes:
            json['assetNotes'] != null ? (json['assetNotes']) : 'نامشخص',
        assetBarcode:
            json['assetBarcode'] != null ? (json['assetBarcode']) : 'نامشخص',
        assetHasPartOf:
            json['assetHasPartOf'] != null ? (json['assetHasPartOf']) : false,
        assetAisel: json['assetAisel'] != null ? (json['assetAisel']) : 0,
        assetRow: json['assetRow'] != null ? (json['assetRow']) : 0,
        assetBin: json['assetBin'] != null ? (json['assetBin']) : 0,
        assetManufacture: json['assetManufacture'] != null
            ? (json['assetManufacture'])
            : 'نامشخص',
        assetModel:
            json['assetModel'] != null ? (json['assetModel']) : 'نامشخص',
        assetSerialNumber: json['assetSerialNumber'] != null
            ? (json['assetSerialNumber'])
            : 'نامشخص',
        assetStatus:
            json['assetStatus'] != null ? (json['assetStatus']) : false,
        assetIsStock:
            json['assetIsStock'] != null ? (json['assetIsStock']) : false,
        assetMachineCategory: 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.assetIsPartOf != null) {
      data['assetIsPartOf'] = this.assetIsPartOf!.toJson();
    }
    if (this.assetIsLocatedAt != null) {
      data['assetIsLocatedAt'] = this.assetIsLocatedAt!.toJson();
    }

    // data['assetCategory'] = this.assetCategory.toJson();

    data['assetTypes'] = this.assetTypes;
    data['assetName'] = this.assetName;
    data['assetDescription'] = this.assetDescription;
    data['assetCode'] = this.assetCode;
    data['assetAddress'] = this.assetAddress;
    data['assetCity'] = this.assetCity;
    data['assetState'] = this.assetState;
    data['assetZipcode'] = this.assetZipcode;
    data['assetCountry'] = this.assetCountry;
    data['assetAccount'] = this.assetAccount;
    data['assetChargeDepartment'] = this.assetChargeDepartment;
    data['assetNotes'] = this.assetNotes;
    data['assetBarcode'] = this.assetBarcode;
    data['assetHasPartOf'] = this.assetHasPartOf;
    data['assetAisel'] = this.assetAisel;
    data['assetRow'] = this.assetRow;
    data['assetBin'] = this.assetBin;
    data['assetManufacture'] = this.assetManufacture;
    data['assetModel'] = this.assetModel;
    data['assetSerialNumber'] = this.assetSerialNumber;
    data['assetStatus'] = this.assetStatus;
    data['assetIsStock'] = this.assetIsStock;
    data['assetMachineCategory'] = this.assetMachineCategory;
    return data;
  }
}
