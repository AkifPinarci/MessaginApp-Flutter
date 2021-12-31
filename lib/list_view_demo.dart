// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, empty_constructor_bodies, prefer_typing_uninitialized_variables, deprecated_member_use, avoid_print, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sample/chat_page.dart';
import 'package:sample/user_profile.dart';
import 'package:sample/user_profile_page.dart';

import 'add_friend.dart';
import 'data.dart';
import 'friend_details.dart';

class ListViewFirebaseDemo extends StatefulWidget {
  const ListViewFirebaseDemo({ Key? key }) : super(key: key);

  @override
  _ListViewFirebaseDemoState createState() => _ListViewFirebaseDemoState();
}

class _ListViewFirebaseDemoState extends State<ListViewFirebaseDemo> {

  var uid;
  var friendList = [];

  _ListViewFirebaseDemoState(){
    refreshTheList();
    FirebaseDatabase.instance.reference().child("friends").onChildChanged.listen((event) {
      print("Data changed");
      refreshTheList();
    });
    FirebaseDatabase.instance.reference().child("friends").onChildRemoved.listen((event) {
      print("Data changed");
      refreshTheList();
    });
    FirebaseDatabase.instance.reference().child("friends").onChildAdded.listen((event) {
      print("Data changed");
      refreshTheList();
    });
  }

  void refreshTheList() {
    FirebaseDatabase.instance.reference().child("friends").once()
    .then((datasnapshot){
      print("Successgully loaded tha data");
      uid = inputData();
      var userInfo = datasnapshot.value[uid];
      var friendTmpList = [];
      UserProfile.currentUser = userInfo;
      print("Ahanda user: " + userInfo.toString());
      datasnapshot.value.forEach((k, v){
        v['image'] = 'https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png';
        friendTmpList.add(v);
      });
      friendList = friendTmpList;
      setState(() {
        
      });
    }).catchError((onError){
      print("Failed to load data");
      print(onError.toString());
    });

  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  String? inputData() {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    // here you write the codes to input the data into firestore
    print("Ahanda id: " + uid!);
    return uid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Yarrak"),
        actions: [
          IconButton(
            onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),  
                );
            }, 
              icon: Icon(Icons.edit),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: friendList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage(friendList[index]["uid"])),
              );
            },
            title: Container(
              height: 50,
              margin: EdgeInsets.only(left: 1, right: 1, top: 5, bottom: 5),
              // color: Colors.amber[500],
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('${friendList[index]["image"]}'),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${friendList[index]["name"]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                      ),
                      Text('${friendList[index]["phone"]}'),
                    ],
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 20, bottom: 20),
                    child: Text("${friendList[index]["type"]}")),
                ],  
              ),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          // refreshTheList();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatPage("group")),
          );
         },
        child: Icon(Icons.message),
      ),
    );
  }
}