import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:thdapp/models/event_model.dart';
import 'package:thdapp/api.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'checkin_home.dart';
import 'events_edit.dart';
import 'package:thdapp/models/login_model.dart';
import 'package:thdapp/models/participant_model.dart';
import 'hack.dart';

class EventsHomeScreen extends StatefulWidget {
  @override
  _EventsHomeScreenState createState() => _EventsHomeScreenState();
}

class _EventsHomeScreenState extends State<EventsHomeScreen> {

  SharedPreferences prefs;
  Participant userData;

  bool isAdmin = false;
  var eventData = [];
  final past_events = [];
  final upcoming_events = [];
  bool isSwitched = false;
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void onNavigationItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      if (selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new HomeScreen()),
        );
      } else if (selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new FormScreen()),
        );
      } else if (selectedIndex == 3) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new CheckinHomeScreen(userId: userData.id,)),
        );
      } else if (selectedIndex == 4) {}
    });
  }

  getData() async {

    prefs = await SharedPreferences.getInstance();

    isAdmin = prefs.getBool("is_admin");

    eventData = await getEvents();
    var currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
    for (int i = 0; i < eventData.length; i++) {
      if (currentTime > int.parse(eventData[i].timestamp)) {
        past_events.add(eventData[i]);
      } else {
        upcoming_events.add(eventData[i]);
      }
    }
    eventData = upcoming_events;

    String email = prefs.get('email');
    String password = prefs.get('password');
    isAdmin = prefs.getBool('is_admin');

    Login  loginData = await checkCredentials(email, password);
    userData = loginData.user;
    setState(() {});
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
                fontSize: 10,
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
    // if statement (if participant, return this... if admin, return with admin privileges)
    return new Scaffold(
      appBar: AppBar(
        title: Text("Events"),
        backgroundColor: Color.fromARGB(255, 37, 130, 242), //blue
        actions: <Widget>[
          Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                print(isSwitched);
                if (isSwitched == false)
                  eventData = upcoming_events;
                else
                  eventData = past_events;
              });
            },
            activeTrackColor: Color.fromARGB(120, 33, 42, 54),
            activeColor: Color.fromARGB(150, 33, 42, 54),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(240, 255, 255, 255),
      //gray
      body: Container(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                        itemCount: eventData.length,
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
                                                      flex: 2,
                                                      child:
                                                      Row(children: <Widget>[
                                                        //eventIcon(eventData[index]),
                                                        eventName(
                                                            eventData[index]),
                                                      ])),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Row(children: <Widget>[
                                                      eventDescription(
                                                          eventData[index]),
                                                    ]),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
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
                        }))
              ])),
      // floating action button needs to show up exclusively for participants
      floatingActionButton: !isAdmin
          ? null
          : FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditEventsScreen())); // need to move into a new event popup page here;
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent[
        700], // Color.fromARGB(255, 37, 130, 242) Blue// ,
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
