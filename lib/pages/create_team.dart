import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class CreateTeam extends StatefulWidget {
  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {

  String _yourName = "";
  String _teamName = "";
  String _teamDesc = "";
  String _inviteMember = ""; //what exactly here???
  TextEditingController yourNameController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();
  TextEditingController teamDescController = TextEditingController();
  TextEditingController inviteMemberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  String token;
  SharedPreferences prefs;
  Team team;

  void getData() async{
    checkCredentials('test@example.com', 'string');
    //test@example.com, test1, test2, test3, team1
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    token = prefs.getString('token');
    });
  }

  void create_team() async {
    createTeam(_teamName, _teamDesc, true, token);
    //loop through members and invite with inviteTeamMember

  }
  
  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  void dispose(){
    yourNameController.dispose();
    teamNameController.dispose();
    teamDescController.dispose();
    inviteMemberController.dispose();
    super.dispose();
  }

  Widget _buildName() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Your Name"),
      style: Theme.of(context).textTheme.bodyText1,
      controller: yourNameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Your name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _yourName = value;
      },
    );
  }

  Widget _buildTeamName() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Team Name"),
      style: Theme.of(context).textTheme.bodyText1,
      controller: teamNameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Your team name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _teamName = value;
      },
    );
  }

  Widget _buildTeamDesc() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Team Description"),
      style: Theme.of(context).textTheme.bodyText1,
      controller: teamDescController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Team description is required';
        }
        return null;
      },
      onSaved: (String value) {
        _teamDesc = value;
      },
    );
  }

  Widget _buildInviteMember() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Invite Member"),
      style: Theme.of(context).textTheme.bodyText1,
      keyboardType: TextInputType.url,
      controller: inviteMemberController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'You need to invite a member';
        }
        return null;
      },
      onSaved: (String value) {
        _inviteMember = value;
      },
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
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          child: Text("CREATE NEW TEAM", style: 
                                          Theme.of(context).textTheme.headline1),
                                        ),
                                        Form(
                                          key: _formKey,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Basic Info", style: 
                                          Theme.of(context).textTheme.headline4),
                                                SizedBox(height:screenHeight*0.02),
                                                _buildName(),
                                                SizedBox(height:screenHeight*0.02),
                                                _buildTeamName(),
                                                SizedBox(height:screenHeight*0.02),
                                                _buildTeamDesc(),
                                                SizedBox(height:screenHeight*0.02),
                                                _buildInviteMember(),
                                                
                                              ],
                                            )
                                          )
                                        ),
                                        SolidButton(
                                          text: "Create Team",
                                          color: Theme.of(context).colorScheme.secondary,
                                          onPressed: create_team()
                                          ),
                                        ]
                                      ),
                                     
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