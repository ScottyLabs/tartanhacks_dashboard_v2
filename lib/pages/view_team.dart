import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/ErrorDialog.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/providers/user_info_provider.dart';

import 'team_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/team.dart';
import '/models/member.dart';
import 'see_invites.dart';
import 'teams_list.dart';
import 'create_team.dart';

class ViewTeam extends StatefulWidget {
  @override
  _ViewTeamState createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ViewTeam> {

  bool isAdmin = false;
  bool isMember = false;
  bool hasTeam = false;
  Team team;
  String token;
  String memberID;
  List<String> adminIds;

  Future<void> _getData(String teamID, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    memberID = prefs.getString('id');

    if (teamID == '' && !hasTeam) { //if not on a team, redirects to the teams list page
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>
              TeamsList())
      );
      return;
    } else if (teamID != ''){
      team = await getTeamInfo(teamID, token);
    }

    adminIds = team.admins.map((mem) => mem.id).toList();
    isAdmin = adminIds.contains(memberID);
    isMember = team.members.map((e) => e.id).contains(memberID);
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
              icon: const Icon(Icons.email, size: 30.0),
              color: Theme
                  .of(context)
                  .colorScheme
                  .tertiaryContainer,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      ViewInvites()),
                );
              }
          )
      );
    } else {
      return Container();
    }
  }


  Widget _buildTeamHeader() {
    return SizedBox(
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(team.name ?? "", style: Theme
              .of(context)
              .textTheme
              .headline4),
          Text(team.description ?? "", style: Theme
              .of(context)
              .textTheme
              .bodyText2)
        ]
    );
  }

  Widget _buildMember(Member mem) {
    String id = mem.id;
    String emailStr = "(" + mem.email + ")";
    String nameStr = mem.name;
    bool isMemAdmin = adminIds.contains(id);
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text: TextSpan(
                      children: [
                        TextSpan(text: nameStr + "  ", style: Theme
                            .of(context)
                            .textTheme
                            .bodyText2),
                        if (isMemAdmin)
                          WidgetSpan(
                              child: Icon(Icons.star,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.tertiaryContainer)
                          )
                      ]
                  )),
                  Text(emailStr, style: Theme
                      .of(context)
                      .textTheme
                      .bodyText2)
                ]
            ),
            if (isAdmin && !isMemAdmin)
            SolidButton(
              text: "Promote",
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                promoteConfirm(id);
              },
            )
          ]
        )
    );
  }

  void promoteConfirm(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Confirmation", style: Theme.of(context).textTheme.headline1),
          content: Text("Are you sure you want to promote this member to an admin? You will no longer be an admin.", style: Theme.of(context).textTheme.bodyText2),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "Cancel",
                style: Theme.of(context).textTheme.headline4,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "OK",
                style: Theme.of(context).textTheme.headline4,
              ),
              onPressed: () {
                promoteToAdmin(id, token).then(
                    (_) {
                      Navigator.of(context).pop();
                      Provider.of<UserInfoModel>(context).fetchUserInfo();}
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _inviteMessage() {
    TextEditingController inviteController = TextEditingController();
    String emailInvite;

    return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Send Invite', style: Theme.of(context).textTheme.headline1),
        content: TextFormField(
          decoration: const InputDecoration(labelText: "email"),
          style: const TextStyle(color: Colors.black),
          controller: inviteController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'An email is required';
            }
            return null;
          },
          onChanged: (String value) {
            emailInvite = value;
          },
        ),
      actions: [
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
            "Send",
            style: Theme.of(context
            ).textTheme.headline4,
          ),
          onPressed: () async {
            await requestTeamMember(emailInvite, token);
          },
        ),
      ],
    );
  }

  Widget _inviteMembersBtn() {
    if (team.members.length < 4 && isAdmin && isMember) {
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
              children: team.members.map((e) => _buildMember(e)).toList()
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
          if (isAdmin && adminIds.length==1) {
            errorDialog(context, "Error", "You cannot leave the team if "
                "you are the only admin. You must promote someone else to admin "
                "before leaving.");
          } else {
            leaveTeam(token);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  TeamsList()),
            );
          }
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

    hasTeam = Provider.of<UserInfoModel>(context).hasTeam;
    team = Provider.of<UserInfoModel>(context).team;

    String teamID = "";
    if (ModalRoute.of(context) != null) {
      teamID = ModalRoute
          .of(context)
          .settings
          .arguments as String;
    }
    var _data = _getData(teamID, context);

    return DefaultPage(
      backflag: teamID != "",
      reverse: true,
      child:
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: GradBox(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.75,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                      child: FutureBuilder(
                        future: _data,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTeamHeader(),
                                  if (team != null)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                            child: _buildTeamDesc()
                                        ),
                                        _buildEditTeam(),
                                        Container(
                                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                            child: _buildTeamMembers()
                                        ),
                                        _inviteMembersBtn(),
                                        const SizedBox(height: 10),
                                        _leaveJoinTeamBtn()
                                      ],
                                    )
                                  else
                                    Center(child: CircularProgressIndicator(
                                        color: Theme.of(context).colorScheme.onSurface))
                                ]
                            );
                          } else {
                            return const Center(child: Padding(
                                child: CircularProgressIndicator(),
                              padding: EdgeInsets.symmetric(vertical: 50),
                            ));
                          }
                        },
                      )
                  )
              )
          )
    );
  }
}
