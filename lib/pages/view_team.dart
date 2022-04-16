import 'package:flutter/material.dart';
import 'custom_widgets.dart';

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
  String teamID = "";
  Team team;
  String token;
  String memberID;
  String teamName;
  String teamDesc;
  List<Widget> teamMembers = <Widget>[];
  List<String> adminIds;
  int memLength;
  bool visible;
  bool flag = false;

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    memberID = prefs.getString('id');
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
      adminIds = team.admins.map((mem) => mem.id).toList();
      isAdmin = adminIds.contains(memberID);
      for (int i = 0; i < team.members.length; i++) {
        if (team.members[i].id == memberID) isMember = true;
      }
      teamMembers = [];
      for (int i = 0; i < memLength; i++) {
        teamMembers.add(_buildMember(i));
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
              icon: const Icon(Icons.email, size: 30.0),
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,
              onPressed: () {
                print("opened mail");
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
          Text(teamName ?? "", style: Theme
              .of(context)
              .textTheme
              .headline4),
          Text(teamDesc ?? "", style: Theme
              .of(context)
              .textTheme
              .bodyText2)
        ]
    );
  }

  Widget _buildMember(int member) {
    Member mem = team.members[member];
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
                                  color: Theme.of(context).colorScheme.secondary)
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
                promoteToAdmin(id, token);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ViewTeam())
                );
              },
            ),
          ],
        );
      },
    ).then((value) => getData());
  }

  Widget _inviteMessage() {
    TextEditingController inviteController = TextEditingController();
    String emailInvite;

    return AlertDialog(
        title: const Text('Send Invite'),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: formFieldStyle(context, "email"),
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
                              print("sent request");
                              print(emailInvite);
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
        body: SingleChildScrollView(
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
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: GradBox(
                                width: screenWidth * 0.9,
                                height: screenHeight * 0.75,
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                alignment: Alignment.topLeft,
                                child: SingleChildScrollView(
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
                                                     padding: const EdgeInsets
                                                         .fromLTRB(
                                                         0, 5, 0, 5),
                                                     child: _buildTeamDesc()
                                                 ),
                                                 _buildEditTeam(),
                                                 Container(
                                                     padding: const EdgeInsets
                                                         .fromLTRB(
                                                         0, 5, 0, 5),
                                                     child: _buildTeamMembers()
                                                 ),
                                                 _inviteMembersBtn(),
                                                 const SizedBox(height: 10),
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
                      ],
                    )
                  ],
                )
            )
        )
    );
  }
}
