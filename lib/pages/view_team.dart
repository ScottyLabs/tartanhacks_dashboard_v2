import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

import '../api.dart';
import 'team-api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '/models/team.dart';
import '/models/member.dart';
import 'see-invites.dart';
import 'dart:convert';
import 'teams_list.dart';
import 'dart:async';
import 'create_team.dart';

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
  String teamName;
  String teamDesc;
  List<Widget> teamMembers = <Widget>[];
  int memLength;
  bool visible;
  bool flag = false;

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    memberID = prefs.getString('id');
    isAdmin = prefs.getBool('admin');
    team = await getUserTeam(token);
    getTeams(token);
    if (teamID == '' &&
        team == null) { //if not on a team, redirects to the teams list page
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              TeamsList())
      );
    } else {
      if (team == null) {
        team = await getTeamInfo(teamID, token);
        flag = true;
      }
      print(team);
      teamName = team.name;
      teamDesc = team.description;
      memLength = team.members.length;
      visible = team.visible;
      isAdmin = team.admin.id == memberID;
      for (int i = 0; i < team.members.length; i++) {
        if (team.members[i].id == memberID) isMember = true;
      }
      setState(() {});
    }
  }

  @override
  initState() {
    getData();
    super.initState();
    getData();
  }

  Widget _buildEditTeam() {
    if (isAdmin && isMember) {
      return SolidButton(
          text: "EDIT TEAM NAME AND INFO",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  CreateTeam()),
            );
          },
          color: Theme
              .of(context)
              .colorScheme
              .primary);
    } else {
      return Container();
    }
  }

  Widget _buildTeamMail() {
    if (isAdmin && isMember) {
      return Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              icon: Icon(Icons.email, size: 30.0),
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              onPressed: () {
                print("opened mail");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      viewInvites()),
                );
              }
          )
      );
    } else {
      return Container();
    }
  }


  Widget _buildTeamHeader() {
    return Container(
      height: 50,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("TEAM", style: Theme
                .of(context)
                .textTheme
                .headline1),
            _buildTeamMail()
          ]
      )
    );
  }

  Widget _buildTeamDesc() {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(teamName ?? "", style: Theme
                .of(context)
                .textTheme
                .headline4),
            Text(teamDesc ?? "", style: Theme
                .of(context)
                .textTheme
                .bodyText2)
          ]
      )
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
              Text(name_str, style: Theme
                  .of(context)
                  .textTheme
                  .bodyText2),
              Text(email_str, style: Theme
                  .of(context)
                  .textTheme
                  .bodyText2)
            ]
        ));
  }

  Widget _inviteMessage() {
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
                onChanged: (String value) {
                  email_invite = value;
                },
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SolidButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            text: "Cancel"
                        ),
                        SolidButton(
                            text: "Send",
                            onPressed: () async {
                              print("sent request");
                              print(email_invite);
                              await requestTeamMember(email_invite, token);
                            }
                        )
                      ]
                  )
              )
            ]
        )
    );
  }

  Widget _inviteMembersBtn() {
    if (memLength < 4 && isAdmin && isMember) {
      return SolidButton(
          text: "INVITE NEW MEMBER",
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => _inviteMessage()
            );
          },
          color: Theme
              .of(context)
              .colorScheme
              .primary);
    } else {
      return Container();
    }
  }

  Widget _buildTeamMembers() {
    teamMembers = [];
    for (int i = 0; i < memLength; i++) {
      teamMembers.add(_buildMember(i));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Team Members", style: Theme
              .of(context)
              .textTheme
              .headline4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: teamMembers
          )
        ]
    );
  }


  Widget _leaveJoinTeamBtn() {
    if (!isMember) return Container();
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
        color: Theme
            .of(context)
            .colorScheme
            .secondary);
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    if (ModalRoute.of(context) != null) {
      teamID = ModalRoute
          .of(context)
          .settings
          .arguments as String;
    }
    else {
      teamID = "";
    }
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
                        TopBar(backflag: flag),
                        Stack(
                          children: [
                            Column(
                                children: [
                                  SizedBox(height: screenHeight * 0.05),
                                  CustomPaint(
                                      size: Size(
                                          screenWidth, screenHeight * 0.75),
                                      painter: CurvedTop(
                                          color1: Theme
                                              .of(context)
                                              .colorScheme
                                              .secondaryVariant,
                                          color2: Theme
                                              .of(context)
                                              .colorScheme
                                              .primary,
                                          reverse: true)
                                  ),
                                ]
                            ),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: GradBox(
                                    width: screenWidth * 0.9,
                                    height: screenHeight * 0.75,
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    alignment: Alignment.topLeft,
                                    child: SingleChildScrollView(
                                        child: Container(
                                           child: Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  _buildTeamHeader(),
                                                  if (team != null)
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                0, 5, 0, 5),
                                                            child: _buildTeamDesc()
                                                        ),
                                                        _buildEditTeam(),
                                                        Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                0, 5, 0, 5),
                                                            child: _buildTeamMembers()
                                                        ),
                                                        _inviteMembersBtn(),
                                                        SizedBox(height: 10),
                                                        _leaveJoinTeamBtn()
                                                      ],
                                                    )
                                                  else
                                                    Center(child: CircularProgressIndicator(
                                                        color: Theme
                                                            .of(context)
                                                            .colorScheme
                                                            .onSurface))
                                                ]
                                            )
                                        )
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
