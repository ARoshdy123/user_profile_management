
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_management/models/user_model.dart';
import 'package:user_profile_management/services/user_service.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  final UserService userService = UserService();

  List<Users> cachedUsers = [];
  getCachedUsers() async{
    await userService.getCachedUsers();
    final prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("UserData")?? '';

    if(data.isNotEmpty){
      var jsonData = jsonDecode(data);
      jsonData.forEach((json){
        cachedUsers.add(Users.fromJson(json));
      });
    }

    setState(() {

    });
    print(data);

  }
  // List<User> users = [];  getUsers() async {
  //   try {
  //     users = await UserService().getUsers();
  //     setState(() {});
  //   } catch (e) {
  //     print("Error fetching users: $e");
  //   }
  // }
  @override
  void initState() {
    super.initState();
    // getUsers();
    getCachedUsers();
  }



  /// todo void navigateToAddUser() async {
  //   final result = await Navigator.push(
  //       context, MaterialPageRoute(builder: (_) => //AddUserPage()));
  //   if (result == true) getUsers();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: cachedUsers.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: cachedUsers.length,
        itemBuilder: (context, index) {
          final user = cachedUsers[index];
          return ListTile(leading: Text("${user.id}"),
              trailing: Icon(Icons.person),
              title: Text(user.name),
              subtitle: Text(user.email),
              onTap: () {}
            /// todo => Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => EditUserPage(user: user),
            //   ),
            // ).then((value) => getUsers()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),
          onPressed: (){} /// todo navigateToAddUser,
        ///todo child: Icon(Icons.add),
      ),
    );
  }
}
