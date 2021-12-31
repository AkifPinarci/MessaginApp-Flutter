// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
// ignore: must_be_immutable
class FriendContactDetail extends StatefulWidget {

  var contactDetails;
  FriendContactDetail(this.contactDetails);

  @override
  _FriendContactDetailState createState() => _FriendContactDetailState();
}
 
class _FriendContactDetailState extends State<FriendContactDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          Text('${widget.contactDetails["name"]}'),
          Text('${widget.contactDetails["phone"]}'),
          Text('${widget.contactDetails["type"]}'),
          Text('${widget.contactDetails["image"]}'),
        ],
      ),
    );
  }
}