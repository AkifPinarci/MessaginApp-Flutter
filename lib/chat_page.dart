// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:collection';

import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sample/take_picture.dart';
import 'package:sample/user_profile.dart';


class ChatPage extends StatefulWidget {

  var uid;

  ChatPage(this.uid);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var firebaseMessageRoot;
  var messageController = TextEditingController();
  var scrollController = ScrollController();
  var messageList = [];

  @override
  void initState(){
    if (widget.uid == "group"){
      firebaseMessageRoot = "group";
    }
    else{
      if(UserProfile.currentUser["uid"].compareTo(widget.uid.toString()) >= 0) {
        firebaseMessageRoot = UserProfile.currentUser["uid"] + "-" + widget.uid.toString();
      }else{
        firebaseMessageRoot = widget.uid.toString()+ "-" +UserProfile.currentUser["uid"];
      }
    }
    refreshChat();
  }


  void updateMessageBox(){
    FirebaseDatabase.instance.reference().child("message/" + firebaseMessageRoot).onChildChanged.listen((event) {
        refreshChat();
      });
      FirebaseDatabase.instance.reference().child("message/" + firebaseMessageRoot).onChildRemoved.listen((event) {
        refreshChat();
      });
      FirebaseDatabase.instance.reference().child("message/" + firebaseMessageRoot).onChildAdded.listen((event) {
        refreshChat();
      }
    );
  }
  void refreshChat(){
    FirebaseDatabase.instance.reference().child("message/" + firebaseMessageRoot).once()
      .then((ds){
        var tmpList = [];
        ds.value.forEach((k, v){
          v["image"] = "https://www.kindpng.com/picc/m/495-4952535_create-digital-profile-icon-blue-user-profile-icon.png";
          tmpList.add(v);
        });
        messageList = tmpList;
        setState(() {
          
        });
      }).catchError((error){
        print("Failed");
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex:90,
            child: ListView.builder(
              controller: scrollController,
              itemCount: messageList.length,
              itemBuilder: (BuildContext context, int index) {
                return messageList[index]["uid"] == UserProfile.currentUser["uid"] ? 
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: messageList[index]['type'] != null && messageList[index]['type'] == "image" ? 
                              Image.network(messageList[index]['text']):
                              Text(
                                messageList[index]["text"],
                                style: TextStyle(
                                  fontSize: 15,
                                )
                              ),
                          ),
                          Text("Sent at: " + DateTime.fromMillisecondsSinceEpoch(messageList[index]["timestamp"]).toString(),),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('${messageList[index]["image"]}'),
                        ),
                      ),
                    ],
                  ),
                ):
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('${messageList[index]["image"]}'),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              messageList[index]["text"],
                              style: TextStyle(
                                fontSize: 15,
                              )
                            ),
                          ),
                          Text("Sent at: " + DateTime.fromMillisecondsSinceEpoch(messageList[index]["timestamp"]).toString(),),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type Your Message',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final cameras = await availableCameras();
                      final firstCamera = cameras.first;
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera)),  
                      );
                      var timestamp = DateTime.now().microsecondsSinceEpoch;
                      var messageRecord = {
                        "text": result,
                        "type" : "image",
                        "timestamp" : timestamp,
                        "uid": UserProfile.currentUser["uid"]
                      };       
                      FirebaseDatabase.instance.reference().child("message/" + firebaseMessageRoot+"/"+ timestamp.toString())
                        .set(messageRecord)
                        .then((value){
                          print("Message sended");
                          messageController.text = "";
                        }).catchError((error){
                          print("Error: " + error.toString());
                          messageController.text = "";
                        });  
                        updateMessageBox();
                  },
                    icon: Icon(Icons.photo)
                  ),
                  IconButton(
                    icon: Icon(Icons.send), 
                    onPressed: () {
                      scrollController.jumpTo(scrollController.position.maxScrollExtent);
                      var timestamp = DateTime.now().microsecondsSinceEpoch;
                      var messageRecord = {
                        "text": messageController.text,
                        "type": "text",
                        "timestamp" : timestamp,
                        "uid": UserProfile.currentUser["uid"]
                      };       
                      FirebaseDatabase.instance.reference().child("message/" + firebaseMessageRoot+"/"+ timestamp.toString())
                        .set(messageRecord)
                        .then((value){
                          print("Message sended");
                          messageController.text = "";
                        }).catchError((error){
                          print("Error: " + error.toString());
                          messageController.text = "";
                        });  
                        updateMessageBox();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}