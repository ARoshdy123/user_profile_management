import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_management/models/user_model.dart';
import 'package:user_profile_management/services/check_internet.dart';

class UserService {
  String endpoint = "https://jsonplaceholder.typicode.com/users";
  final dio = Dio();

  Future<List<Users>> getUsers(context) async {
    final prefs = await SharedPreferences.getInstance();
    List<Users> cachedUsers = [];
    bool isConnected = await InternetChecker.checkNetwork();
   var data = prefs.getString("UserData") ;
    if (isConnected  && data == null) {
      try {
        var response = await dio.get(endpoint);
        var data = response.data;
        var cachedData = jsonEncode(data);

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

  Future<void> deleteUser(BuildContext context, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String data = prefs.getString("UserData") ?? '[]';
      var jsonData = jsonDecode(data);

      // Remove the user from cached data as we are using dummy Api
      jsonData.removeWhere((user) => user['id'].toString() == userId);
      await prefs.setString("UserData", jsonEncode(jsonData));


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Unable to delete user$e")),
      );
    }
  }

// addUser service

  Future<void> addUser(context,Users user) async {
    try {
      var response = await dio.post(endpoint, data: user.toJson());
      if (response.statusCode == 201) {
        // To Save the new user in cached data as we are using dummy api
        final prefs = await SharedPreferences.getInstance();
        String data = prefs.getString("UserData") ?? '[]';

        var jsonData = jsonDecode(data) as List;
        jsonData.add(user.toJson());
        await prefs.setString("UserData", jsonEncode(jsonData));

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User added successfully")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to add user: ${response.statusCode}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // update user

  Future<void> updateUser(context, Users user) async {
    try {
      var response = await dio.put("$endpoint/${user.id}", data: user.toJson());
      if (response.statusCode == 200) {
        // Update the user in cached data
        final prefs = await SharedPreferences.getInstance();
        String data = prefs.getString("UserData") ?? '[]';

        var jsonData = jsonDecode(data) as List;
        int index = jsonData.indexWhere((element) => element["id"] == user.id);
        if (index != -1) {
          jsonData[index] = user.toJson();
          await prefs.setString("UserData", jsonEncode(jsonData));
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("User updated successfully")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to update user: ${response.statusCode}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}
