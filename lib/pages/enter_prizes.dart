import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart';
import '../models/prize.dart';

class EnterPrizes extends StatefulWidget {
  @override
  _EnterPrizesState createState() => new _EnterPrizesState();
}

class _EnterPrizesState extends State<EnterPrizes> {

  SharedPreferences prefs;
  bool isAdmin;
  String id;
  String token;

  List<Prize> prizes;

  void getData() async{
    prefs = await SharedPreferences.getInstance();

    isAdmin = prefs.getBool('admin');
    id = prefs.getString('id');
    token = prefs.getString('token');

    prizes = await getPrizes();

    setState(() {

    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    if (prizes == null){
      return LoadingScreen();
    } else {
      return Scaffold(
          body:Container(
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
                      Column(
                        children: [
                          Container(
                              height: screenHeight*0.15,
                              width: screenWidth,
                              padding: EdgeInsets.fromLTRB(25, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ENTER FOR PRIZE",
                                    style: Theme.of(context).textTheme.headline1,
                                  ),
                                  Text("Scroll to see the full list.",
                                    style: Theme.of(context).textTheme.bodyText2,
                                  )
                                ],
                              )
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: screenHeight*0.65
                                ),
                                child: ListView.builder(
                                  itemCount: prizes.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return PrizeCard(
                                      id: prizes[index].id,
                                      name: prizes[index].name,
                                      desc: prizes[index].description
                                    );
                                  },
                                ),
                              )
                          )
                        ],
                      )
                    ],
                  )
                ],
              )
          )
      );
    }
  }
}

class PrizeCard extends StatelessWidget{
  String id;
  String name;
  String desc;


  PrizeCard({this.id, this.name, this.desc});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: GradBox(
        width: 100,
        height: 200,
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(name,
              style: Theme.of(context).textTheme.headline2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(desc,
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SolidButton(
              text: "   Submit   ",
              onPressed: null,
            )
          ],
        )
      )
    );
  }
}
