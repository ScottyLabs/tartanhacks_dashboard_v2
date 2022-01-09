import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import '../api.dart';
import 'team-api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '/models/team.dart';
import '/models/member.dart';
import 'dart:convert';
import 'teams_list.dart';
import 'dart:async';

class ViewTeam extends StatefulWidget {
  @override
  _ViewTeamState createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ViewTeam> {

  bool isAdmin = false;
  bool isMember = false;
  String teamID = "";
  Team team;
  String token;
  String memberID;

  bool checkAdmin(String id){
    return team.admin.id == id;
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    memberID = prefs.getString('id');
    isAdmin = prefs.getBool('admin');
    print("Getting Data");
    print(teamID);
    if(teamID == ""){
      team = await getUserTeam(token);
    }
    else{
      team = await getTeamInfo(teamID, token);
    }
    if (team == null){ //if not on a team, redirects to the teams list page
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
          TeamsList())
      );
    }
    for(int i = 0; i < team.members.length; i++){
      if(team.members[i].id == memberID) isMember = true;
    }
    setState(() {
    });
  }

  @override
  initState() {
    super.initState();
  }

  Widget _buildEditTeam() {
    if (isAdmin && isMember) {
      return SolidButton(
        text: "EDIT TEAM NAME AND INFO", 
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => _editTeamInfo()
          );
        },
        color: Theme.of(context).colorScheme.primary);
    } else {
      return Container();
    }
  }

   Widget _editTeamInfo(){
    if(!isAdmin || !isMember) return Container();
    TextEditingController teamNameController = TextEditingController();
    TextEditingController teamDescController = TextEditingController();
    String teamName = team.name;
    String teamDesc = team.description;
    bool visible = team.visible;
    teamNameController.text = teamName;
    teamDescController.text = teamDesc;

    return AlertDialog(
                  title: Text('Edit Name & Description'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Team Name',
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                        style: TextStyle(color: Colors.black),
                        controller: teamNameController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'A name is required';
                          }
                          return null;
                          },
                          onSaved: (String value) {
                            teamName = value;
                          },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Description',
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                        style: TextStyle(color: Colors.black),
                        controller: teamDescController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'A description is required';
                          }
                          return null;
                          },
                          onSaved: (String value) {
                            teamDesc = value;
                          },
                      ),
                      CheckboxListTile(
                            title: Text("Team Visibility"),
                            activeColor: Theme.of(context).colorScheme.secondary,
                            value: visible,
                            onChanged: (value) {
                              setState(() {
                                visible = value;
                              });
                            },
                      ),
                      Container( 
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: SolidButton(
                          text: "Save",
                          onPressed: () async {
                            await updateTeamInfo(teamName, teamDesc, visible, token);
                            team = await getUserTeam(token);
                          }
                        )
                      )
                    ]
                  )
      );
  }

  Widget _buildTeamMail(){
    if (isAdmin && isMember) {
      return Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.email, size: 30.0),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: (){
                print("opened mail");
                getUserMail(token);
              }
          )
      );
    } else {
      return Container();
    }
  }


  Widget _buildTeamHeader() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("TEAM", style: Theme.of(context).textTheme.headline2)
          ),
          _buildTeamMail()
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
    Member mem = team.members[member];
    String email_str = "(" + mem.email + ")";
    String name_str = mem.name;
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

  Widget _inviteMessage(){
    TextEditingController inviteController = TextEditingController();
    String email_invite;

    return AlertDialog(
                  title: Text('Send Invite'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: FormFieldStyle(context, "email"),
                        style: TextStyle(color: Colors.black),
                        controller: inviteController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'An email is required';
                          }
                          return null;
                          },
                          onSaved: (String value) {
                            email_invite = value;
                            },
                      ),
                      Container( 
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: SolidButton(
                          text: "Send",
                          onPressed: () async {
                            await requestTeamMember(email_invite, token);
                          }
                        )
                      )
                    ]
                  )
      );
  }

  Widget _inviteMembersBtn()  {
    if (team.members.length < 4 && isAdmin && isMember){
      return SolidButton(
        text: "INVITE NEW MEMBER", 
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => _inviteMessage()
          );
        }, 
        color: Theme.of(context).colorScheme.primary); 
    } else {
      return Container();
    }
  }

  Widget _buildTeamMembers() {
    List<Widget> teamMembers = <Widget>[];
    for(int i = 0; i < team.members.length; i++){
      print(team.members[i].name);
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

  Widget _leaveJoinTeamBtn() {
    if(!isMember) return Container();
    String buttonText = "Leave Team";
    return SolidButton(
      text: buttonText, 
      onPressed: () {
        leaveTeam(token);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
          TeamsList()),
        );
      },
      color: Theme.of(context).colorScheme.secondary);
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    if(ModalRoute.of(context) != null){
      teamID = ModalRoute.of(context).settings.arguments as String;
    }
    else{
      teamID = "";
    }
    getData();
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
                                              _buildEditTeam(),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                                child: _buildTeamMembers()
                                              ),
                                              _inviteMembersBtn()
                                            ]
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            
                                            children: [Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                                              child: _leaveJoinTeamBtn())]
                                          )
                                        ],
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

