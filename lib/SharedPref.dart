import 'dart:convert';
import 'package:GDSC_Task/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  read(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> json = jsonDecode(pref.getString(key)!);
    // var user = UserModel.fromJson(json);
    return json;
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<bool> saveUsertoUserList(UserModel persons) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Future<List<UserModel>> userList = getUserList();
    userList.then((value) async {
      value.add(persons);
      String jsonString = encode(value);
      sharedPreferences.setString("userList", jsonString);
      return true;
    });
    return false;
  }

  Future<bool> updateUsertoUserList(
      int updateUserAtIndex, UserModel updatedUser) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Future<List<UserModel>> userList = getUserList();
    userList.then((value) async {
      value[updateUserAtIndex] = updatedUser;
      String jsonString = encode(value);
      sharedPreferences.setString("userList", jsonString);
      return true;
    });
    return false;
  }

  Future<UserModel> deleteUserFromUserList(int deleteUserAtIndex) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Future<List<UserModel>> userList = getUserList();
    userList.then((value) async {
      UserModel userModel = value.removeAt(deleteUserAtIndex);
      String jsonString = encode(value);
      sharedPreferences.setString("userList", jsonString);
      return userModel;
    });
    return UserModel(website: "", userName: "", password: "");
  }

  Future<List<UserModel>> getUserList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? jsonString = sharedPreferences.getString("userList");
    if (jsonString == null) {
      return <UserModel>[];
    }
    List<UserModel> userList = decode(jsonString!);
    return userList;
  }

  static String encode(List<UserModel> users) => json.encode(
        users
            .map<Map<String, dynamic>>((music) => UserModel.toMap(music))
            .toList(),
      );

  static List<UserModel> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<UserModel>((item) => UserModel.fromJson(item))
          .toList();
}
