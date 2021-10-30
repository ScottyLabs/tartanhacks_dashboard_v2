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
  int numTeams = 10;

  List<Map> _teamList = <Map>[];
  List<Widget> teamWidgetList = <Widget>[];

  void _populateTeamList(){
    for(int i = 0; i < 10; i++){
      String teamName = "Team " + i.toString();
      _teamList.add({'teamID': "617385d292fad800160f89b0", 'teamName': teamName});
    }
  }

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
      text: " Join ",
      onPressed: () {}
    );
    return btn;
  }

  Widget _buildTeamDetailsBtn(String teamID){
    SolidButton btn = SolidButton(
        text: " View Details ",
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

  Widget _buildTeamEntry(int index){
    String teamID = _teamList[index]['teamID'];
    String teamName = _teamList[index]['teamName'];
    Row btnRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTeamJoinBtn(teamID),
        _buildTeamDetailsBtn(teamID)
      ],
    );
    return Card(
        margin: const EdgeInsets.all(12),
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
          )
      )
    );
  }

  void _buildTeamsList(){
    for(int i = 0; i < numTeams; i++){
      teamWidgetList.add(_buildTeamEntry(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    _populateTeamList();
    _buildTeamsList();

    return Scaffold(
        body:  Container(
            child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
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
                                        mainAxisAlignment: MainAxisAlignment.start,
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
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: 10,
                                              itemBuilder: (BuildContext context, int index){
                                                return teamWidgetList[index];
                                              },
                                            ),
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