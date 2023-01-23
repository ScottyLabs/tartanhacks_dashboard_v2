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

class InviteMembersBtn extends StatelessWidget {
  final Team team;

  const InviteMembersBtn(this.team);

  // Show invitation dialog
  Widget _inviteMessage(BuildContext context) {
    TextEditingController inviteController = TextEditingController();
    String emailInvite;

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text('Send Invite', style: Theme.of(context).textTheme.headline1),
      content: TextFormField(
        decoration: const InputDecoration(labelText: "email"),
        style: Theme.of(context).textTheme.bodyText2,
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
          onPressed: () {
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
            Navigator.of(context).pop();
            String token = Provider.of<UserInfoModel>(context, listen: false).token;
            await requestTeamMember(emailInvite, token);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SolidButton(
        text: "INVITE NEW MEMBER",
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => _inviteMessage(context)
          );
        },
        color: Theme
            .of(context)
            .colorScheme
            .primary);
  }
}

class LeaveJoinTeamBtn extends StatelessWidget {
  final Team team;
  final bool isAdmin;
  final List<String> adminIds;

  const LeaveJoinTeamBtn(this.team, this.isAdmin, this.adminIds);

  @override
  Widget build(BuildContext context) {
    String buttonText = "Leave Team";
    String token = Provider.of<UserInfoModel>(context, listen: false).token;
    return SolidButton(
        text: buttonText,
        onPressed: () async {
          if (isAdmin && adminIds.length==1) {
            errorDialog(context, "Error", "You cannot leave the team if "
                "you are the only admin. You must promote someone else to admin "
                "before leaving.");
          } else {
            await leaveTeam(token);
            Provider.of<UserInfoModel>(context, listen: false).fetchUserInfo();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>
                  TeamsList()),
            );
          }
        },
        color: Theme
            .of(context)
            .colorScheme
            .secondary
    );
  }
}

class MemberListElement extends StatelessWidget {
  final Member mem;
  final bool isAdmin;
  final List<String> adminIds;

  const MemberListElement(this.mem, this.isAdmin, this.adminIds);

  @override
  Widget build(BuildContext context) {
    String id = mem.id;
    String emailStr = "(" + mem.email + ")";
    String nameStr = mem.name;
    bool isMemAdmin = adminIds.contains(id);

    // Show promotion dialog
    void promoteConfirm(String id) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String token = Provider.of<UserInfoModel>(context, listen: false).token;
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text("Confirmation", style: Theme.of(context).textTheme.headline1),
            content: Text("Are you sure you want to promote this member to an admin? You will no longer be an admin.", style: Theme.of(context).textTheme.bodyText2),
            actions: <Widget>[
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
                        Provider.of<UserInfoModel>(context, listen: false).fetchUserInfo();}
                  );
                },
              ),
            ],
          );
        },
      );
    }

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
                                    color: Theme.of(context).colorScheme.tertiary)
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
}

class TeamMembersList extends StatelessWidget {
  final Team team;
  final bool isAdmin;
  final List<String> adminIds;

  const TeamMembersList(this.team, this.isAdmin, this.adminIds);

  @override
  Widget build(BuildContext context) {
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
              children: team.members.map((mem) => MemberListElement(mem, isAdmin, adminIds)).toList()
          )
        ]
    );
  }
}

class TeamMail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            icon: const Icon(Icons.email, size: 30.0),
            color: Theme
                .of(context)
                .colorScheme
                .tertiary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    ViewInvites()),
              );
            }
        )
    );
  }
}

class TeamHeader extends StatelessWidget {
  final bool isAdmin;

  const TeamHeader(this.isAdmin);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("TEAM", style: Theme
                  .of(context)
                  .textTheme
                  .headline1),
              isAdmin ? TeamMail() : Container()
            ]
        )
    );
  }
}

class TeamDesc extends StatelessWidget {
  final Team team;

  const TeamDesc(this.team);

  @override
  Widget build(BuildContext context) {
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
}

class EditTeamButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  }
}

class OwnTeamView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Team team = Provider.of<UserInfoModel>(context).team;
    String id = Provider.of<UserInfoModel>(context).id;
    Status status = Provider.of<UserInfoModel>(context).userInfoStatus;
    List<String> adminIds = team.admins.map((mem) => mem.id).toList();
    bool isAdmin = adminIds.contains(id);

    return status == Status.loaded ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeamHeader(isAdmin),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: TeamDesc(team)
            ),
            isAdmin ? EditTeamButton() : Container(),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: TeamMembersList(team, isAdmin, adminIds)
            ),
            if (isAdmin && team.members.length < 4) InviteMembersBtn(team),
            const SizedBox(height: 10,),
            LeaveJoinTeamBtn(team, isAdmin, adminIds)
          ],
        )
      ],
    ) : const Center(child: Padding(
      child: CircularProgressIndicator(),
      padding: EdgeInsets.symmetric(vertical: 50),
    ));
  }
}

class BrowseTeamView extends StatelessWidget {
  final String teamId;
  
  const BrowseTeamView(this.teamId);
  
  @override
  Widget build(BuildContext context) {
    String token = Provider.of<UserInfoModel>(context, listen: false).token;
    
    return FutureBuilder(
      future: getTeamInfo(teamId, token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Team team = snapshot.data;
          String id = Provider.of<UserInfoModel>(context).id;
          List<String> adminIds = team.admins.map((mem) => mem.id).toList();
          bool isAdmin = adminIds.contains(id);
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TeamHeader(isAdmin),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TeamDesc(team)
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TeamMembersList(team, isAdmin, adminIds)
                  ),
                ],
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              child: Text("Could not load team data", style: Theme.of(context).textTheme.headline1,),
              padding: const EdgeInsets.symmetric(vertical: 50),
            ),
          );
        } else {
          return const Center(child: Padding(
            child: CircularProgressIndicator(),
            padding: EdgeInsets.symmetric(vertical: 50),
          ));
        }
      },
    );
  }
}

class ViewTeam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    String teamId = "";
    if (ModalRoute.of(context) != null) {
      teamId = ModalRoute
          .of(context)
          .settings
          .arguments as String;
    }

    return DefaultPage(
      backflag: teamId != "",
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
                      child: teamId == "" ? OwnTeamView() : BrowseTeamView(teamId)
                  )
              )
          )
    );
  }
}
