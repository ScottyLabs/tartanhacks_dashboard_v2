import 'package:flutter/material.dart';
import 'package:thdapp/components/background_shapes/CurvedTop.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/components/topbar/TopBar.dart';
import 'custom_widgets.dart';
import 'create_team.dart';
import 'view_team.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '/models/team.dart';
import 'team_api.dart';
import 'see_invites.dart';

class TeamsList extends StatefulWidget {
  @override
  _TeamsListState createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList> {
  String token;
  List<Team> teamInfos;
  int numTeams;
  final List<Map> _teamList = <Map>[];
  List<Widget> teamWidgetList = <Widget>[];
  List<dynamic> requestsList;
  List requestedTeams = [];

  @override
  initState() {
    super.initState();
    getData();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    teamInfos = await getTeams(token);
    if (teamInfos == null) {
      errorDialog(context, 'Error',
          'We ran into an error while getting your team information. If the issue persists please contact a TartanHacks organizer.');
    }
    numTeams = teamInfos.length;
    _populateTeamList();
    _buildTeamsList();
    requestsList = await getUserMail(token);
    requestedTeams = [];
    for (var r in requestsList) {
      if (r['type'] == "JOIN") {
        requestedTeams.add(r['team']['_id']);
      }
    }
    setState(() {});
  }

  bool read = true;

  void _populateTeamList() {
    for (int i = 0; i < teamInfos.length; i++) {
      if (teamInfos[i].visible) {
        _teamList.add(
            {'teamID': teamInfos[i].teamID, 'teamName': teamInfos[i].name});
      }
    }
  }

  Widget _buildTeamHeader() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text("TEAM", style: Theme.of(context).textTheme.headline2),
      IconButton(
          icon: const Icon(Icons.email, size: 30.0),
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewInvites()),
            ).then((value) => getData());
          })
    ]);
  }

  Widget mailIconSelect(bool read) {
    if (read) {
      return Icon(Icons.email,
          color: Theme.of(context).colorScheme.secondary, size: 40.0);
    } else {
      return Icon(Icons.mark_email_unread,
          color: Theme.of(context).colorScheme.secondary, size: 40.0);
    }
  }

  Widget _buildCreateTeamBtn() {
    SolidButton btn = SolidButton(
        text: "Create New Team",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTeam()),
          );
        });
    return btn;
  }


  Widget _buildTeamJoinBtn(String teamID) {
    if (requestedTeams.contains(teamID)) {
      return SolidButton(
        text: "Awaiting response",
        color: Colors.grey,
        onPressed: null,
      );
    } else {
      return SolidButton(
          text: "Ask to join",
          onPressed: () async {
            bool success = await requestTeam(teamID, token);
            if (success) {
              errorDialog(
                  context, "Success", "A join request was sent to this team");
              requestedTeams.add(teamID);
              setState(() {});
            } else {
              errorDialog(context, "Error",
                  "An error occurred with joining this team. Please try again.");
            }
          });
    }
  }

  Widget _buildTeamDetailsBtn(String teamID) {
    SolidButton btn = SolidButton(
        text: "Details",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewTeam(),
                  settings: RouteSettings(
                    arguments: teamID,
                  )));
        });
    return btn;
  }

  Widget _buildTeamEntry(int index) {
    String teamID = _teamList[index]['teamID'];
    String teamName = _teamList[index]['teamName'];
    Row btnRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_buildTeamJoinBtn(teamID), _buildTeamDetailsBtn(teamID)],
    );
    return Card(
        margin: const EdgeInsets.all(4),
        color: Theme.of(context).colorScheme.background,
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teamName, style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 8),
                btnRow
              ],
            )));
  }

  void _buildTeamsList() {
    for (int i = 0; i < numTeams; i++) {
      teamWidgetList.add(_buildTeamEntry(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
        body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: screenHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const TopBar(),
                    Stack(
                      children: [
                        Column(children: [
                          SizedBox(height: screenHeight * 0.05),
                          CustomPaint(
                              size: Size(screenWidth, screenHeight * 0.75),
                              painter: CurvedTop(
                                  color1: Theme.of(context)
                                      .colorScheme
                                      .secondaryVariant,
                                  color2:
                                      Theme.of(context).colorScheme.primary,
                                  reverse: true)),
                        ]),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: GradBox(
                                width: screenWidth * 0.9,
                                height: screenHeight * 0.75,
                                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 10),
                                          //height: screenHeight*0.05,
                                          child: _buildTeamHeader()),
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 5),
                                          //height: screenHeight*0.2,
                                          child: _buildCreateTeamBtn()),

                                      if (teamInfos != null)
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: numTeams,
                                            itemBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return _buildTeamEntry(index);
                                            },
                                          ),
                                        )
                                      else
                                        Center(
                                            child:
                                                CircularProgressIndicator(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface))
                                    ])))
                      ],
                    )
                  ],
                ))));
  }
}
