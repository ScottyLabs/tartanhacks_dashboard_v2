import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../custom_widgets.dart';
import 'package:thdapp/api.dart';
import 'index.dart';
import 'package:intl/intl.dart';

class NewEventScreen extends StatefulWidget {
  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {

  String _eventName = "";
  String _eventDesc = "";
  String _eventUrl = "";
  int _duration = 0;
  String _location = "";
  String _platform = "IN_PERSON";
  double _lat = 0;
  double _lng = 0;
  int _startTime = 0;
  int _endTime = 0;
  DateTime pickedDate = DateTime.now();
  TimeOfDay pickedTime = TimeOfDay.now();
  
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  var dropdownValue = 'IN_PERSON';

  List<String> _dropdownItems = ['IN_PERSON', "ZOOM", "DISCORD", "HOPIN", "OTHER"];

  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    nameController.dispose();
    descController.dispose();
    linkController.dispose();
    dateController.dispose();
    timeController.dispose();
    durationController.dispose();
    super.dispose();
  }

  void saveData() async {
    bool result;
    if (_platform == "IN_PERSON") {
      result = await addEvent(_eventName, _eventDesc, _startTime, _endTime, _location, 0, 0, _platform, "N/A");
    } else {
      result = await addEvent(_eventName, _eventDesc, _startTime, _endTime, "N/A", 0, 0, _platform, _eventUrl);
    }
    if (result == true) {
      _showDialog('Your event was successfully saved!', 'Success', result);
    }else{
      _showDialog('There was an error. Please try again.', 'Error.', result);
    }
  }

  void updateDate(){
    DateTime combined = new DateTime(pickedDate.year, pickedDate.month,
        pickedDate.day, pickedTime.hour, pickedTime.minute);
    setState(() {
      _startTime = (combined.millisecondsSinceEpoch/1000).round();
      _endTime = (combined.add(Duration(minutes: _duration)).millisecondsSinceEpoch/1000).round();
    });
  }

  bool dateInRange(DateTime d, DateTime start, DateTime end){
    return start.isBefore(d) && end.isAfter(d);
  }

  Future pickDate(BuildContext context) async {
    DateTime sDate = DateTime(DateTime.now().year-5);
    DateTime eDate = DateTime(DateTime.now().year+5);
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateInRange(pickedDate, sDate, eDate) ? pickedDate
          : DateTime.now(),
      firstDate: sDate,
      lastDate: eDate,
    );
    if (picked != null && picked != pickedDate)
      setState(() {
        pickedDate = picked;
        dateController.text = DateFormat.yMMMd().format(pickedDate);
        updateDate();
      });
  }

  Future pickTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: pickedTime,
    );
    if (picked != null && picked != pickedTime)
      setState(() {
        pickedTime = picked;
        timeController.text = pickedTime.format(context);
        updateDate();
      });
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventsHomeScreen()),
                  );
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
      decoration: FormFieldStyle(context, "Event Name"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: nameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Project name is required';
        }
        return null;
      },
      onChanged: (String value) {
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
      onChanged: (String value) {
        _eventDesc = value;
      },
    );
  }

  Widget _buildEventURL() {
    return TextFormField(
      decoration: FormFieldStyle(context, (_platform == "IN_PERSON") ? "Location" : "Event Link"),
      style: Theme.of(context).textTheme.bodyText2,
      keyboardType: TextInputType.url,
      controller: linkController,
      validator: (String value) {
        if (value.isEmpty) {
          return (_platform == "IN_PERSON") ? "Location is required" : "URL is required";
        }
        return null;
      },
      onChanged: (String value) {
        if (_platform == "IN_PERSON") {
          _location = value;
        } else {
          _eventUrl = value;
        }
      },
    );
  }

  Widget _buildDate() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Date"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: dateController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Date is Required';
        }
        return null;
      },
      onTap: () {
        pickDate(context);
      }
    );
  }

  Widget _buildTime() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Time"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: timeController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Time is Required';
        }
        return null;
      },
      onTap: () {
        pickTime(context);
      }
    );
  }

  Widget _buildDuration() {
    return TextFormField(
      decoration: FormFieldStyle(context, "Duration (min)"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: durationController,
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Duration is Required';
        }
        return null;
      },
      onChanged: (String value) {
        _duration = int.parse(value);
        updateDate();
      },
    );
  }

  Widget _meetingPlatformDropdown(width){
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryVariant,
            borderRadius: BorderRadius.circular(5)
        ),
        padding: EdgeInsets.only(left: 5, right: 5),
        height: width*0.06,
        width: width * 0.4,
        child: DropdownButton<String>(
          isExpanded: true,
          iconEnabledColor: Theme.of(context).colorScheme.primary,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 25,
          onChanged: (String val) {
            setState(() {
              _platform = val;
              dropdownValue = val;
            });
          },
          underline: SizedBox(),
          value: dropdownValue,
          items: _dropdownItems.map<DropdownMenuItem<String>>((String val){return DropdownMenuItem<String>(value: val, child: Text(val, style: Theme.of(context).textTheme.bodyText2,));}).toList()
          ,
        ),
      ),
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
                              //color: Colors.black,
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("CREATE NEW EVENT", style: Theme.of(context).textTheme.headline2),
                                                SizedBox(height:45),
                                                _buildName(),
                                                SizedBox(height:16),
                                                _buildDesc(),
                                                SizedBox(height:16),
                                                Center(child: Text("Meeting Platform", style: Theme.of(context).textTheme.headline4)),
                                                SizedBox(height:5),
                                                _meetingPlatformDropdown(screenWidth),
                                                SizedBox(height:16),
                                                _buildEventURL(),
                                                SizedBox(height:16),
                                                _buildDate(),
                                                SizedBox(height:16),
                                                _buildTime(),
                                                SizedBox(height:16),
                                                _buildDuration(),
                                                SizedBox(height:16),
                                                Center(
                                                  child: SolidButton(
                                                    text: "Save information",
                                                    onPressed: saveData,
                                                  ),
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