import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/loading/LoadingOverlay.dart';
import 'package:thdapp/components/text/GradText.dart';
import '../api.dart';
import '../models/user.dart';
import '../components/background_shapes/CurvedBottom.dart';
import 'forgot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sponsors.dart';
import 'package:provider/provider.dart';
import '../theme_changer.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

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
    OverlayEntry loading = LoadingOverlay(context);
    Overlay.of(context).insert(loading);
    User logindata = await checkCredentials(email, password);
    TextInput.finishAutofillContext();
    loading.remove();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctxt) => Sponsors()),
    );
    // } else if (!logindata.admin && logindata.status != "CONFIRMED") {
    //   loading.remove();
    //   errorDialog(context, "Unconfirmed", "Your participant account has not been "
    //       "confirmed and you are currently on the waitlist. \n\nYou may log into the dashboard "
    //       "after you've been confirmed.");
      }

  checkLogInStatus() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getString('theme') == "light") {
      var themeProvider = Provider.of<ThemeChanger>(context, listen: false);
      themeProvider.setTheme(lightTheme);
    }

    String? email = prefs.getString('email');
    String? pwd = prefs.getString('password');

    if (email != null && pwd != null) {
      User logindata = await checkCredentials(email, pwd);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctxt) => Sponsors()),
    );
    // } else if (!logindata.admin && logindata.status != "CONFIRMED") {
    //   errorDialog(context, "Unconfirmed", "Your participant account has not been "
    //       "confirmed and you are currently on the waitlist. \n\nYou may log into the dashboard "
    //       "after you've been confirmed.");
      }
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    var themeProvider = Provider.of<ThemeChanger>(context, listen: false);

    return Scaffold(
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: screenHeight),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(children: [
                        CustomPaint(
                          size: Size(screenWidth, screenHeight * 0.45),
                          painter: CurvedBottom(
                              color1: Theme.of(context).colorScheme.primary,
                              color2: Theme.of(context).colorScheme.secondary),
                        ),
                        Container(
                            height: screenHeight * 0.3,
                            width: screenWidth,
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                            child: themeProvider.getTheme == lightTheme
                                ? Image.asset("lib/logos/thLogoLight.png")
                                : Image.asset("lib/logos/thLogoLight.png"))
                      ]),
                      Container(
                          alignment: Alignment.center,
                          child: GradText(
                              text: "Welcome",
                              size: 40,
                              color1: Theme.of(context).colorScheme.primary,
                              color2: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer)),
                      AutofillGroup(
                          child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextField(
                                controller: _emailcontroller,
                                autofillHints: const [AutofillHints.email],
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                ),
                                style: Theme.of(context).textTheme.bodyMedium,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextField(
                              controller: _passwordcontroller,
                              autofillHints: const [AutofillHints.password],
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Password",
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        ],
                      )),
                      const SizedBox(height: 10),
                      GradBox(
                          width: 150,
                          height: 45,
                          onTap: () {
                            login(_emailcontroller.text,
                                _passwordcontroller.text);
                          },
                          child: const Text(
                            "Start Hacking",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(height: 8),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Forgot()),
                            );
                          },
                          child: Text("Forgot Password",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer))),
                    ]))));
  }
}
