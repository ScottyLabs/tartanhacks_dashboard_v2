import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import 'create_team.dart';
import 'view_team.dart';

class TeamsList extends StatefulWidget {
  @override
  _TeamsListState createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList> {

  bool read = true;
  int numTeams = 2;

  List<Map> _teamList = [
    {'teamID': "617385d292fad800160f89b0", 'teamName': "firstteam"},
    {'teamID': "abcabc", 'teamName': "otherteam"},
  ];

  Widget _buildTeamHeader() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("TEAM", style: Theme.of(context).textTheme.headline2),
          mailIconSelect(true)
        ]
    );
  }

  Widget mailIconSelect(bool read){
    if (read){
      return Icon(
          Icons.email,
          color: Theme.of(context).colorScheme.secondary,
          size: 40.0
      );
    } else {
      return Icon(
          Icons.mark_email_unread,
          color: Theme.of(context).colorScheme.secondary,
          size: 40.0
      );
    }
  }

  Widget _buildCreateTeamBtn(){
    SolidButton btn = SolidButton(
      text : "Create New Team",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              CreateTeam()),
        );
      }
    );
    return btn;
  }

  Widget _buildListHeader(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("VIEW OPEN TEAMS", style: Theme.of(context).textTheme.bodyText2),
        Text("Filter", style: Theme.of(context).textTheme.caption),
      ],
    );
  }

  Widget _buildTeamJoinBtn(String teamID){
    SolidButton btn = SolidButton(
      text: "Join",
      onPressed: () {}
    );
    return btn;
  }

  Widget _buildTeamDetailsBtn(String teamID){
    SolidButton btn = SolidButton(
        text: "View Details",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ViewTeam()),
          );
        }
    );
    return btn;
  }

  Widget _buildTeamEntry(String teamID, String teamName){
    Row btnRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTeamJoinBtn(teamID),
        _buildTeamDetailsBtn(teamID)
      ],
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(teamName, style: Theme.of(context).textTheme.headline4),
        btnRow
      ],
    );
  }

  Widget _buildTeamsList(){
    List<Widget> teamWidgetList = <Widget>[];
    for(int i = 0; i < numTeams; i++){
      teamWidgetList.add(_buildTeamEntry(_teamList[i]['teamID'],_teamList[i]['teamName']));
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: teamWidgetList
    );
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

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
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                              //height: screenHeight*0.05,
                                              child: _buildTeamHeader()
                                          ),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                              //height: screenHeight*0.2,
                                              child: _buildCreateTeamBtn()
                                          ),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                              //height: screenHeight*0.2,
                                              child: _buildListHeader()
                                          ),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                              //height: screenHeight*0.2,
                                              child: _buildTeamsList()
                                          )
                                        ]
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