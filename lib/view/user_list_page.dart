import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_management/models/user_model.dart';
import 'package:user_profile_management/services/user_service.dart';
import 'package:user_profile_management/view/user_item.dart';
import 'package:user_profile_management/view/add_user_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPage1State();
}

class _UserListPage1State extends State<UserListPage> {
  final UserService _userService = UserService();

  List<Users> users = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      // Load cached users first
      final prefs = await SharedPreferences.getInstance();
      String cachedData = prefs.getString("UserData") ?? '[]';
      List<dynamic> cachedUsersJson = cachedData.isNotEmpty
          ? List<dynamic>.from(jsonDecode(cachedData))
          : [];
      if (cachedUsersJson.isNotEmpty) {
        setState(() {
          users = cachedUsersJson.map((json) => Users.fromJson(json)).toList();
          isLoading = false;
        });
      }

      // Attempt to load users from the API
      final loadedUsers = await _userService.getUsers(context);
      setState(() {
        users = loadedUsers;
      });

      // Cache the newly loaded users
      prefs.setString(
        "UserData",
        jsonEncode(loadedUsers.map((user) => user.toJson()).toList()),
      );

    } catch (error) {
      // On network error, use cached users
      final prefs = await SharedPreferences.getInstance();
      String cachedData = prefs.getString("UserData") ?? '[]';
      List<dynamic> cachedUsersJson = cachedData.isNotEmpty
          ? List<dynamic>.from(jsonDecode(cachedData))
          : [];
      setState(() {
        users = cachedUsersJson.map((json) => Users.fromJson(json)).toList();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("User List"))),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : users.isEmpty
          ? const Center(child: Text("No users cached"))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return UserItem(userModel: user, onReload: loadUsers,);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddUser,
        child: Icon(Icons.add),
      ),

    );

  }
  Future<void> _navigateToAddUser() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddUserPage(),
      ),
    );
    if (result == true) {
      loadUsers(); // Refresh the list after adding a user
    }
  }
}
