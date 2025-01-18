import 'package:flutter/material.dart';
import 'package:user_profile_management/view/user_list_page.dart';

void main() {
  runApp(UserProfileManagement());
}

class UserProfileManagement extends StatelessWidget {
  const UserProfileManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'User Profile Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListPage(),
    );
  }
}
