// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_typing_uninitialized_variables, avoid_print, unused_field, prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({ Key? key }) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  var items = [    
    'Cell',
    'Work',
    'Home',
  ];
  String dropdownvalue = 'Cell';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              const Expanded(
                flex: 22,
                child: Image(
                  image: NetworkImage('https://www.wraltechwire.com/wp-content/uploads/2017/11/NewsletterSignup-Background.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                flex: 50,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                      child: TextField(
                        controller: emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    Container(                  
                      height: 50,
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                      child: TextField(
                        controller: nameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Name',
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                      child: TextField(
                        controller: phoneController,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Phone Number',
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "Type: "
                          ),
                        ),
                        DropdownButton(
                    
                          // Initial Value
                          value: dropdownvalue,
                            
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),    
                            
                          // Array list of items
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) { 
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 50,
                      width: 200,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          "Sign Up",
                        ),
                        color: Colors.red,
                        onPressed: (){
                          print(emailController.text);
                          print(passwordController.text);
                          FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                          .then((UserCredential){
                            print("Succesfully signed up! uID:"+ UserCredential.user!.uid.toString());

                            var userProfile = {
                              'uid' : UserCredential.user!.uid.toString(),
                              'name' : nameController.text,
                              'phone' : phoneController.text,
                              'email' : emailController.text,
                              'type' : dropdownvalue
                            };

                            FirebaseDatabase.instance.reference().child("friends/"+ UserCredential.user!.uid.toString())
                            .set(userProfile)
                            .then((value){
                              print("Created the profile");
                            })
                            .catchError((onError){
                              print("Failed to created the profile");
                            });
                            Navigator.pop(context);
                          }).catchError((onError){
                            print("Failed to sign up!");
                            print(onError.toString());
                          });
                        }
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                flex:10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "AppLogo",
                    ),
                    IconButton(
                      icon: Icon(Icons.book), 
                      onPressed: () {  },
                    ),
                    IconButton(
                      icon: Icon(Icons.computer),
                      onPressed: () {  },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}