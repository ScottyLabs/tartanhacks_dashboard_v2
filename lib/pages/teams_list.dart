import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/ErrorDialog.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/components/loading/ListRefreshable.dart';
import '../components/loading/LoadingOverlay.dart';
import '../providers/user_info_provider.dart';
import 'create_team.dart';
import 'view_team.dart';

import '/models/team.dart';
import 'team_api.dart';
import 'see_invites.dart';

class TeamCreateBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SolidButton(
      text: "Create New Team",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateTeam()),
        );
      },
    );
  }
}

class TeamDetailsBtn extends StatelessWidget {
  final Team team;

  const TeamDetailsBtn(this.team);

  @override
  Widget build(BuildContext context) {
    return SolidButton(
      text: "Details",
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewTeam(),
            settings: RouteSettings(arguments: team.teamID))),
    );
  }
}


class TeamJoinBtn extends StatelessWidget {
  final bool hasReqested;
  final Function onJoinPressed;

  const TeamJoinBtn(this.hasReqested, this.onJoinPressed);

  @override
  Widget build(BuildContext context) {
    if (hasReqested) {
      return SolidButton(
        text: "Pending",
        color: Colors.grey,
        textColor: Colors.white,
        onPressed: null,
      );
    } else {
      return SolidButton(
        text: "Ask to Join",
        onPressed: onJoinPressed,
      );
    }
  }
}

class TeamEntryCard extends StatelessWidget {
  final Team team;
  final bool hasRequested;
  final Function onJoinPressed;

  const TeamEntryCard(this.team, this.hasRequested, this.onJoinPressed);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(team.name, style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TeamJoinBtn(hasRequested, onJoinPressed),
                TeamDetailsBtn(team)
              ],
            )
          ],
        )
      ),
    );
  }
}

class TeamHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("TEAM", style: Theme.of(context).textTheme.headline2),
        IconButton(
            icon: const Icon(Icons.email, size: 30.0),
            color: Theme.of(context).colorScheme.tertiary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewInvites()),
              );
            })
      ],
    );
  }
}

class TeamsList extends StatefulWidget {
  @override
  _TeamsListState createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList> {
  List<Team> teams = [];
  Set<String> requestedTeams = {};
  Status fetchStatus = Status.notLoaded;
  TextEditingController searchController = TextEditingController();

  void search() async {
    fetchStatus = Status.notLoaded;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    if (searchController.text != "") {
      teams = await teamSearch(token, searchController.text);
    } else {
      teams = await getTeams(token);
    }

    fetchStatus = Status.loaded;
    setState(() { });

  }
  @override
  initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    String token = Provider.of<UserInfoModel>(context, listen: false).token;
    teams = await getTeams(token);
    if (teams == null) {
      errorDialog(context, 'Error',
          'We ran into an error while getting your team information. If the issue persists please contact a TartanHacks organizer.');
      fetchStatus = Status.error;
      return;
    }
    teams = teams.where((e) => e.visible).toList();
    teams.sort((a, b) => a.name.compareTo(b.name));
    List requestsList = await getUserMail(token);
    requestedTeams = requestsList?.map((e) => e['team']['_id'].toString())?.toSet() ?? {};
    fetchStatus = Status.loaded;
    setState(() {});

    // Reload user's team and redirect to ViewTeam page if user has a team
    await Provider.of<UserInfoModel>(context, listen: false).fetchUserInfo();
    bool hasTeam = Provider.of<UserInfoModel>(context, listen: false).hasTeam;
    if (hasTeam) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>
          ViewTeam(),
          settings: const RouteSettings(
            arguments: ""
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return DefaultPage(
        reverse: true,
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: RefreshIndicator(
              onRefresh: fetchData,
              child: GradBox(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.75,
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: TeamHeader()),
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: TeamCreateBtn()),
                        Row(children: [
                          Expanded(
                            child: TextField(
                              style:
                              Theme.of(context).textTheme.bodyText2,
                              enableSuggestions: false,
                              controller: searchController,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (value) {
                                search(); //searches when ENTER pressed
                              },
                            ),
                          ),
                          const SizedBox(
                              width: 10
                          ),
                          SolidButton(
                              onPressed: search,
                              child: Icon(Icons.subdirectory_arrow_left,
                                  size: 30,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary)),
                        ]),
                        const SizedBox(
                            height: 20
                        ),
                        if (fetchStatus == Status.error)
                          ListRefreshable(child: const Center(
                              child: Text("Error loading teams")
                          ),)
                        else if (fetchStatus == Status.loaded && teams.isEmpty)
                          ListRefreshable(child: const Center(
                              child: Text("No teams available")
                            ))
                        else if (fetchStatus == Status.loaded)
                          Expanded(
                            child: ListView.builder(
                              itemCount: teams.length,
                              itemBuilder: (context, index) {
                                Team team = teams[index];
                                String teamID = team.teamID;
                                bool hasReqested = requestedTeams.contains(teamID);
                                return TeamEntryCard(
                                    teams[index],
                                    hasReqested,
                                    () async {
                                      OverlayEntry loading = LoadingOverlay(context);
                                      Overlay.of(context).insert(loading);
                                      String token = Provider.of<UserInfoModel>(context, listen: false).token;
                                      bool success = await requestTeam(teamID, token);
                                      loading.remove();
                                      if (success) {
                                        errorDialog(context, "Success", "A join request was sent to this team");
                                        requestedTeams.add(teamID);
                                        setState(() {});
                                      } else {
                                        errorDialog(context, "Error", "An error occurred with joining this team. Please try again.");
                                      }
                                    }
                                );
                              },
                            ),
                          )
                        else
                          Center(
                              child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.onSurface)
                          )
                      ])),
            )));
  }
}
