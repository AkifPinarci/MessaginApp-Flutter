// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/list_view.dart';
import 'package:sample/list_view_demo.dart';
import 'package:sample/signup.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              const Expanded(
                flex: 40,
                child: Image(
                  image: NetworkImage('https://www.industrialempathy.com/img/remote/ZiClJf-1920w.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 50,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 25),
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
                      margin: EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 25),
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
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 2.5),
                        width: 200,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            "Login",
                          ),
                          color: Colors.red,
                          onPressed: (){
                            FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                            .then((value){
                              print("Logged in with email and password");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ListViewFirebaseDemo()),
                              );
                            })
                            .catchError((onError){
                              print("Failed to login!");
                              print(onError.toString());
                            });
                          }
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 2.5),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpPage()),
                            );
                          }
                        ),
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