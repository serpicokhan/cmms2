class MeterCode {
  int id;
  String meterCode;
  String meterDescription;
  String meterAbbr;

  MeterCode(
      {required this.id,
      required this.meterCode,
      required this.meterDescription,
      required this.meterAbbr});

  factory MeterCode.fromJson(Map<String, dynamic> json) {
    return MeterCode(
        id: json['id'],
        meterCode: (json['meterCode'] != null) ? json['meterCode'] : '',
        meterDescription:
            (json['meterDescription'] != null) ? json['meterDescription'] : '',
        meterAbbr: (json['meterAbbr'] != null) ? json['meterAbbr'] : '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['meterCode'] = this.meterCode;
    data['meterDescription'] = this.meterDescription;
    data['meterAbbr'] = this.meterAbbr;
    return data;
  }
}
