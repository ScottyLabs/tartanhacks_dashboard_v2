import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/models/lb_entry.dart';
import 'custom_widgets.dart';
import '../models/profile.dart';
import 'package:thdapp/api.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => new _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<LBEntry> lbData;
  int selfRank;
  Profile userData;

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String id = prefs.getString('id');

    lbData = await getLeaderboard();
    selfRank = await getSelfRank(token);
    userData = await getProfile(id, token);
    setState(() {

    });
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    if (lbData == null) {
      return LoadingScreen();
    } else {
      return Scaffold(
          body: Container(
              child: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: screenHeight
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TopBar(backflag: true),
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
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  height: screenHeight*0.75,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GradBox(
                                        width: screenWidth*0.9,
                                        height: 110,
                                        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("YOUR POSITION:", style: Theme.of(context).textTheme.headline3),
                                            LBRow(
                                                place: selfRank,
                                                name: userData.displayName,
                                                points: userData.totalPoints
                                            )
                                          ],
                                        ),
                                      ),
                                      GradBox(
                                          width: screenWidth*0.9,
                                          height: screenHeight*0.55,
                                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
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
          )
      );
    }
  }
}

class LBRow extends StatelessWidget {
  int place;
  String name;
  int points;


  LBRow({this.place, this.name, this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
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