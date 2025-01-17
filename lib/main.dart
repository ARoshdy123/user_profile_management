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
      debugShowCheckedModeBanner: false,
      title: 'User Profile Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListPage(),
    );
  }
}
