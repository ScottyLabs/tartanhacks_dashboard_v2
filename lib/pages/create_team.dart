import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import '../api.dart';
import 'team-api.dart';
import 'view_team.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/team.dart';
class CreateTeam extends StatefulWidget {
  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {

  String _yourName = "";
  String _teamName = "";
  String _teamDesc = "";
  TextEditingController yourNameController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();
  TextEditingController teamDescController = TextEditingController();
  TextEditingController inviteMemberController = TextEditingController();
  bool visibility = true;
  String buttonText = "Create Team";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String token;
  SharedPreferences prefs;
  Team team;
  String id;
  bool noTeam = true;
  void getData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    id = prefs.getString('id');
    team = await getUserTeam(token);
    print(team);
    if (team != null){ //if not on a team, redirects to the teams list page
      buttonText = "Edit Team";
      noTeam = false;
    }
    setState(() {
    });
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    yourNameController.dispose();
    teamNameController.dispose();
    teamDescController.dispose();
    inviteMemberController.dispose();
    super.dispose();
  }

  Widget _buildName() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Your Name"),
      style: TextStyle(color: Colors.black),
      controller: yourNameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Your name is required';
        }
        return null;
      },
      onChanged: (String value) {
        _yourName = value;
      },
    );
  }

  Widget _buildTeamName() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Team Name"),
      style: TextStyle(color: Colors.black),
      controller: teamNameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Your team name is required';
        }
        return null;
      },
      onChanged: (String value) {
        _teamName = value;
      },
    );
  }

  Widget _buildTeamDesc() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Team Description"),
      style: TextStyle(color: Colors.black),
      controller: teamDescController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Team description is required';
        }
        return null;
      },
      onChanged: (String value) {
        _teamDesc = value;
      },
    );
  }

  Widget _visible(){
    return Row(
      children: [
        Text("Team Visibility"), 
        Checkbox(
          activeColor: Theme.of(context).colorScheme.secondary,
          value: visibility,
          onChanged: (bool newValue) {
            setState(() {
                  visibility = newValue; 
            }); 
          },
        ),
      ]
    );
  }

  Widget _inviteMessage(){
    TextEditingController inviteController = TextEditingController();
    String email_invite;

    return AlertDialog(
                  title: Text('Send Invite'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: FormFieldStyle(context, "email"),
                        style: TextStyle(color: Colors.black),
                        controller: inviteController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'An email is required';
                          }
                          return null;
                          },
                          onSaved: (String value) {
                            email_invite = value;
                            },
                      ),
                      Container( 
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
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
                                print(email_invite);
                                await requestTeamMember(email_invite, token);
                              }
                            )
                          ]
                        )
                      )
                    ]
                  )
      );
  }

  Widget _inviteMem()  {
    return SolidButton(
        text: "INVITE NEW MEMBER", 
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => _inviteMessage()
          );
        }, 
        color: Theme.of(context).colorScheme.primary); 
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    if(prefs == null){
      return LoadingScreen();
    } else {
    return Scaffold(
        body: Container(
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
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: GradBox(
                                    width: screenWidth * 0.9,
                                    height: screenHeight * 0.75,
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
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
                                                _visible(),
                                                SizedBox(height:screenHeight*0.02),
                                                _inviteMem()
                                              ],
                                            ),
                                    Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        child: SolidButton(
                                          text: buttonText,
                                          onPressed: () async {
                                            print("try to create");
                                            print(_teamName);
                                            print(_teamDesc);
                                            print(visibility);
                                            print("reading");
                                            if (noTeam) {
                                              await createTeam(_teamName, _teamDesc, visibility, token);
                                            } else {
                                              await editTeam(_teamName, _teamDesc, visibility, token);
                                            };
                                            await promoteToAdmin(id, token);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ViewTeam())
                                            );
                                          },
                                          color: Theme.of(context).colorScheme.primary
                                        )
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
}
