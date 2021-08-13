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
        assetFile: (json['AssetFile'] != null) ? json['AssetFile'] : '',
        assetFiledateAdded: (json['AssetFiledateAdded'] != null)
            ? json['AssetFiledateAdded']
            : '',
        assetFileAssetId:
            (json['AssetFileAssetId'] != null) ? json['AssetFileAssetId'] : 1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['AssetFile'] = this.assetFile;
    data['AssetFiledateAdded'] = this.assetFiledateAdded;
    data['AssetFileAssetrkorder'] = this.assetFileAssetId;
    return data;
  }
}
