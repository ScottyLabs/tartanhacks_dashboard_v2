import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import '../api.dart';
<<<<<<< Updated upstream
import 'package:shared_preferences/shared_preferences.dart';
import 'team-api.dart';
import '/models/team.dart';
=======
import 'team-api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '/models/team.dart';
import 'dart:convert';
>>>>>>> Stashed changes

class ViewTeam extends StatefulWidget {
  @override
  _ViewTeamState createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ViewTeam> {
  SharedPreferences prefs;

  List<Map> _teamMembers = [
    {'name': "", 'email': ""},
    {'name': "", 'email': ""},
    {'name': "", 'email': ""}
    ];
  String _teamName = "My Team";
  String _teamDesc = "Team Description";
  int numMembers = 3;
  bool isAdmin = false;
  bool isMember = true;
<<<<<<< Updated upstream
  String teamId;
  String token;

  Team team;

  void leaveJoin(isMember) async {
    if (isMember){
      leaveTeam(token);
    } else {
      requestTeam(team.teamId, token);
    }
  }

  void getData() async{
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    token = prefs.getString('token');
    teamId = getUserTeam(token);
    team = getTeamInfo(teamId, token);
    _teamMembers = team.members;
    _teamDesc = team.description;
=======
  String teamId = "";
  Team team;

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    String id = prefs.getString('id');
    isAdmin = prefs.getBool('admin');
    team = await getUserTeam(token);
    print(team.teamID);
    print(team.members);
    setState(() {
    });
>>>>>>> Stashed changes
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  Widget _buildTeamHeader() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(team.name, style: Theme.of(context).textTheme.headline2),
        ]
    );
  }

  Widget _buildTeamDesc() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(team.name, style: Theme.of(context).textTheme.headline4),
          Text(team.description, style: Theme.of(context).textTheme.bodyText2)
        ]
    );
  }

  Widget _buildMember(int member) {
    dynamic mem = team.members[member];
    String email_str = "(" + mem['email'] + ")";
    String name_str = mem['firstName'] + " " + mem['lastName'];
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name_str, style: Theme.of(context).textTheme.bodyText2),
          Text(email_str, style: Theme.of(context).textTheme.bodyText2)
        ]
    ));
  }

  Widget _buildTeamMembers() {
    List<Widget> teamMembers = <Widget>[];
    for(int i = 0; i < team.members.length; i++){
      print(team.members[i]['firstName']);
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

  Widget _leaveJoinTeamBtn(bool isMember) {
    String buttonText = "Leave Team";
    if(!isMember){
      buttonText = "Join Team";
    }
<<<<<<< Updated upstream
    return (
        SolidButton(
          text: "Leave Team",
    ),
  }

  List<Widget> _infoList(bool isMember){
    List<Widget> info = <Widget>[];
    info.add(
        Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            //height: screenHeight*0.05,
            child: _buildTeamHeader()
        )
    );
    info.add(
        Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //height: screenHeight*0.2,
            child: _buildTeamDesc()
        )
    );
    info.add(
        Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //height: screenHeight*0.1,
            child: _buildTeamMembers(numMembers)
        )
    );
    info.add(_leaveJoinTeamBtn(isMember));
    return info;
=======
    return SolidButton(text: buttonText, onPressed: null, color: Theme.of(context).colorScheme.secondary);
>>>>>>> Stashed changes
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
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: 
                                        [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                                child: _buildTeamHeader()
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                                                child: _buildTeamDesc()
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(0, 5, 20, 20),
                                                child: _buildTeamMembers()
                                              )
                                            ]
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            
                                            children: [Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                                              child: _leaveJoinTeamBtn(isMember))]
                                          )
                                        ],
                                    )
                                )
                            ),
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