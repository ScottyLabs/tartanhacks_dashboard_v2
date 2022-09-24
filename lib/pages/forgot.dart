import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import '../components/background_shapes/CurvedBottom.dart';
import 'login.dart';
import '../api.dart';
import 'package:provider/provider.dart';
import '../theme_changer.dart';


class Forgot extends StatefulWidget{
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot>{

  TextEditingController _emailcontroller;

  @override
  void initState() {
    super.initState();
    _emailcontroller = TextEditingController();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  void passwordRecovery(BuildContext context) async {
    OverlayEntry loading = loadingOverlay(context);
    Overlay.of(context).insert(loading);
    bool success = await resetPassword(_emailcontroller.text);
    loading.remove();
    if (success) {
      errorDialog(context, "Success", "Please check your email address to reset your password.");
    } else {
      errorDialog(context, "Error", "We encountered an error while resetting your password. Please contact ScottyLabs for help.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    var _themeProvider = Provider.of<ThemeChanger>(context, listen: false);

    return Scaffold(
        body: SingleChildScrollView(
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
                                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                                child: _themeProvider.getTheme==lightTheme ? Image.asset("lib/logos/thLogoDark.png")
                                    : Image.asset("lib/logos/thLogoDark.png")
                            )
                          ]
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: GradText(
                              text: "Let's Reset",
                              size: 40,
                              color1: Theme.of(context).colorScheme.primary,
                              color2: Theme.of(context).colorScheme.secondary
                          )
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: TextField(
                          controller: _emailcontroller,
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                          style: Theme.of(context).textTheme.bodyText2,
                          enableSuggestions: false,
                        ),
                      ),
                      const SizedBox(height:10),
                      GradBox(
                          width: 200,
                          height: 45,
                          onTap: () {
                            passwordRecovery(context);
                          },
                          child: const Text("Recover Password",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          )
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.primary
                              )
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      Login()),
                                );
                              },
                              child: Text("Try Logging In",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.secondary
                                  )
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height:5)
                    ]
                )
            )
        )
    );
  }
}