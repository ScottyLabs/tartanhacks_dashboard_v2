import 'package:flutter/material.dart';
import 'package:thdapp/models/login_model.dart';
import 'package:thdapp/api.dart';
import 'dart:async';
import 'home.dart';
import 'forgot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  SharedPreferences prefs;

  @override
  initState() {
    super.initState();
    checkLogInStatus();

  }

  checkLogInStatus() async{

    prefs = await SharedPreferences.getInstance();

    if(prefs.get('email')!=null){
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (ctxt) => new HomeScreen()),
      );
    }

  }



  void login(String email, String password) async {
    Login logindata = await checkCredentials(email, password);

    if (logindata != null) {


      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (ctxt) => new HomeScreen()),
      );
    }else{
      _showDialog("The credentials you entered don't match our records. Please try again.", "Invalid Credentials.");
    }
  }

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
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
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
                'Welcome!',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              ),
              Text(
                'Login with your credentials from the registration system.',
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
                height: 20.0,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: Icon(Icons.lock),
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
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      child: Text('Start Hacking',
                          style: TextStyle(color: Color(0xffffffff))),
                      color: Color.fromARGB(255, 37, 130, 242),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(
                              color: Color.fromARGB(255, 37, 130, 242))),
                      onPressed: () {
                        print(emailController.text);
                        print(passwordController.text);
                        login(emailController.text, passwordController.text);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ForgotScreen()));
                },
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: 'Forgot Password',
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
