import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:thdapp/models/participant_model.dart';
import 'package:thdapp/models/login_model.dart';
import 'package:thdapp/api.dart';
import 'events_home.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'events_edit.dart';
import 'checkin_home.dart';
import 'hack.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences prefs;
  int selectedIndex = 0;

  Participant userData = null;

  var eventData = [];
  var api_response = [];

  bool isAdmin = false;



  @override
  initState() {
    super.initState();
    getData();
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

  void logOutConfirm(String response, String title) {
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
                "Log Out",
                style: new TextStyle(color: Colors.white),
              ),
              color: new Color.fromARGB(255, 255, 75, 43),
              onPressed: () {
                Navigator.of(context).pop();
                logOut();
              },
            ),
            new FlatButton(
              child: new Text(
                "Keep Hacking",
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

  void logOut() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (ctxt) => new LoginScreen()),
    );
  }

  void onNavigationItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      if (selectedIndex==1){

        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new EventsHomeScreen()),
        );

      }else if(selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new FormScreen()),
        );
      } else if (selectedIndex == 3) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new CheckinHomeScreen(userId: userData.id,)),
        );
      }
    });
  }

  openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getData() async{
    prefs = await SharedPreferences.getInstance();

    String email = prefs.get('email');
    String password = prefs.get('password');
    isAdmin = prefs.getBool('is_admin');

    Login  loginData = await checkCredentials(email, password);
    userData = loginData.user;

    api_response = await getEvents();
    var currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
    int length = 0;
    print(api_response);
    for (int i = 0; i < api_response.length; i++) {
      if (currentTime < int.parse(api_response[i].timestamp)) {
        if(length <2){
          eventData.add(api_response[i]);
          length++;
        }
      }
    }

    setState(() {

    });
  }

  // name of the event
  Widget eventName(data) {
    return Align(
        alignment: Alignment.centerLeft,
        child: RichText(
            text: TextSpan(
              text: '${data.name}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'TerminalGrotesque'),
            )));
  }

  // description for the event
  Widget eventDescription(data) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.60,
            child: RichText(
                text: TextSpan(
                  text: '\n${data.description}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ))));
  }

  String formatDate(String unixDate) {
    var date =
    new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate) * 1000);
    date = date.toLocal();
    String formattedDate = DateFormat('EEE dd MMM').format(date);
    return formattedDate.toUpperCase();
  }

  String getTime(String unixDate) {
    var date =
    new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate) * 1000);
    date = date.toLocal();
    String formattedDate = DateFormat('hh:mm a').format(date);
    return formattedDate;
  }

  Widget eventTime(data) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '${getTime(data.timestamp)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'TerminalGrotesque'),
          ),
          Text(
            '${formatDate(data.timestamp)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.5,
                fontFamily: 'TerminalGrotesque'),
          ),
        ]);
  }

  // hyperlinked button for the event
  Widget zoomLink(data) {
    if (data.access_code == 2) {
      return IconButton(
          icon: new Image.asset(
            "lib/logos/hopinLogo.png",
            width: 24,
            height: 24,
            color: Colors.white,
          ),

          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}'));
    } else if (data.access_code == 1) {
      return IconButton(
          icon: Icon(
            Icons.videocam,
            color: Colors.white,
            size: 25,
          ),
          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}'));
    } else {
      return IconButton(
          icon: new Image.asset(
            "lib/logos/discordLogoWhite.png",
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}'));
    }
  }

  Widget shareLink(data) {
    return IconButton(
      icon: Icon(
        Icons.share,
        color: Colors.white,
        size: 25,
      ),
      tooltip: 'Share Link!',
      color: Color.fromARGB(255, 37, 130, 242),
      onPressed: () {
        String text = 'Join ${data.name} at ' + '${data.zoom_link}';
        final RenderBox box = context.findRenderObject();
        Share.share(text,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      },
    );
  }

  Widget editEvent(data) {
    return IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.white,
          size: 25,
        ),
        tooltip: 'Edit Event',
        color: Color.fromARGB(255, 37, 130, 242),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditEventsScreen(eventData:data)));
        });
  }

  @override
  Widget build(BuildContext context) {

    if(userData == null){
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                'TartanHacks 2021',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 37, 130, 242),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    logOutConfirm("Are you sure you want to log out?", "Logging out already?");
                  },
                  color: Colors.white,
                )
              ],
            ),
            preferredSize: Size.fromHeight(60)),
      );
    }else{
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                'TartanHacks 2021',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 37, 130, 242),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    logOutConfirm("Are you sure you want to log out?", "Logging out already?");
                  },
                  color: Colors.white,
                )
              ],
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
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: new Text(
                                'Hi '+userData.name+'!',
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileScreen(userData:userData)));
                                  },
                                  color: Color.fromARGB(255, 37, 130, 242),
                                  child: new Text(
                                    "View Profile",
                                    style: new TextStyle(color: Colors.white),
                                  ),
                                ))
                          ],
                        ),
                        Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                          child: Text(
                            "Welcome to TartanHacks 2021. Here are all the places where the hacking is happening:",
                            style: new TextStyle(fontSize: 18),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      openUrl("http://href.scottylabs.org/discord");
                                    },
                                    color: Color.fromARGB(255, 114, 137, 218),
                                    child: new Text(
                                      "Discord",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      openUrl("http://href.scottylabs.org/hopin");
                                    },
                                    color: Color.fromARGB(255, 23, 95, 255),
                                    child: new Text(
                                      "Hopin",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      openUrl("https://tartanhacks.com");
                                    },
                                    color: Colors.red,
                                    child: new Text(
                                      "TH Website",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "HACKING TIME LEFT",
                          style: new TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        CountdownTimer(
                          endTime: 1615136400000,
                          textStyle: new TextStyle(
                            color: Color.fromARGB(255, 37, 130, 242),
                            fontSize: 30,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        ButtonTheme(
                            minWidth: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(builder: (ctxt) => new FormScreen()),
                                );
                              },
                              color: Color.fromARGB(255, 37, 130, 242),
                              child: new Text(
                                "View Your Project",
                                style: new TextStyle(color: Colors.white),
                              ),
                            )
                        )

                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical:10, horizontal: 3),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Upcoming Events",
                          style: new TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                    ListView.builder(
                                itemCount: eventData.length,
                                shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                      height: 220,
                                      width: double.maxFinite,
                                      child: Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        //color: getColor(eventData[index].access_code),
                                        child: Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Stack(children: <Widget>[
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Stack(children: <Widget>[
                                                    Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(8),
                                                            color: Color.fromARGB(
                                                                255, 37, 130, 242),
                                                          ),
                                                          width: 100,
                                                          height: 220,
                                                          child: Align(
                                                              alignment: Alignment.center,
                                                              child: eventTime(
                                                                  eventData[index]))),
                                                    ),
                                                    Padding(
                                                        padding: const EdgeInsets.only(
                                                            left: 10, top: 5),
                                                        child: Column(children: <Widget>[
                                                          Expanded(
                                                              flex: 3,
                                                              child:
                                                              Row(children: <Widget>[
                                                                //eventIcon(eventData[index]),
                                                                eventName(
                                                                    eventData[index]),
                                                              ])),
                                                          Expanded(
                                                            flex: 4,
                                                            child: !isAdmin
                                                                ? Row(children: <Widget>[
                                                              Container(
                                                                color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    37,
                                                                    130,
                                                                    242),
                                                                child: zoomLink(
                                                                    eventData[
                                                                    index]),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    37,
                                                                    130,
                                                                    242),
                                                                child: shareLink(
                                                                    eventData[
                                                                    index]),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              /*Container(
                                                        color: Color.fromARGB(255, 37, 130, 242),
                                                        child: calLink(
                                                            eventData[index]),
                                                      ),*/
                                                            ])
                                                                : Row(children: <Widget>[
                                                              Container(
                                                                color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    37,
                                                                    130,
                                                                    242),
                                                                child: zoomLink(
                                                                    eventData[
                                                                    index]),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    37,
                                                                    130,
                                                                    242),
                                                                child: shareLink(
                                                                    eventData[
                                                                    index]),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              /*Container(
                                                        color: Color.fromARGB(255, 37, 130, 242),
                                                        child: calLink(
                                                              eventData[index]),
                                                        ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),*/
                                                              Container(
                                                                color: Colors
                                                                    .redAccent[700],
                                                                //Color.fromARGB(255, 37, 130, 242) (Blue),
                                                                child: editEvent(
                                                                    eventData[
                                                                    index]),
                                                              ),
                                                            ]),
                                                          )
                                                        ])),
                                                  ]))
                                            ])),
                                      ));
                                })
                      ],
                    )),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), title: Text('HOME')),
            BottomNavigationBarItem(
                icon: Icon(Icons.event), title: Text('SCHEDULE')),
            BottomNavigationBarItem(
                icon: Icon(Icons.code), title: Text('PROJECT')),
            BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset), title: Text('POINTS')),
          ],
          currentIndex: selectedIndex,
          fixedColor: Color.fromARGB(255, 37, 130, 242),
          onTap: onNavigationItemTapped,
        ),
      );
    }

  }
}
