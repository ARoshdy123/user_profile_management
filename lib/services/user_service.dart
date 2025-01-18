import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_management/models/user_model.dart';

class UserService {
  String endpoint = "https://jsonplaceholder.typicode.com/users";
  final dio = Dio();

  Future<List<Users>> getCachedUsers() async {
    List<Users> cachedUsers = [];
    try {
      var response = await dio.get(endpoint);
      var data = response.data;
      var cachedData = jsonEncode(data);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("UserData", cachedData);
      data.forEach((json) {
        Users user = Users.fromJson(json);
        cachedUsers.add(user);
      });
      print(response.toString());
    } catch (e) {
      print(e.toString());
    }
    return cachedUsers;
  }
}
