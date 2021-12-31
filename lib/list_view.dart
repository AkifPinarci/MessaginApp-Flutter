// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, empty_constructor_bodies, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'add_friend.dart';
import 'data.dart';
import 'friend_details.dart';

class ListViewDemo extends StatefulWidget {
  const ListViewDemo({ Key? key }) : super(key: key);

  @override
  _ListViewDemoState createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {

  
  late List<Friend> friends;

  // _ListViewDemoState(){
    
  //   Friend f1 = Friend("Alice", "234-123-2343", 'https://img.favpng.com/23/4/11/computer-icons-user-profile-avatar-png-favpng-QsYtjsW73M0aGLb4GbMEyLbc5.jpg', 'HOME');
  //   Friend f2 = Friend("Akif", "444-222-1232", 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9lLypgNkus1XjE8RRsOv6Xu6YlXa0Lh9Shw&usqp=CAU', 'CELL');
  //   Friend f3 = Friend("Jhon", "444-133-2342", 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsdD1rK4ZtCJVizS00LaWifgJnY-wzSVBoHw&usqp=CAU', 'BUSINESS');
  //   Friend f4 = Friend("John", "223-123-2341", 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQL95BbJqNhfe6K9_7cQPbC41EURBRnw0oZug&usqp=CAU', 'MOBILE');

  //   friends = [f1, f2, f3, f4];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendContactDetail(friends[index])),
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
                      backgroundImage: NetworkImage('${friends[index].imgaeUrl}'),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${friends[index].name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                      ),
                      Text('${friends[index].phone}'),
                    ],
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 20, bottom: 20),
                    child: Text("${friends[index].type}")),
                ],  
              ),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFriendPage()),
          );

          // Friend f5 = Friend("name", "phone", "imgaeUrl", "type");
          // setState(() {
          //   friends.add(f5);
          // });
         },
        child: Icon(Icons.add),
      ),
    );
  }
}