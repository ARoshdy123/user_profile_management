import 'package:flutter/material.dart';
import 'package:user_profile_management/models/user_model.dart';
import 'package:user_profile_management/services/user_service.dart';

import 'update_user_page.dart';

class UserItem extends StatelessWidget {
  final Users userModel;
  final VoidCallback onReload; // Callback to reload the user list to run the cached users

  UserItem({super.key, required this.userModel, required this.onReload});

  void deleteUser(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete User"),
        content: Text("Are you sure you want to delete this user? ${userModel.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete) {
      await UserService().deleteUser(context, userModel.id.toString());
      onReload();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${userModel.name} has been deleted.")),
      );
    }
  }
  void editUser(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UpdateUserPage(user: userModel), // Pass the user to be updated
      ),
    );

    if (result == true) {
      onReload(); // Reload the user list after updating
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${userModel.name}'s data has been updated.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        tileColor: Color(0xffcdd9ec),
        leading: Text(
          "${userModel.id}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => editUser(context), // Call edit method
              icon: Icon(Icons.edit, color: Colors.blueAccent),
            ),
            IconButton(
              onPressed: () => deleteUser(context), // Call delete method
              icon: Icon(Icons.delete, color: Colors.redAccent),
            ),
          ],
        ),
        title: Text(
          userModel.name,
          style: TextStyle(fontSize: 25),
        ),
        subtitle: Text(
          userModel.email,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
