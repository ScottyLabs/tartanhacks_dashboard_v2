import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:thdapp/models/participant_model.dart';

class ProfileScreen extends StatefulWidget {

  final Participant userData;

  ProfileScreen(
  {Key key, this.userData})
     : super(key: key);
  @override
  _ProfileScreenState createState() => new _ProfileScreenState(userData: userData);
}

class _ProfileScreenState extends State<ProfileScreen> {

  Participant userData;

  _ProfileScreenState({Key key, this.userData});

  @override
  initState() {
    super.initState();
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
              color: new Color.fromARGB(255, 255, 75, 43),
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
    return new Scaffold(
      appBar: PreferredSize(
          child: new AppBar(
            title: new Text(
              'Hacker Profile',
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 37, 130, 242),
          ),
          preferredSize: Size.fromHeight(60)),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        'name = '+userData.name,
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      new Text(
                        (userData.team_id != null) ?
                        'team = '+userData.team_id
                        : 'team = N/A',
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        (userData.github_profile_url != null) ?
                        'github_url = '  + userData.github_profile_url
                        : 'github_url = N/A',
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      new Text(
                        (userData.resume_url != null) ?
                        'resume_url = '+userData.resume_url
                        : 'resume_url = N/A',
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        (userData.github_profile_url != null) ?
                        'bio = '+userData.github_profile_url
                        : 'bio = N/A',
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
            ),

          ],
        ),
      ),
       );
  }
}
