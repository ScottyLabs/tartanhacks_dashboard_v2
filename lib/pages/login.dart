import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../api.dart';
import '../models/user.dart';
import 'custom_widgets.dart';
import 'home.dart';
import 'forgot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sponsors.dart';


class Login extends StatefulWidget{
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login>{

  final _emailcontroller = new TextEditingController();
  final _passwordcontroller = new TextEditingController();

  SharedPreferences prefs;

  @override
  initState() {
    super.initState();
    checkLogInStatus();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  void login(String email, String password) async {
    User logindata = await checkCredentials(email, password);
    if (logindata != null) {
      if (logindata.company != null) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new Sponsors()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new Home()),
        );
      }
      print(logindata);
      print(prefs);
    }else{
      errorDialog(context, "Login Failure", "Your username or password is incorrect.");
    }
  }

  checkLogInStatus() async{

    prefs = await SharedPreferences.getInstance();
    if(prefs.get('email')!=null){
      if (prefs.get('company') != null) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new Sponsors()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new Home()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenHeight
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                          children:[
                            CustomPaint(
                              size: Size(screenWidth, screenHeight*0.45),
                              painter: CurvedBottom(color1: Theme.of(context).colorScheme.primary,
                                  color2: Theme.of(context).colorScheme.secondaryVariant),
                            ),
                            Container(
                                height: screenHeight*0.3,
                                width: screenWidth,
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: SvgPicture.asset("lib/logos/scottylabsLogo.svg",
                                    color: Theme.of(context).colorScheme.onPrimary
                                )
                            )
                          ]
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: GradText(
                          text: "Welcome",
                          size: 40,
                          color1: Theme.of(context).colorScheme.onBackground,
                          color2: Theme.of(context).colorScheme.primary
                          )
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: TextField(
                          controller: _emailcontroller,
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: TextField(
                          controller: _passwordcontroller,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      SizedBox(height: 10),
                      GradBox(
                          width: 150,
                          height: 45,
                          onTap: () {
                            login(_emailcontroller.text, _passwordcontroller.text);
                          },
                          child: Text("Start Hacking",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          )
                      ),
                      SizedBox(height: 8),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  Forgot()),
                            );
                          },
                          child: Text("Forgot Password",
                              style: TextStyle(
                                  color: Color(0xFF5AA4D4)
                              )
                          )
                      ),
                    ]
                )
              )
          )
      )
    );
  }
}