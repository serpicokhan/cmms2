class User {
  int id;
  String password;
  String fullName;
  String personalCode;
  String title;
  String email;

  User(
      {required this.id,
      required this.password,
      required this.fullName,
      required this.personalCode,
      required this.title,
      required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    var id = json['id'] ?? -1;
    var password = json['password'] ?? 'نامشخص';
    var fullName = json['fullName'] ?? 'نامشخص';
    var personalCode = json['personalCode'] ?? 'نامشخص';
    var title = json['title'] ?? '';
    var email = json['email'] ?? '';
    return User(
        id: id,
        password: password,
        fullName: fullName,
        personalCode: personalCode,
        title: title,
        email: email);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    data['fullName'] = this.fullName;
    data['personalCode'] = this.personalCode;
    data['title'] = this.title;
    data['email'] = this.email;
    return data;
  }
}
