class AssetCategory {
  int id;
  String name;
  String code;
  String description;
  int priority;

  AssetCategory({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.priority,
  });

  factory AssetCategory.fromJson(Map<String, dynamic> json) {
    return AssetCategory(
      id: json['id'],
      name: (json['name'] == null) ? "نامشخص" : json["name"],
      code: (json['code'] != null) ? json['code'] : "نامخشص",
      description:
          (json['description'] != null) ? json['description'] : "نامشخص",
      priority: (json['priority'] != null) ? json["priority"] : 0,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    data['priority'] = this.priority;
    return data;
  }
}
