// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_if_null_operators

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sample/take_picture.dart';
import 'package:sample/user_profile.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({ Key? key }) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late var userProfile;
  @override
  void initState() {
    super.initState();
    var uid = UserProfile.currentUser["uid"];
    FirebaseDatabase.instance.reference().child("friends/"+ uid).once()
      .then((ds){
        userProfile = ds.value;
        setState(() {
          
        });
      }).catchError((onError){
        print(onError);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width:100,
              height:100,
              child: GestureDetector(
                onTap: () async{
                  print("object");
                  final cameras = await availableCameras();
                  final firstCamera = cameras.first;
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera)),  
                  );
                  userProfile["image"] = result;
                  setState(() {
                    FirebaseDatabase.instance.reference().child("friends/" + userProfile["uid"]).set(userProfile)
                    .then((value){
                      print("Updated the profile image");
                    })
                    .catchError((error){
                      print("Failed to update profile image");
                    });
                  });
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userProfile["image"] == null ? "https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png" :userProfile["image"]),
                
                ),
              ),
            ),
            Text(userProfile["name"]),
            Text(userProfile["email"]),
            Text(userProfile["phone"]),
            Text(userProfile["type"]),
          ],
        ),
      )
    );
  }
}