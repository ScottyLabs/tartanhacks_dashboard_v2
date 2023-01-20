import 'package:flutter/material.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';

import 'team_api.dart';
import 'view_team.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/team.dart';
class CreateTeam extends StatefulWidget {
  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {

  String _teamName = "";
  String _teamDesc = "";

  TextEditingController yourNameController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();
  TextEditingController teamDescController = TextEditingController();
  TextEditingController inviteMemberController = TextEditingController();
  bool visibility = true;
  String buttonText = "Create Team";

  String token;
  SharedPreferences prefs;
  Team team;
  String id;
  bool noTeam = true;
  void getData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    id = prefs.getString('id');
    team = await getUserTeam(token);
    if (team != null){ //if not on a team, redirects to the teams list page
      _teamName = team.name;
      _teamDesc = team.description;
      visibility = team.visible;
      teamNameController.text = _teamName;
      teamDescController.text = _teamDesc;
      buttonText = "Edit Team";
      noTeam = false;
    }
    setState(() {
    });
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    yourNameController.dispose();
    teamNameController.dispose();
    teamDescController.dispose();
    inviteMemberController.dispose();
    super.dispose();
  }


  Widget _buildTeamName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Team Name"),
      style: Theme
          .of(context)
          .textTheme
          .bodyText2,
      controller: teamNameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Your team name is required';
        }
        return null;
      },
      onChanged: (String value) {
        _teamName = value;
      },
    );
  }

  Widget _buildTeamDesc() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Team Description"),
      style: Theme
          .of(context)
          .textTheme
          .bodyText2,
      controller: teamDescController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Team description is required';
        }

        return null;
      },
      onChanged: (String value) {
        _teamDesc = value;
      },
    );
  }

  Widget _visible(){
    return Row(
      children: [
        const Text("Team Visibility"),
        Checkbox(
          activeColor: Theme.of(context).colorScheme.secondary,
          value: visibility,
          onChanged: (bool newValue) {
            setState(() {
                  visibility = newValue; 
            }); 
          },
        ),
      ]
    );
  }

  Widget _inviteMessage(){
    TextEditingController inviteController = TextEditingController();
    String emailInvite;

    return AlertDialog(
                  title: const Text('Send Invite'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: "email"),
                        style: const TextStyle(color: Colors.black),
                        controller: inviteController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'An email is required';
                          }
                          return null;
                          },
                          onSaved: (String value) {
                            emailInvite = value;
                            },
                      ),
                      Container( 
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
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
                                await requestTeamMember(emailInvite, token);
                              }
                            )
                          ]
                        )
                      )
                    ]
                  )
      );
  }

  Widget _inviteMem()  {
    return SolidButton(
        text: "INVITE NEW MEMBER", 
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => _inviteMessage()
          );
        }, 
        color: Theme.of(context).colorScheme.primary); 
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    return DefaultPage(
      backflag: true,
      reverse: true,
      child:
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: GradBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.75,
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment
                        .start,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment
                              .start,
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: [
                            Text("TEAM INFO", style:
                            Theme.of(context).textTheme.headline1),
                            SizedBox(height:screenHeight*0.02),
                            Text("Basic Info", style:
                            Theme.of(context).textTheme.headline4),
                            // SizedBox(height:screenHeight*0.02),
                            // _buildName(),
                            SizedBox(height:screenHeight*0.02),
                            _buildTeamName(),
                            SizedBox(height:screenHeight*0.02),
                            _buildTeamDesc(),
                            SizedBox(height:screenHeight*0.02),
                            _visible(),
                            SizedBox(height:screenHeight*0.02),
                            _inviteMem()
                          ],
                      ),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: SolidButton(
                            text: buttonText,
                            onPressed: () async {
                              if (noTeam) {
                                await createTeam(_teamName, _teamDesc, visibility, token);
                              } else {
                                await editTeam(_teamName, _teamDesc, visibility, token);
                              }
                              await promoteToAdmin(id, token);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ViewTeam())
                              );
                            },
                            color: Theme.of(context).colorScheme.secondary
                          )
                      )
                  ]
                )
            )
        )
    );
  }
}
