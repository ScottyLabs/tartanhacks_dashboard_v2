import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/ErrorDialog.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/providers/user_info_provider.dart';

import 'team_api.dart';
import '/models/team.dart';
import '/models/member.dart';
import 'see_invites.dart';
import 'teams_list.dart';
import 'create_team.dart';

void showConfirmDialog(
    BuildContext context, String message, void Function()? onConfirm) {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text("Confirmation",
                style: Theme.of(context).textTheme.displayLarge),
            content:
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
            actions: [
              TextButton(
                child: Text(
                  "Cancel",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                onPressed: onConfirm,
                child: Text(
                  "OK",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ]);
      });
}

class InviteMembersBtn extends StatelessWidget {
  final Team team;

  const InviteMembersBtn(this.team);

  // Show invitation dialog
  Widget _inviteMessage(BuildContext context) {
    TextEditingController inviteController = TextEditingController();
    String emailInvite = "";

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text('Send Invite', style: Theme.of(context).textTheme.displayLarge),
      content: TextFormField(
        decoration: const InputDecoration(labelText: "email"),
        style: Theme.of(context).textTheme.bodyMedium,
        keyboardType: TextInputType.emailAddress,
        controller: inviteController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'An email is required';
          }
          throw Error();
        },
        onChanged: (String value) {
          emailInvite = value;
        },
      ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            "Send",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            String token =
                Provider.of<UserInfoModel>(context, listen: false).token;
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
              context: context, builder: (context) => _inviteMessage(context));
        },
        color: Theme.of(context).colorScheme.primary);
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
          // Can only leave if you are the last person on the team or not an admin
          bool canLeave = team.members.length == 1 || !isAdmin;
          if (!canLeave) {
            errorDialog(context, "Cannot Leave Team",
                "You must promote someone else to an admin before you leave the team");
            return;
          }

          showConfirmDialog(
              context,
              "Are you sure want to leave your team? Your team information may be "
              "lost if you are the only member left.", () async {
            bool success = await leaveTeam(token);
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Error leaving team."),
              ));
              return;
            }
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => TeamsList()),
                (route) => route.isFirst
            );
          });
        },
        color: Theme.of(context).colorScheme.tertiaryContainer);
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
    String emailStr = "(${mem.email})";
    String nameStr = mem.name;
    bool isMemAdmin = adminIds.contains(id);

    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: [
                    TextSpan(
                        text: nameStr,
                        style: Theme.of(context).textTheme.bodyMedium),
                    if (isMemAdmin)
                      WidgetSpan(
                          child: Icon(Icons.star,
                              size: 20,
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer))
                  ])),
                  Text(emailStr, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis,)
                ]),
          ),
          if (isAdmin && !isMemAdmin)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: SolidButton(
                text: "Promote",
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  showConfirmDialog(context,
                      "Are you sure you want to promote this member to an admin? You will no longer be an admin.",
                      () {
                    String token =
                        Provider.of<UserInfoModel>(context, listen: false).token;
                    promoteToAdmin(id, token).then((_) {
                      Navigator.of(context).pop();
                      Provider.of<UserInfoModel>(context, listen: false)
                          .fetchUserInfo();
                    });
                  });
                },
              ),
            )
        ]));
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
          Text("Team Members",
              style: Theme.of(context).textTheme.headlineMedium),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: team.members
                  .map((mem) => MemberListElement(mem, isAdmin, adminIds))
                  .toList())
        ]);
  }
}

class TeamMail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            icon: const Icon(Icons.email, size: 30.0),
            color: Theme.of(context).colorScheme.tertiaryContainer,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewInvites()),
              );
            }));
  }
}

class TeamHeader extends StatelessWidget {
  final bool isAdmin;

  const TeamHeader(this.isAdmin);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("TEAM", style: Theme.of(context).textTheme.displayLarge),
          isAdmin ? TeamMail() : Container()
        ]));
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
          Text(team.name ?? "",
              style: Theme.of(context).textTheme.headlineMedium),
          Text(team.description ?? "",
              style: Theme.of(context).textTheme.bodyMedium)
        ]);
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
            MaterialPageRoute(builder: (context) => CreateTeam()),
          );
        },
        color: Theme.of(context).colorScheme.primary);
  }
}

class OwnTeamView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Team? team = Provider.of<UserInfoModel>(context).team;
    String id = Provider.of<UserInfoModel>(context).id;
    Status status = Provider.of<UserInfoModel>(context).userInfoStatus;
    List<String>? adminIds = team?.admins.map((mem) => mem.id).toList();
    bool? isAdmin = adminIds?.contains(id);

    return status == Status.loaded
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TeamHeader(isAdmin!),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TeamDesc(team!)),
                  isAdmin ? EditTeamButton() : Container(),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TeamMembersList(team, isAdmin, adminIds!)),
                  if (isAdmin && team.members.length < 4)
                    InviteMembersBtn(team),
                  const SizedBox(
                    height: 10,
                  ),
                  LeaveJoinTeamBtn(team, isAdmin, adminIds)
                ],
              )
            ],
          )
        : const Center(
            child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: CircularProgressIndicator(),
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
          Team team = snapshot.data as Team; // TODO: this is sus please check.
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
                      child: TeamDesc(team)),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: TeamMembersList(team, isAdmin, adminIds)),
                ],
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                "Could not load team data",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          );
        } else {
          return const Center(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: CircularProgressIndicator(),
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
      teamId = ModalRoute.of(context)?.settings.arguments as String? ?? "";
    }

    return DefaultPage(
        backflag: teamId != "",
        reverse: true,
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: GradBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.75,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                    child: () {
                      if (teamId == "") {
                        return OwnTeamView();
                      } else {
                        return BrowseTeamView(teamId);
                      }
                    }()
                       ))));
  }
}
