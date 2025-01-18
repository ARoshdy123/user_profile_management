import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_management/models/user_model.dart';
import 'package:user_profile_management/services/check_internet.dart';
import 'package:user_profile_management/services/user_service.dart';
import 'package:user_profile_management/view/user_item.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  final UserService userService = UserService();

  // List<Users> cachedUsers = [];
  // getCachedUsers() async{
  //   await UserService().getUsers(context);
  //   setState(() {
  //   });
  // }
  List<Users> users = [];
  getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("UserData") ?? '';
    var jsonData = jsonDecode(data);
    jsonData.forEach((json) {
      users.add(Users.fromJson(json));
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUsers();
    // getCachedUsers();
  }

  /// todo void navigateToAddUser() async {
  //   final result = await Navigator.push(
  //       context, MaterialPageRoute(builder: (_) => //AddUserPage()));
  //   if (result == true) getUsers();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Users List',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
            color: Color(0xff0C3D8D)),
      )),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserItem(
                  userModel: users[index],
                );
              },
            ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: () {}

              /// todo navigateToAddUser,
              ///todo child: Icon(Icons.add),
              ),
    );
  }
}
