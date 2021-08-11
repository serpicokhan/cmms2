class WorkorderFile {
  int id;
  String woFile;
  String woFiledateAdded;
  int woFileworkorder;

  WorkorderFile(
      {required this.id,
      required this.woFile,
      required this.woFiledateAdded,
      required this.woFileworkorder});

  factory WorkorderFile.fromJson(Map<String, dynamic> json) {
    return WorkorderFile(
        id: (json['id'] != null) ? json['id'] : 1,
        woFile: (json['woFile'] != null) ? json['woFile'] : '',
        woFiledateAdded:
            (json['woFiledateAdded'] != null) ? json['woFiledateAdded'] : '',
        woFileworkorder:
            (json['woFileworkorder'] != null) ? json['woFileworkorder'] : 1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['woFile'] = this.woFile;
    data['woFiledateAdded'] = this.woFiledateAdded;
    data['woFileworkorder'] = this.woFileworkorder;
    return data;
  }
}
