import 'package:cmms2/models/part.dart';

class Stock {
  int id;
  final Part stockItem;
  int qtyOnHand;
  int minQty;
  int aisle;
  int row;
  int bin;
  int location;

  Stock(
      {required this.id,
      required this.stockItem,
      required this.qtyOnHand,
      required this.minQty,
      required this.aisle,
      required this.row,
      required this.bin,
      required this.location});

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      stockItem: (json['stockItem'] != null)
          ? Part.fromJson(json['stockItem'])
          : Part(
              id: 1,
              partAccount: "1",
              partBarcode: '1',
              partChargeDepartment: "1",
              partCode: "1",
              partDescription: "1",
              partInventoryCode: "1",
              partLastPrice: 1000,
              partMake: "1",
              partModel: "1",
              partName: "بدون نام",
              partNotes: "1232"),
      qtyOnHand: json['qtyOnHand'],
      minQty: json['minQty'],
      aisle: json['aisle'],
      row: json['row'],
      bin: json['bin'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    // if (this.stockItem != null) {
    data['stockItem'] = this.stockItem.toJson();
    // }
    data['qtyOnHand'] = this.qtyOnHand;
    data['minQty'] = this.minQty;
    data['aisle'] = this.aisle;
    data['row'] = this.row;
    data['bin'] = this.bin;
    data['location'] = this.location;
    return data;
  }
}
