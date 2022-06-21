import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/models/lb_entry.dart';
import 'custom_widgets.dart';
import '../models/profile.dart';
import 'package:thdapp/api.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<LBEntry> lbData;
  int selfRank;
  Profile userData;
  String token;
  final TextEditingController _editNicknameController = TextEditingController();

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    String id = prefs.getString('id');

    lbData = await getLeaderboard();
    selfRank = await getSelfRank(token);
    userData = await getProfile(id, token);
    setState(() {

    });
  }

  _editNickname() async {
    _editNicknameController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Enter New Nickname", style: Theme.of(context).textTheme.headline1),
          content: TextField(
            controller: _editNicknameController,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "Cancel",
                style: Theme.of(context
                ).textTheme.headline4,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Save",
                style: Theme.of(context).textTheme.headline4,
              ),
              onPressed: () async{
                OverlayEntry loading = loadingOverlay(context);
                Overlay.of(context).insert(loading);
                bool success = await setDisplayName(_editNicknameController.text, token);
                loading.remove();

                if (success == null) {
                  errorDialog(context, "Error", "An error occurred. Please try again.");
                } else if (success) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        title: Text("Success", style: Theme.of(context).textTheme.headline1),
                        content: Text("Nickname has been changed.", style: Theme.of(context).textTheme.bodyText2),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          TextButton(
                            child: Text(
                              "OK",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            onPressed: () {
                              Navigator.of(context).popUntil(ModalRoute.withName("leaderboard"));
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  errorDialog(context, "Nickname taken", "Please try a different name.");
                }
              },
            ),
          ],
        );
      },
    ).then((value) => getData());
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _editNicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: screenHeight
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const TopBar(backflag: true),
                    Stack(
                      children: [
                        Column(
                            children:[
                              SizedBox(height:screenHeight * 0.05),
                              CustomPaint(
                                  size: Size(screenWidth, screenHeight * 0.75),
                                  painter: CurvedTop(
                                      color1: Theme.of(context).colorScheme.secondaryVariant,
                                      color2: Theme.of(context).colorScheme.primary,
                                      reverse: true)
                              ),
                            ]
                        ),
                        if (userData == null)
                          const Center(child: CircularProgressIndicator())
                        else
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            height: screenHeight*0.75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GradBox(
                                  width: screenWidth*0.9,
                                  height: 120,
                                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("YOUR POSITION:", style: Theme.of(context).textTheme.headline3),
                                          SolidButton(
                                            child: Icon(Icons.edit, color: Theme.of(context).colorScheme.onSecondary),
                                            color: Theme.of(context).colorScheme.secondary,
                                            onPressed: _editNickname,
                                          ),
                                        ],
                                      ),
                                      LBRow(
                                          place: selfRank,
                                          name: userData.displayName,
                                          points: userData.totalPoints
                                      ),
                                    ],
                                  ),
                                ),
                                GradBox(
                                    width: screenWidth*0.9,
                                    height: screenHeight*0.55,
                                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("LEADERBOARD", style: Theme.of(context).textTheme.headline1),
                                          Text("Scroll to see the whole board!",
                                            style: Theme.of(context).textTheme.bodyText2,
                                          ),
                                          Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: ListView.builder(
                                                  itemCount: lbData.length,
                                                  itemBuilder: (BuildContext context, int index){
                                                    return LBRow(
                                                        place: lbData[index].rank,
                                                        name: lbData[index].displayName,
                                                        points: lbData[index].totalPoints
                                                    );
                                                  },
                                                ),
                                              )
                                          )
                                        ]
                                    )
                                )
                              ],
                            )
                        )
                      ],
                    )
                  ],
                )
            )
        )
    );
  }
}

class LBRow extends StatelessWidget {
  final int place;
  final String name;
  final int points;

  const LBRow({this.place, this.name, this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            alignment: Alignment.center,
            child: Text(place.toString(), style: Theme.of(context).textTheme.headline1,),
          ),
          Expanded(child: SolidButton(text: name, onPressed: null)),
          Container(
              width: 80,
              alignment: Alignment.center,
              child: Text("$points pts", style: Theme.of(context).textTheme.bodyText2,)
          )
        ],
      )
    );
  }
}