import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:thdapp/models/json-classes.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'events_home.dart';
import 'leaderboard.dart';
import 'qrcode.dart';
import 'hack.dart';

class CheckinHomeScreen extends StatefulWidget {
  final String userId;

  CheckinHomeScreen({Key key, this.userId}) : super(key: key);

  @override
  _CheckinHomeScreenState createState() =>
      new _CheckinHomeScreenState(userId: userId);
}

class _CheckinHomeScreenState extends State<CheckinHomeScreen> {
  SharedPreferences pref;

  String userId;
  int selectedIndex = 3;

  _CheckinHomeScreenState({Key key, this.userId});

  String name;
  List history;
  bool loaded = false;
  bool editing = false;
  int total_point = 0;

  void delHistory(hItem) {
    setState(() {
      history.remove(hItem);
    });
  }

  void onNavigationItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      if (selectedIndex == 1) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new EventsHomeScreen()),
        );
      } else if (selectedIndex == 2) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new FormScreen()),
        );
      } else if (selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new HomeScreen()),
        );
      }
    });
  }

  Future getHistory() async {
    pref = await SharedPreferences.getInstance();
    String token = await pref.getString("token");
    var queryParams = {
      "user_id": userId,
    };
    var response = await http.get(
        Uri.https("thd-api.herokuapp.com", "/checkin/history", queryParams),
        headers: {"token": token});

    Map data = json.decode(response.body);
    List raw = (data["checkin_history"]).reversed.toList();
    raw = raw
        .map((element) =>
        CheckinItem.fromJson(Map<String, dynamic>.from(element)))
        .toList();
    if (this.mounted) {
      setState(() {
        name = data["user"]["name"];
        history = raw.reversed.toList();
        loaded = true;
        total_point = data["user"]["total_points"];
      });
    }
  }

  @override
  void initState() {
    if (history != null) {
      history = null;
    }
    if (name != null) {
      name = null;
    }
    getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
          child: new AppBar(
            title: new Text(
              'Swag Points',
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 20,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 37, 130, 242),
          ),
          preferredSize: Size.fromHeight(60)),
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  new Text(
                    'Points Earned: '+ total_point.toString(),
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 30,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LeaderboardScreen()));
                              },
                              color: Color.fromARGB(255, 37, 130, 242),
                              child: new Text(
                                "Leaderboard",
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            QRPage())
                                ).then((val)=>getHistory());
                              },
                              color: Color.fromARGB(255, 37, 130, 242),
                              child: new Text(
                                "Check In",
                                style: new TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            )
          ),
        ),
        (history != null && history.length > 0)
            ?
        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (BuildContext context, int index) {
              return InfoTile(
                info: history[index],
                editing: editing,
                delHistory: delHistory,
              );
            },
          ),
        )
            : SizedBox(
            height: 100,
            child: Align(
                alignment: Alignment.center,
                child: (loaded)
                    ? Text("No checkin items found.",
                    style: TextStyle(
                      fontSize: 30,
                    ))
                    : Text("Loading...",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ))))
      ]),
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

class InfoTile extends StatelessWidget {
  final CheckinItem info;
  final bool editing;
  final Function delHistory;

  InfoTile({this.info, this.editing, this.delHistory});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(12),
        child: InkWell(
            onTap: () async {
              return showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('${info.name}',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                              info.has_checked_in
                                  ? 'Checked in ${DateFormat.jm()
                                  .add_yMd()
                                  .format(
                                  new DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(info.check_in_timestamp) *
                                        1000,
                                  ).toLocal())}.'
                                  : 'Not checked in.',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[700],
                              )),
                          const SizedBox(height: 14),
                          Text('${info.desc}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                              ))
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (editing)
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              delHistory(info);
                            })
                      else
                        info.has_checked_in
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank)
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${info.name}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 8),
                        Text(
                            info.has_checked_in
                                ? 'Checked in ${DateFormat.jm()
                                .add_yMd()
                                .format(new DateTime.fromMillisecondsSinceEpoch(
                              int.parse(info.check_in_timestamp) * 1000,
                            ).toLocal())}.'
                                : "Not checked in.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            )),
                      ])
                ]))));
  }
}
