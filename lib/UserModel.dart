class UserModel {
  String website;
  String userName;
  String password;

  UserModel({
    required this.website,
    required this.userName,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'website': website,
        'userName': userName,
        'password': password,
      };

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      website: jsonData['website'],
      userName: jsonData['userName'],
      password: jsonData['password'],
    );
  }

  static Map<String, dynamic> toMap(UserModel music) => {
        'website': music.website,
        'userName': music.userName,
        'password': music.password,
      };
}
