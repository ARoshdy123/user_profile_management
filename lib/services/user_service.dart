import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_management/models/user_model.dart';
import 'package:user_profile_management/services/check_internet.dart';

class UserService {
  String endpoint = "https://jsonplaceholder.typicode.com/users";
  final dio = Dio();
  Future<List<Users>> getUsers(BuildContext context) async {
    List<Users> cachedUsers = [];
    bool isConnected = await InternetChecker.checkNetwork();
    if (isConnected) {
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
    }

    // get users from  cached data
    else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No Internet Connection")));
      final prefs = await SharedPreferences.getInstance();
      String data = prefs.getString("UserData") ?? '';
      if (data.isNotEmpty) {
        var jsonData = jsonDecode(data);
        jsonData.forEach((json) {
          cachedUsers.add(Users.fromJson(json));
        });
      }
    }
    return cachedUsers;
  }

  Future<void>deleteUser(BuildContext context, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String data = prefs.getString("UserData") ?? '';
      var jsonData = jsonDecode(data);
      var response = await dio.delete("https://jsonplaceholder.typicode.com/users/$userId",
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User deleted successfully")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to delete user: ${response.statusCode}")));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
