// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unnecessary_new

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({ Key? key }) : super(key: key);

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
              ),
            ),
            TextField(
              controller: phoneController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Phone',
              ),
            ),
            TextField(
              controller: typeController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type',
              ),
            ),
            RaisedButton(
              child: Text("Add Friend"),
              onPressed: () {
                print(nameController.text);
                print(phoneController.text);
                print(typeController.text);

                var timeStamp = new DateTime.now().millisecondsSinceEpoch;
                FirebaseDatabase.instance.reference().child("friends/stu" + timeStamp.toString()).set(
                  {
                    "name" : nameController.text,
                    "phone" : phoneController.text,
                    "type" : typeController.text,
                    "image": "https://img.favpng.com/23/4/11/computer-icons-user-profile-avatar-png-favpng-QsYtjsW73M0aGLb4GbMEyLbc5.jpg",
                  }
                ).then((value){
                  print("Sucessfully added");
                }).catchError((error){
                  print("Failed to add. " + error.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

