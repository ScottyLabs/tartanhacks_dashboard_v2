import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:thdapp/models/event_model.dart';
import 'package:thdapp/api.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:date_time_picker/date_time_picker.dart';

class EditEventsScreen extends StatefulWidget {

  final Event eventData;

  EditEventsScreen(
      {Key key, this.eventData})
      : super(key: key);
  @override
  _EditEventsScreenState createState() => new _EditEventsScreenState(eventData: eventData);
}

class _EditEventsScreenState extends State<EditEventsScreen> {

  SharedPreferences prefs;

  Event eventData;

  _EditEventsScreenState({Key key, this.eventData});

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
    getData();
  }

  void getData() async{
    prefs = await SharedPreferences.getInstance();

    isAdmin = prefs.getBool("is_admin");

    if(eventData != null){
      appBarTitle = 'Edit '+ eventData.name;
      eventNameController.text = eventData.name;
      eventDescController.text = eventData.description;
      zoomLinkController.text = eventData.zoom_link;
      durationController.text = eventData.duration.toString();
      selectedDate =  new DateTime.fromMillisecondsSinceEpoch(int.parse(eventData.timestamp) * 1000);

      if(eventData.access_code == 1){
         dropdownValue = 'Zoom';

      }else if(eventData.access_code == 2){
        dropdownValue = 'Hopin';

      }else if(eventData.access_code == 3){
        dropdownValue = 'Discord';

      }else{
        dropdownValue = 'Other';

      }

      setState(() {

      });

    }
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

    return new Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Color.fromARGB(255, 37, 130, 242), //blue
      ),
      backgroundColor: Color.fromARGB(240, 255, 255, 255), //gray
      body: Padding(
          padding: EdgeInsets.all(25.0),
          child: SingleChildScrollView(
              child: Column(
                children: [

                  TextField(
                    controller: eventNameController,
                    decoration: InputDecoration(labelText: 'Event Name'),
                  ),
                  Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  TextField(
                    controller: eventDescController,
                    decoration: InputDecoration(labelText: 'Event Description'),
                  ),
                  Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  TextField(
                    controller: zoomLinkController,
                    decoration: InputDecoration(
                        labelText: 'Event Link (Zoom/Discord/Hopin etc)'),
                  ),
                  Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  Text('Meeting Platform',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Color.fromARGB(255, 37, 130, 242)),
                    underline: Container(
                      height: 2,
                      color: Color.fromARGB(255, 37, 130, 242),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        if (newValue == 'Zoom'){
                          accessCode = 1;
                        }
                        else if (newValue == 'Hopin'){
                          accessCode = 2;
                        }
                        else if (newValue == 'Discord'){
                          accessCode = 3;
                        }
                        else {
                          accessCode = 0;
                        }
                      });
                    },
                    items: <String>['Zoom', 'Discord', 'Hopin', 'Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  TextField(
                    controller: durationController,
                    decoration: InputDecoration(labelText: 'Duration'),
                    keyboardType: TextInputType.number,
                  ),
                  Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  DateTimePicker(
                    type: DateTimePickerType.dateTime,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    onChanged: (val) => getDate(DateTime.parse(val)),
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => getDate(DateTime.parse(val)),
                  ),
                  const SizedBox(height: 30),
                  RaisedButton(
                    onPressed: () {
                      saveData();// API Call stuff here
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('Save Information',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ))),
    );
  }
}