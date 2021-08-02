import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import 'enter_prizes.dart';

class ProjSubmit extends StatefulWidget {
  @override
  _ProjSubmitState createState() => _ProjSubmitState();
}

class _ProjSubmitState extends State<ProjSubmit> {

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
      decoration: FormFieldStyle(context, "Project Name"),
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
      decoration: FormFieldStyle(context, "Project Description"),
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
      decoration: FormFieldStyle(context, "Github Repository URL"),
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
      decoration: FormFieldStyle(context, "Presentation URL"),
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
      decoration: FormFieldStyle(context, "Video URL"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: videoController,
      keyboardType: TextInputType.url,
      validator: (String value) {
        if (value.isEmpty) {
          return 'URL is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _vidUrl = value;
      },
    );
  }

  Widget _buildPresentingLive() {
    int initialVal = 1;
    if (isPresenting) initialVal = 0;
    return Container(
        padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
            children: <Widget>[
              SizedBox(width: 20,),
              Text('Presenting',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline4),
              Text('Do you wish to present live at the expo? If not, you must submit a video.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2),
              Switch(
                activeColor: Theme.of(context).colorScheme.secondary,
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(context).colorScheme.onSurface,
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
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                              child: Form(
                                  key: _formKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("PROJECT SUBMISSION", style: Theme.of(context).textTheme.headline2),
                                        SizedBox(height:8),
                                        _buildName(),
                                        SizedBox(height:8),
                                        _buildDesc(),
                                        SizedBox(height:8),
                                        _buildGitHubURL(),
                                        SizedBox(height:8),
                                        _buildPresURL(),
                                        SizedBox(height:8),
                                        _buildVidURL(),
                                        SizedBox(height:8),
                                        _buildPresentingLive(),
                                        SolidButton(
                                            text: "Save"
                                        ),
                                        SolidButton(
                                            text: "Submit for Prizes",
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>
                                                    EnterPrizes()),
                                              );
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
        )
    );
  }
}