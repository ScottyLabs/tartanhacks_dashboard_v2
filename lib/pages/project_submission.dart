import 'package:flutter/material.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/ErrorDialog.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/components/loading/LoadingOverlay.dart';
import 'package:thdapp/models/config.dart';
import 'package:thdapp/pages/project_success.dart';
import 'enter_prizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../models/team.dart';
import 'team_api.dart';
import 'table_submission.dart';

class ProjSubmit extends StatefulWidget {
  @override
  _ProjSubmitState createState() => _ProjSubmitState();
}

class ProjSubmitTextField extends StatelessWidget {
  final TextEditingController controller;
  final String fieldName;
  final bool isOptional;

  const ProjSubmitTextField(this.controller, this.fieldName,
      {this.isOptional = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: fieldName + (isOptional ? " (optional)" : ""),
          errorStyle: TextStyle(color: Theme.of(context).colorScheme.error)),
      style: Theme.of(context).textTheme.bodyMedium,
      controller: controller,
      validator: (value) {
        if (value != null && value.isEmpty && !isOptional) {
          return '$fieldName is required';
        }
        return null;
      },
    );
  }
}

class _ProjSubmitState extends State<ProjSubmit> {
  OverlayEntry? loading;
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

  ExpoConfig? expoConfig;
  bool canSubmitTable = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String id = "";
  String token = "";
  String projId = "";
  List prizes = [];
  Team? team;

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = prefs.getString('id') ?? "";
    token = prefs.getString('token') ?? "";

    team = await getUserTeam(token);

    Project? proj = await getProject(id, token);

    try {
      loading?.remove();
    } catch (e) {
      print("How do I check null?? $e");
    }

    if (proj != null && proj.tableNumber != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectSuccess(project: proj),
          ),
        );
      });

      return;
    }

    if (proj != null && proj.submitted == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TableSubmission(
              project: proj,
              isSubmitted: true,
            ),
          ),
        );
      });

      return;
    }

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

    setState(() {});
  }

  @override
  initState() {
    super.initState();
    _loadExpoConfig();
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loading = loadingOverlay(context);
      setState(() {});
      Overlay.of(context).insert(loading!);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    githubController.dispose();
    slidesController.dispose();
    videoController.dispose();
    super.dispose();
  }

  Future<void> _loadExpoConfig() async {
    try {
      expoConfig = await getExpoConfig(token);
      setState(() {
        canSubmitTable = DateTime.now().isBefore(expoConfig!.expoStartTime);
      });
    } catch (e) {
      print('Failed to load expo config: $e');
    }
  }

  void saveProjectDialog(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState?.save();

    Future proj = hasProj
        ? saveProject(
            context,
            nameController.text,
            descController.text,
            slidesController.text,
            videoController.text,
            githubController.text,
            isPresenting,
            projId,
            token,
          )
        : newProject(
            context,
            nameController.text,
            descController.text,
            team?.teamID ?? "",
            slidesController.text,
            videoController.text,
            githubController.text,
            isPresenting,
            projId,
            token,
          );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Remove barrierDismissible: false
        return FutureBuilder(
          future: proj,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              getData();
              Navigator.pop(context); // Close the dialog
              return Container();
            } else if (snapshot.hasError) {
              return AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text("Error",
                    style: Theme.of(context).textTheme.displayLarge),
                content: Text("Failed to save project. Please try again.",
                    style: Theme.of(context).textTheme.bodyMedium),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK",
                        style: Theme.of(context).textTheme.headlineMedium),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
            return AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text("Saving...",
                  style: Theme.of(context).textTheme.displayLarge),
              content: Container(
                  alignment: Alignment.center,
                  height: 70,
                  child: const CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }

  void submitProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Confirm Project Submission",
              style: Theme.of(context).textTheme.displayLarge),
          content: Text(
              "Are you sure you want to submit your project? Ensure you have"
              " selected all prize tracks you want to enter. Once submitted:\n\n"
                  "• You must enter your table number\n"
                  "• You cannot modify your project details\n"
                  "• This action cannot be undone",
              style: Theme.of(context).textTheme.bodyMedium),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel",
                  style: Theme.of(context).textTheme.headlineMedium),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.red,
                      )),
              onPressed: () {
                Navigator.of(context).pop();
                _submitProject(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _submitProject(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: FutureBuilder(
            future: submitProject(projId, token),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Text("Submitting Project...",
                      style: Theme.of(context).textTheme.displayLarge),
                  content: Container(
                    alignment: Alignment.center,
                    height: 70,
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Text("Error",
                      style: Theme.of(context).textTheme.displayLarge),
                  content: Text("Failed to submit project: ${snapshot.error}",
                      style: Theme.of(context).textTheme.bodyMedium),
                  actions: <Widget>[
                    TextButton(
                      child: Text("OK",
                          style: Theme.of(context).textTheme.headlineMedium),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TableSubmission(
                      project: Project(
                        id: projId,
                        name: nameController.text,
                        desc: descController.text,
                        event: "",
                        url: githubController.text,
                        slides: slidesController.text,
                        video: videoController.text,
                        team: team?.teamID ?? "",
                        prizes: prizes,
                        presentingVirtually: isPresenting,
                        tableNumber: null,
                      ),
                      isSubmitted: true,
                    ),
                  ),
                );
              });
              return Container();
            },
          ),
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
        child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: GradBox(
                alignment: Alignment.topCenter,
                width: screenWidth * 0.9,
                height: screenHeight * 0.75,
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("PROJECT SUBMISSION",
                            style: Theme.of(context).textTheme.displayMedium),
                        const SizedBox(height: 16),
                        ProjSubmitTextField(nameController, "Project Name"),
                        const SizedBox(height: 8),
                        ProjSubmitTextField(
                            descController, "Project Description"),
                        const SizedBox(height: 8),
                        ProjSubmitTextField(
                            githubController, "GitHub Repository URL"),
                        const SizedBox(height: 8),
                        ProjSubmitTextField(
                            slidesController, "Presentation Slides URL"),
                        const SizedBox(height: 8),
                        ProjSubmitTextField(videoController, "Video URL",
                            isOptional: true),
                        const SizedBox(height: 8),
                        const SizedBox(height: 8),
                        SolidButton(
                          text: "Save",
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            _formKey.currentState?.save();

                            saveProjectDialog(context);
                          },
                        ),
                        SolidButton(
                          text: "Select Prize Tracks",
                          onPressed: () {
                            if (hasProj) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnterPrizes(
                                          projId: projId,
                                          enteredPrizes: prizes,
                                        )),
                              );
                            } else {
                              errorDialog(context, "Error",
                                  "You do not have a project to enter! "
                                  "Please save your project first.");
                            }
                          },
                        ),
                        if (hasProj)
                          SolidButton(
                            text: "Submit Project",
                            onPressed: () => submitProjectDialog(context),
                          ),
                      ],
                    ))))));
  }
}
