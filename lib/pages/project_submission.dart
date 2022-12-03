import 'package:flutter/material.dart';
import 'package:thdapp/api.dart';
import 'custom_widgets.dart';
import 'enter_prizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../models/team.dart';
import 'team_api.dart';

class ProjSubmit extends StatefulWidget {
  @override
  _ProjSubmitState createState() => _ProjSubmitState();
}

class _ProjSubmitState extends State<ProjSubmit> {

  bool hasProj = false;
  String _projName = "";
  String _projDesc = "";
  String _githubUrl = "";
  String _presUrl = "";
  String _vidUrl = "";
  bool isPresenting = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController githubController = TextEditingController();
  TextEditingController slidesController = TextEditingController();
  TextEditingController videoController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String id;
  String token;
  String projId;
  List prizes = [];
  Team team;

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = prefs.getString('id');
    token = prefs.getString('token');

    team = await getUserTeam(token);

    Project proj = await getProject(id, token);
    if (proj != null) {
      hasProj = true;
      projId = proj.id;
      _projName = proj.name;
      _projDesc = proj.desc;
      _githubUrl = proj.url;
      _presUrl = proj.slides;
      _vidUrl = proj.video;
      isPresenting = proj.presentingVirtually;
      prizes = proj.prizes;

      nameController.text = _projName;
      descController.text = _projDesc;
      slidesController.text = _presUrl;
      videoController.text = _vidUrl;
      githubController.text = _githubUrl;
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
  void dispose(){
    nameController.dispose();
    descController.dispose();
    githubController.dispose();
    slidesController.dispose();
    videoController.dispose();
    super.dispose();
  }

  Widget _buildName() {
    return TextFormField(
      decoration: formFieldStyle(context, "Project Name"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: nameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Project name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _projName = value;
      },
    );
  }


  Widget _buildDesc() {
    return TextFormField(
      decoration: formFieldStyle(context, "Project Description"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: descController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Project description is required';
        }

        return null;
      },
      onSaved: (String value) {
        _projDesc = value;
      },
    );
  }

  Widget _buildGitHubURL() {
    return TextFormField(
      decoration: formFieldStyle(context, "Github Repository URL"),
      style: Theme.of(context).textTheme.bodyText2,
      keyboardType: TextInputType.url,
      controller: githubController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'URL is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _githubUrl = value;
      },
    );
  }

  Widget _buildPresURL() {
    return TextFormField(
      decoration: formFieldStyle(context, "Presentation URL"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: slidesController,
      keyboardType: TextInputType.url,
      validator: (String value) {
        if (value.isEmpty) {
          return 'URL is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _presUrl = value;
      },
    );
  }

  Widget _buildVidURL() {
    return TextFormField(
      decoration: formFieldStyle(context, "Video URL"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: videoController,
      keyboardType: TextInputType.url,
      validator: (String value) {
        if (!isPresenting && value.isEmpty) {
          return 'Video is required if not presenting live.';
        }
        return null;
      },
      onSaved: (String value) {
        _vidUrl = value;
      },
    );
  }

  Widget _buildPresentingLive() {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
            children: <Widget>[
              const SizedBox(width: 20,),
              Text('Presenting',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline4),
              Text('Do you wish to present live at the expo? If not, you must submit a video.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2),
              Switch(
                activeColor: Theme.of(context).colorScheme.secondary,
                activeTrackColor: Theme.of(context).colorScheme.onSurface,
                inactiveTrackColor: Theme.of(context).colorScheme.surface,
                value: isPresenting,
                onChanged: (value) {
                  setState(() {
                    isPresenting = value;
                  });
                }
              )
            ]
        )
    );
  }

  void submitDialog (BuildContext context) {
    Future proj;

    if(team == null){
      errorDialog(context, "Error", "You are not in a team!");
      return;
    } else if (projId != null){
      proj = editProject(context, nameController.text, descController.text, slidesController.text, videoController.text, githubController.text, isPresenting, projId, token);
    } else {
      proj = newProject(context, nameController.text, descController.text, team.teamID, slidesController.text, videoController.text, githubController.text, isPresenting, projId, token);
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: proj,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text("Success", style: Theme.of(context).textTheme.headline1),
                content: Text("Project info was saved.", style: Theme.of(context).textTheme.bodyText2),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "OK",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProjSubmit()));
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text("Error", style: Theme.of(context).textTheme.headline1),
                content: Text("Project info failed to save. Please try again.", style: Theme.of(context).textTheme.bodyText2),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "OK",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
            return AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text("Processing...", style: Theme.of(context).textTheme.headline1),
              content: Container(
                  alignment: Alignment.center,
                  height: 70,
                  child: const CircularProgressIndicator()
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
        body:  SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight
            ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const TopBar(),
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
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: GradBox(
                            width: screenWidth*0.9,
                            height: screenHeight*0.75,
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("PROJECT SUBMISSION", style: Theme.of(context).textTheme.headline2),
                                      const SizedBox(height:8),
                                      _buildName(),
                                      const SizedBox(height:8),
                                      _buildDesc(),
                                      const SizedBox(height:8),
                                      _buildGitHubURL(),
                                      const SizedBox(height:8),
                                      _buildPresURL(),
                                      const SizedBox(height:8),
                                      _buildVidURL(),
                                      const SizedBox(height:8),
                                      _buildPresentingLive(),
                                      SolidButton(
                                          text: "Save",
                                          onPressed: () {
                                            if (!_formKey.currentState.validate()) {
                                              return;
                                            }

                                            _formKey.currentState.save();

                                            submitDialog(context);
                                          },
                                      ),
                                      SolidButton(
                                          text: "Submit for Prizes",
                                          onPressed: () {
                                            if (hasProj) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>
                                                    EnterPrizes(projId: projId, enteredPrizes: prizes,)),
                                              );
                                            } else {
                                              errorDialog(context, "Error", "You do not have a project to enter!");
                                            }
                                          },
                                      )
                                    ],
                                  )
                                )
                            )
                          )
                      )
                    ],
                  )
                ],
              )
          )
        )
    );
  }
}