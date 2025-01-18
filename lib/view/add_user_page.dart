import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_management/models/user_model.dart';
import 'package:user_profile_management/services/user_service.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final UserService _userService = UserService();

  Future<int> _getNextId() async {
    final prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("UserData") ?? '[]';
    List<dynamic> jsonData = jsonDecode(data);

    // to add user i know that from the json i have 10 ids so i make the new id will be 10+1
    int currentId = jsonData.isNotEmpty ? jsonData.last['id'] as int : 10;

    return currentId + 1;
  }

  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
      int nextId = await _getNextId(); // id+1

      Users newUser = Users(
        id: nextId,
        name: _nameController.text,
        username: _nameController.text,
        email: _emailController.text,
      );

      await _userService.addUser(context, newUser);
      Navigator.pop(context, true); //  to refresh the page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Color(0xffcdd9ec),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Please enter the name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Color(0xffcdd9ec),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Please enter the email' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addUser,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
