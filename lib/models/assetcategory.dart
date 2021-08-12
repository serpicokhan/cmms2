class AssetCategory {
  int id;
  String name;
  String code;
  String description;
  int priority;
  int isPartOf;

  AssetCategory(
      {required this.id,
      required this.name,
      required this.code,
      required this.description,
      required this.priority,
      required this.isPartOf});

  factory AssetCategory.fromJson(Map<String, dynamic> json) {
    return AssetCategory(
        id: json['id'],
        name: json['name'] as String,
        code: json['code'] as String,
        description: json['description'],
        priority: json['priority'],
        isPartOf: json['isPartOf'] as int);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    data['priority'] = this.priority;
    data['isPartOf'] = this.isPartOf;
    return data;
  }
}
