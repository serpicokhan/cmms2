import 'package:cmms2/models/assetcategory.dart';

class Asset {
  int id;
  Asset? assetIsPartOf;
  Asset? assetIsLocatedAt;
  AssetCategory assetCategory;
  int assetTypes;
  String assetName;
  String? assetDescription;
  String? assetCode;
  String? assetAddress;
  String? assetCity;
  String? assetState;
  String? assetZipcode;
  String? assetCountry;
  String? assetAccount;
  String? assetChargeDepartment;
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
                isPartOf: 1),
        assetTypes: json['assetTypes'] as int,
        assetName: json['assetName'] as String,
        assetDescription: json['assetDescription'] as String,
        assetCode: json['assetCode'] as String,
        assetAddress: json['assetAddress'] as String,
        assetCity: json['assetCity'] as String,
        assetState: json['assetState'] as String,
        assetZipcode: json['assetZipcode'] as String,
        assetCountry: json['assetCountry'] as String,
        assetAccount: json['assetAccount'] as String,
        assetChargeDepartment: json['assetChargeDepartment'] as String,
        assetNotes: json['assetNotes'] as String,
        assetBarcode: json['assetBarcode'] as String,
        assetHasPartOf: json['assetHasPartOf'] as bool,
        assetAisel: json['assetAisel'] as int,
        assetRow: json['assetRow'] as int?,
        assetBin: json['assetBin'] as int?,
        assetManufacture: json['assetManufacture'] as String?,
        assetModel: json['assetModel'] as String?,
        assetSerialNumber: json['assetSerialNumber'] as String?,
        assetStatus: json['assetStatus'] as bool?,
        assetIsStock: json['assetIsStock'] as bool?,
        assetMachineCategory: json['assetMachineCategory'] as int?);
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

    data['assetCategory'] = this.assetCategory.toJson();

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
