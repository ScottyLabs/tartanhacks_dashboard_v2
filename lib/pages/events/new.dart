import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thdapp/models/old/event_model.dart';
import 'package:thdapp/V1/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_widgets.dart';
import 'package:date_time_picker/date_time_picker.dart';

class NewEventScreen extends StatefulWidget {

  final Event eventData;

  NewEventScreen(
      {Key key, this.eventData})
      : super(key: key);
  @override
  _NewEventScreenState createState() => new _NewEventScreenState(eventData: eventData);
}

class _NewEventScreenState extends State<NewEventScreen> {

  SharedPreferences prefs;

  Event eventData;

  _NewEventScreenState({Key key, this.eventData});

  bool isAdmin = false;
  var dropdownValue = 'Zoom';
  final idController = new TextEditingController();
  final eventNameController = new TextEditingController();
  final eventDescController = new TextEditingController();
  final gcalLinkController = new TextEditingController();
  final zoomLinkController = new TextEditingController();
  final zoomIDController = new TextEditingController();
  final zoomPasswordController = new TextEditingController();
  final durationController = new TextEditingController();


  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  String unixTime = '';
  int accessCode = 0;

  String appBarTitle = 'Create New Event';

  @override
  void initState() {
    super.initState();
    //getData();
  }


  void saveData() async {
    bool result;
    if(eventData == null){
      result = await addEvents(eventNameController.text, unixTime, eventDescController.text, "a", zoomLinkController.text, accessCode, "a", "a", durationController.text);
    }else{
      result = await editEvents(eventData.id, eventNameController.text, unixTime, eventDescController.text, "a", zoomLinkController.text, accessCode, "a", "a", durationController.text);
    }
    if (result == true) {
      _showDialog('Your event was successfully saved!', 'Success', result);
    }else{
      _showDialog('There was an error. Please try again.', 'Error.', result);
    }
  }

  void getDate (DateTime input){
    unixTime = (input.toUtc().millisecondsSinceEpoch/1000).toInt().toString();
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

  @override
  Widget build(BuildContext context) {
    // if statement (if participant, return this... if admin, return with admin privileges)
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: screenHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TopBar(backflag: true),
                        Stack(
                          children: [
                            Column(children: [
                              SizedBox(height: screenHeight * 0.05),
                              CustomPaint(
                                  size: Size(screenWidth, screenHeight * 0.75),
                                  painter: CurvedTop(
                                      color1: Theme.of(context)
                                          .colorScheme
                                          .secondaryVariant,
                                      color2:
                                      Theme.of(context).colorScheme.primary,
                                      reverse: true)),
                            ]),
                          ],
                        )
                      ],
                    )))));
  }
}