class AssetPart {
  int id;
  String assetPartPid;
  int assetPartQnty;
  String assetPartAssetid;

  AssetPart(
      {required this.id,
      required this.assetPartPid,
      required this.assetPartQnty,
      required this.assetPartAssetid});

  factory AssetPart.fromJson(Map<String, dynamic> json) {
    return AssetPart(
        id: json['id'],
        assetPartPid:
            (json['assetPartPid'] != null) ? json['assetPartPid'] : 'نامشخص',
        assetPartQnty:
            (json['assetPartQnty'] != null) ? json['assetPartQnty'] : 0,
        assetPartAssetid: (json['assetPartAssetid'] != null)
            ? json['assetPartAssetid']
            : 'نامشخص');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['assetPartPid'] = this.assetPartPid;
    data['assetPartQnty'] = this.assetPartQnty;
    data['assetPartAssetid'] = this.assetPartAssetid;
    return data;
  }
}
