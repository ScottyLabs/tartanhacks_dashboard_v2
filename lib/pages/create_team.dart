import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import '../api.dart';
import 'team-api.dart';
import 'view_team.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String token;
  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    String id = prefs.getString('id');
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
      style: Theme
          .of(context)
          .textTheme
          .bodyText1,
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
      style: Theme
          .of(context)
          .textTheme
          .bodyText1,
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
      style: Theme
          .of(context)
          .textTheme
          .bodyText1,
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
                        child: SolidButton(
                          text: "Send",
                          onPressed: () async {
                            await requestTeamMember(email_invite, token);
                          }
                        )
                      )
                    ]
                  )
      );
  }

  Widget _buildInviteMember() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Invite Member"),
      style: Theme
          .of(context)
          .textTheme
          .bodyText1,
      keyboardType: TextInputType.url,
      controller: inviteMemberController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'You need to invite a member';
        }
        return null;
      },
      onSaved: (String value) {
        // _inviteMember = value;
      },
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
                                                _inviteMem()
                                                //_buildInviteMember(),
                                              ],
                                            ),
                                    Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        child: SolidButton(
                                          text: "Create Team",
                                          onPressed: () {
                                            createTeam(_teamName, _teamDesc, token);
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
