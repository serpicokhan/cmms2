import 'package:cmms2/models/stock.dart';

import 'part.dart';

class WorkorderPart {
  int id;
  Stock woPartStock;
  double woPartPlannedQnty;
  double woPartActulaQnty;
  String timeStamp;
  int woPartWorkorder;

  WorkorderPart(
      {required this.id,
      required this.woPartStock,
      required this.woPartPlannedQnty,
      required this.woPartActulaQnty,
      required this.timeStamp,
      required this.woPartWorkorder});

  factory WorkorderPart.fromJson(Map<String, dynamic> json) {
    return WorkorderPart(
      id: json['id'],
      woPartStock: json['woPartStock'] != null
          ? Stock.fromJson(json['woPartStock'])
          : Stock(
              aisle: 0,
              bin: 0,
              id: 0,
              location: 0,
              minQty: 0,
              qtyOnHand: 0,
              row: 0,
              stockItem: Part(
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
                  partNotes: "1232")),
      woPartPlannedQnty:
          (json['woPartPlannedQnty'] == null) ? 0 : json['woPartPlannedQnty'],
      woPartActulaQnty:
          (json['woPartActulaQnty'] == null) ? 0 : json['woPartActulaQnty'],
      timeStamp: (json['timeStamp'] == null) ? 'مشخص نشده' : json['timeStamp'],
      woPartWorkorder:
          (json['woPartWorkorder'] == null) ? 0 : json['woPartWorkorder'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    // if (this.woPartStock != null) {
    data['woPartStock'] = this.woPartStock.toJson();
    // }
    data['woPartPlannedQnty'] = this.woPartPlannedQnty;
    data['woPartActulaQnty'] = this.woPartActulaQnty;
    data['timeStamp'] = this.timeStamp;
    data['woPartWorkorder'] = this.woPartWorkorder;
    return data;
  }
}
