import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/providers/user_info_provider.dart';

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

  String id;
  bool hasTeam = false;
  void getData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    id = prefs.getString('id');

    hasTeam = Provider.of<UserInfoModel>(context, listen: false).hasTeam;

    if (hasTeam){
      Team team = Provider.of<UserInfoModel>(context, listen: false).team;
      _teamName = team.name;
      _teamDesc = team.description;
      visibility = team.visible;
      teamNameController.text = _teamName;
      teamDescController.text = _teamDesc;
      buttonText = "Edit Team";
    }
    setState(() {});
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15,),
                            Text("TEAM INFO", style:
                            Theme.of(context).textTheme.headline1),
                            const SizedBox(height: 10),
                            Text("Basic Info", style:
                            Theme.of(context).textTheme.headline4),
                            // SizedBox(height:screenHeight*0.02),
                            // _buildName(),
                            const SizedBox(height: 15),
                            _buildTeamName(),
                            const SizedBox(height: 20),
                            _buildTeamDesc(),
                            const SizedBox(height: 20),
                            _visible(),
                          ],
                      ),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: SolidButton(
                            text: buttonText,
                            onPressed: () async {
                              if (!hasTeam) {
                                await createTeam(_teamName, _teamDesc, visibility, token);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      ViewTeam(),
                                      settings: const RouteSettings(
                                        arguments: "",
                                      )
                                  ),
                                );
                              } else {
                                await editTeam(_teamName, _teamDesc, visibility, token);
                                Provider.of<UserInfoModel>(context, listen: false).fetchUserInfo();
                                Navigator.pop(context);
                              }
                              await promoteToAdmin(id, token);
                            },
                            color: Theme.of(context).colorScheme.tertiaryContainer
                          )
                      )
                  ]
                )
            )
        )
    );
  }
}
