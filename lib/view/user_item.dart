import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_management/models/user_model.dart';
import 'package:user_profile_management/services/user_service.dart';

class UserItem extends StatefulWidget {
  UserItem({super.key, required this.userModel});
  Users userModel;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          tileColor: Color(0xffcdd9ec),
          leading: Text(
            "${widget.userModel.id}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          trailing: IconButton(
              onPressed: ()async {
                List<Users> users = [];
               await  deleteUser(widget.userModel.id.toString());
             setState(() {
             });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.redAccent,
              )),
          title: Text(widget.userModel.name,
          style: TextStyle(
            fontSize: 25
          ),),
          subtitle: Text(widget.userModel.email,
          style: TextStyle(
            fontSize: 20
          ),),
          onTap: () {}

          /// todo => Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => EditUserPage(user: user),
          //   ),
          // ).then((value) => getUsers()),
          ),
    );
  }
  deleteUser(String userId){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        content: Text("Are you sure you want to delete this user?"),
      actions: [
        TextButton(onPressed: ()async{
          await UserService().deleteUser(context,userId);
          Navigator.pop(context);
          setState(() {
          });
        }, child: Text("Yes")),
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("No")),
      ],
      );
    },);
  }
}
