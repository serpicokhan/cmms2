class Part {
  int id;
  String partName;
  String partDescription;
  String partCode;
  String partMake;
  String partModel;
  double partLastPrice;
  String partAccount;
  String partChargeDepartment;
  String partNotes;
  String partBarcode;
  String partInventoryCode;

  Part(
      {required this.id,
      required this.partName,
      required this.partDescription,
      required this.partCode,
      required this.partMake,
      required this.partModel,
      required this.partLastPrice,
      required this.partAccount,
      required this.partChargeDepartment,
      required this.partNotes,
      required this.partBarcode,
      required this.partInventoryCode});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      id: json['id'],
      partName: (json['partName'] == null) ? "مشخص نشده" : json['partName'],
      partDescription: (json['partDescription'] == null)
          ? "مشخص نشده"
          : json['partDescription'],
      partCode: (json['partCode'] == null) ? "مشخص نشده" : json['partCode'],
      partMake: (json['partMake'] == null) ? "مشخص نشده" : json['partMake'],
      partModel: (json['partModel'] == null) ? "مشخص نشده" : json['partModel'],
      partLastPrice:
          (json['partLastPrice'] == null) ? 0 : json['partLastPrice'],
      partAccount:
          (json['partAccount'] == null) ? "مشخص نشده" : json['partAccount'],
      partChargeDepartment: (json['partChargeDepartment'] == null)
          ? "مشخص نشده"
          : json['partChargeDepartment'],
      partNotes: (json['partNotes'] == null) ? "مشخص نشده" : json['partNotes'],
      partBarcode:
          (json['partBarcode'] == null) ? "مشخص نشده" : json['partBarcode'],
      partInventoryCode: (json['partInventoryCode'] == null)
          ? "مشخص نشده"
          : json['partInventoryCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['partName'] = this.partName;
    data['partDescription'] = this.partDescription;
    data['partCode'] = this.partCode;
    data['partMake'] = this.partMake;
    data['partModel'] = this.partModel;
    data['partLastPrice'] = this.partLastPrice;
    data['partAccount'] = this.partAccount;
    data['partChargeDepartment'] = this.partChargeDepartment;
    data['partNotes'] = this.partNotes;
    data['partBarcode'] = this.partBarcode;
    data['partInventoryCode'] = this.partInventoryCode;
    return data;
  }
}
