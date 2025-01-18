import 'package:flutter/material.dart';
import 'package:user_profile_management/models/user_model.dart';
import 'package:user_profile_management/services/user_service.dart';

class UpdateUserPage extends StatefulWidget {
  final Users user;

  UpdateUserPage({super.key, required this.user});

  @override
  State<UpdateUserPage> createState() => UpdateUserPageState();
}

class UpdateUserPageState extends State<UpdateUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      Users updatedUser = Users(
        id: widget.user.id, // Keep the same ID
        name: _nameController.text,
        username: widget.user.username, // Preserve the username
        email: _emailController.text,
      );

      await _userService.updateUser(context, updatedUser);
      Navigator.pop(context, true); // Notify parent to reload the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
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
                onPressed: _updateUser,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
