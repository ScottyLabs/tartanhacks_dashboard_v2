import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../custom_widgets.dart';
import 'index.dart';

class NewEventScreen extends StatefulWidget {
  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {

  String _eventName = "";
  String _eventDesc = "";
  String _eventUrl = "";
  String _duration = "";
  String _date = "";
  bool isPresenting = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    nameController.dispose();
    descController.dispose();
    linkController.dispose();
    durationController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Widget _buildName() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Even Name"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: nameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Project name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _eventName = value;
      },
    );
  }


  Widget _buildDesc() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Event Description"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: descController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Project description is required';
        }

        return null;
      },
      onSaved: (String value) {
        _eventDesc = value;
      },
    );
  }

  Widget _buildEventURL() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Event Link"),
      style: Theme.of(context).textTheme.bodyText2,
      keyboardType: TextInputType.url,
      controller: linkController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'URL is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _eventUrl = value;
      },
    );
  }

  Widget _buildDuration() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Duration"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: durationController,
      keyboardType: TextInputType.url,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Duration is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _duration = value;
      },
    );
  }

  Widget _buildDate() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Date"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: dateController,
      keyboardType: TextInputType.url,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Date is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _date = value;
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
                                                Text("Create New Event", style: Theme.of(context).textTheme.headline2),
                                                SizedBox(height:8),
                                                _buildName(),
                                                SizedBox(height:8),
                                                _buildDesc(),
                                                SizedBox(height:8),
                                                _buildEventURL(),
                                                SizedBox(height:8),
                                                _buildDuration(),
                                                SizedBox(height:8),
                                                _buildDate(),
                                                SolidButton(
                                                    text: "Save Event"
                                                ),
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