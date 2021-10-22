import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class ViewTeam extends StatefulWidget {
  @override
  _ViewTeamState createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ViewTeam> {

  List<Map> _teamMembers = [
    {'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"},
    {'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"},
    {'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"}
    ];
  String _teamName = "My Team";
  String _teamDesc = "Team Description";
  int numMembers = 3;

  Widget _buildTeamHeader() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("TEAM", style: Theme.of(context).textTheme.headline2),
        ]
    );
  }

  Widget _buildTeamDesc() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_teamName, style: Theme.of(context).textTheme.headline4),
          Text(_teamDesc, style: Theme.of(context).textTheme.bodyText2)
        ]
    );
  }

  Widget _buildMember(int member) {
    String email_str = "(" + _teamMembers[member]['email'] + ")";
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_teamMembers[member]['name'], style: Theme.of(context).textTheme.bodyText2),
          Text(email_str, style: Theme.of(context).textTheme.bodyText2)
        ]
    );
  }

  Widget _buildTeamMembers(int numMembers) {
    List<Widget> teamMembers = List.empty();
    for(int i = 0; i < numMembers; i++){
      teamMembers.add(_buildMember(i));
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Team Members", style: Theme.of(context).textTheme.headline4),
          Column(
              children: teamMembers
          )
        ]
    );
  }

  Widget _leaveTeamBtn() {
    return (
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                  shadowColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryVariant),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  elevation: MaterialStateProperty.all(5),
                ),
                child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text("Leave Team",
                        style: TextStyle(fontSize:16.0, fontWeight: FontWeight.w600,color:Theme.of(context).colorScheme.onPrimary),
                        overflow: TextOverflow.fade,
                        softWrap: false
                    )
                )
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
        body:  Container(
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
                                child: GradBox(
                                    width: screenWidth*0.9,
                                    height: screenHeight*0.75,
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                              //height: screenHeight*0.05,
                                              child: _buildTeamHeader()
                                          ),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                              //height: screenHeight*0.2,
                                              child: _buildTeamDesc()
                                          ),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                              //height: screenHeight*0.1,
                                              child: _buildTeamMembers(numMembers)
                                          ),
                                          _leaveTeamBtn()
                                        ]
                                    )
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