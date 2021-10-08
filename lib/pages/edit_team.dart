import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class EditTeam extends StatefulWidget {
  @override
  _EditTeamState createState() => _EditTeamState();
}

class _EditTeamState extends State<EditTeam> {

  List<Map> _teamMembers = [{'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"},
                          {'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"},
                          {'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"}];
  String _teamName = "My Team";
  String _teamDesc = "my team description";
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  Widget _buildTeamHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Team", style: Theme.of(context).textTheme.headline2),
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            //child: Image.assert(image: AssetImage("lib/logos/defaultpfp.PNG", fit: BoxFit.fitHeight))
            child: Image.asset("lib/logos/defaultpfp.PNG", height: 20))
      ]
    );
      /*
    return Container(
      Text("Team", style: Theme.of(context).textTheme.headline4),
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child:
          Image(image: AssetImage("lib/logos/defaultpfp.PNG"),)
      ),
    );*/
  }

  Widget _buildTeamDesc() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_teamName, style: Theme.of(context).textTheme.headline4),
        Text(_teamDesc, style: Theme.of(context).textTheme.bodyText2)
      ]
    );
  }

  Widget _buildMember(int member) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_teamMembers[member]['name'], style: Theme.of(context).textTheme.bodyText2),
        Text(_teamMembers[member]['email'], style: Theme.of(context).textTheme.bodyText2)
      ]
    );
  }

  Widget _buildTeamMembers() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Team Members", style: Theme.of(context).textTheme.headline4),
        Column(
          children: [_buildMember(0),
          _buildMember(1),
          _buildMember(2)]
        )
      ]
    );
  }

  Widget _leaveTeamBtn() {
    return (
      SolidButton(
        text: "Leave Team"
      )
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    _buildTeamHeader(),
                                    _buildTeamDesc(),
                                    SolidButton(
                                          text: "EDIT TEAM NAME AND INFO"
                                    ),
                                    
                                    _buildTeamMembers(),
                                    SolidButton(
                                          text: "INVITE NEW MEMBER"
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        height: screenHeight*0.1,
                                        child: _leaveTeamBtn()
                                        
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