import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../custom_widgets.dart';
import 'package:thdapp/api.dart';
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
  String _location = "";
  String _platform = "";
  double _lat = 0;
  double _lng = 0;
  int _startTime = 0;
  int _endTime = 0;
  String _date = "";
  bool isPresenting = false;
  
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  var dropdownValue = 'In Person';
  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    nameController.dispose();
    descController.dispose();
    linkController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void saveData() async {
    bool result;
    result = await addEvent(nameController.text, descController.text, this._startTime, this._endTime, this._lat, this._lng, this._platform, linkController.text);

    if (result == true) {
      _showDialog('Your event was successfully saved!', 'Success', result);
    }else{
      _showDialog('There was an error. Please try again.', 'Error.', result);
    }
  }

  void _showDialog(String response, String title, bool result) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(response),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "OK",
                style: new TextStyle(color: Colors.white),
              ),
              color: new Color.fromARGB(255, 255, 75, 43),
              onPressed: () {

                Navigator.of(context).pop();
                if(result == true){
                  Navigator.pop(context);

                }
              },
            ),
          ],
        );
      },
    );
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