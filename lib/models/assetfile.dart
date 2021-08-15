class AssetFile {
  int id;
  String assetFile;
  String assetFiledateAdded;
  int assetFileAssetId;

  AssetFile(
      {required this.id,
      required this.assetFile,
      required this.assetFiledateAdded,
      required this.assetFileAssetId});

  factory AssetFile.fromJson(Map<String, dynamic> json) {
    return AssetFile(
        id: (json['id'] != null) ? json['id'] : 1,
        assetFile: (json['assetFile'] != null) ? json['assetFile'] : '',
        assetFiledateAdded: (json['assetFiledateAdded'] != null)
            ? json['assetFiledateAdded']
            : '',
        assetFileAssetId:
            (json['assetFileAssetId'] != null) ? json['assetFileAssetId'] : 1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['assetFile'] = this.assetFile;
    data['assetFiledateAdded'] = this.assetFiledateAdded;
    data['assetFileAssetrkorder'] = this.assetFileAssetId;
    return data;
  }
}
