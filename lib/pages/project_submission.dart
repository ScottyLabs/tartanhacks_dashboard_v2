import 'package:flutter/material.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/ErrorDialog.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'enter_prizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../models/team.dart';
import 'team_api.dart';

class ProjSubmit extends StatefulWidget {
  @override
  _ProjSubmitState createState() => _ProjSubmitState();
}

class ProjSubmitTextField extends StatelessWidget {
  final TextEditingController controller;
  final String fieldName;
  final bool isOptional;

  const ProjSubmitTextField(this.controller, this.fieldName, {this.isOptional = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: fieldName + (isOptional ? " (optional)" : ""),
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error)
      ),
      style: Theme.of(context).textTheme.bodyText2,
      controller: controller,
      validator: (String value) {
        if (value.isEmpty && !isOptional) {
          return '$fieldName is required';
        }
        return null;
      },
    );
  }


}

class _ProjSubmitState extends State<ProjSubmit> {

  bool hasProj = false;
  String _projName = "";
  String _projDesc = "";
  String _githubUrl = "";
  String _presUrl = "";
  String _vidUrl = "";
  bool isPresenting = true;
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
                      Navigator.pop(context);
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

    return DefaultPage(
      reverse: true,
      child:
        Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: GradBox(
              alignment: Alignment.topCenter,
              width: screenWidth*0.9,
              height: screenHeight*0.75,
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("PROJECT SUBMISSION", style: Theme.of(context).textTheme.headline2),
                        const SizedBox(height:16),
                        ProjSubmitTextField(nameController, "Project Name"),
                        const SizedBox(height:8),
                        ProjSubmitTextField(descController, "Project Description"),
                        const SizedBox(height:8),
                        ProjSubmitTextField(githubController, "GitHub Repository URL"),
                        const SizedBox(height:8),
                        ProjSubmitTextField(slidesController, "Presentation Slides URL"),
                        const SizedBox(height:8),
                        ProjSubmitTextField(videoController, "Video URL", isOptional: true),
                        const SizedBox(height:8),
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
    );
  }
}