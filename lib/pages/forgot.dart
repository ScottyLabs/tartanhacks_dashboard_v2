import 'package:flutter/material.dart';
import 'package:thdapp/models/login_model.dart';
import 'package:thdapp/api.dart';
import 'dart:async';
import 'login.dart';
import 'home.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => new _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  void _showDialog(String response, String title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(response),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "OK",
                style: new TextStyle(color: Colors.white),
              ),
              color: Color.fromARGB(255, 37, 130, 242),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void reset(String email) async {
    String resetResponse = await resetPassword(email);

    if(resetResponse == "Please check your email address to reset your password."){
      _showDialog(resetResponse, "Success");

    }else{
      _showDialog(resetResponse, "Oops");

    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        // decoration: new BoxDecoration(color: Colors.black), - black background
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: width,
                  height: height * 0.45,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 60, right: 60, top: 60, bottom: 25),
                    child: Image(
                      image: AssetImage('images/center_logo.png'),
                    ),
                  )),
              Text(
                "Let's Reset",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              ),
              Text(
                'Enter the e-mail you registered with to recover your credentials',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  suffixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),

              SizedBox(
                height: 30.0,
              ),
              ButtonTheme(
                height: 45.0,
                minWidth: 200,
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    RaisedButton(
                      child: Text('Recover Password',
                          style: TextStyle(
                              fontSize: 15.0, color: Color(0xffffffff))),
                      color: Color.fromARGB(255, 37, 130, 242),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(
                              color: Color.fromARGB(255, 37, 130, 242))),
                      onPressed: () {
                        reset(emailController.text);

                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text.rich(
                  TextSpan(text: 'Already have an account?\t', children: [
                    TextSpan(
                      text: 'Try Logging In',
                      style:
                      TextStyle(color: Color.fromARGB(255, 37, 130, 242)),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
