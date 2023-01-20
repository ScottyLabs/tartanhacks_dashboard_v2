import 'package:flutter/material.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
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
  int _startTime = 0;
  int _endTime = 0;
  DateTime pickedDate = DateTime.now();
  TimeOfDay pickedTime = TimeOfDay.now();
  
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  var dropdownValue = 'IN_PERSON';

  final List<String> _dropdownItems = ['IN_PERSON', "ZOOM", "DISCORD", "HOPIN", "OTHER"];

  TimeOfDay selectedStartTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 00, minute: 00);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    nameController.dispose();
    descController.dispose();
    locationController.dispose();
    linkController.dispose();
    dateController.dispose();
    timeController.dispose();
    durationController.dispose();
    super.dispose();
  }

  void saveData() async {
    bool result = await addEvent(_eventName, _eventDesc, _startTime, _endTime, _location, 0, 0, _platform, _eventUrl);
    if (result == true) {
      _showDialog('Your event was successfully saved!', 'Success', result);
    }else{
      _showDialog('There was an error. Please try again.', 'Error.', result);
    }
  }

  void updateDate(){
    DateTime combined = DateTime(pickedDate.year, pickedDate.month,
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
    if (picked != null && picked != pickedDate) {
      setState(() {
        pickedDate = picked;
        dateController.text = DateFormat.yMMMd().format(pickedDate);
        updateDate();
      });
    }
  }

  Future pickTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: pickedTime,
    );
    if (picked != null && picked != pickedTime) {
      setState(() {
        pickedTime = picked;
        timeController.text = pickedTime.format(context);
        updateDate();
      });
    }
  }

  void _showDialog(String response, String title, bool result) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(response),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 255, 75, 43),
              ),
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
      decoration: const InputDecoration(labelText: "Event Name"),
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
      decoration: const InputDecoration(labelText: "Event Description"),
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

  Widget _buildLocation() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Location"),
      style: Theme.of(context).textTheme.bodyText2,
      controller: locationController,
      validator: (String value) {
        if (value.isEmpty && _platform == "IN_PERSON") {
          return "Location is required";
        }
        return null;
      },
      onChanged: (String value) {
        _location = value;
      },
    );
  }

  Widget _buildEventURL() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Event Link"),
      style: Theme.of(context).textTheme.bodyText2,
      keyboardType: TextInputType.url,
      controller: linkController,
      validator: (String value) {
        if (value.isEmpty && _platform != "IN_PERSON") {
          return "URL is required";
        }
        return null;
      },
      onChanged: (String value) {
        _eventUrl = value;
      },
    );
  }

  Widget _buildDate() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Date"),
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
      decoration: const InputDecoration(labelText: "Time"),
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
      decoration: const InputDecoration(labelText: "Duration (min)"),
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
        padding: const EdgeInsets.only(left: 5, right: 5),
        height: width*0.06,
        width: width * 0.4,
        child: DropdownButton<String>(
          isExpanded: true,
          iconEnabledColor: Theme.of(context).colorScheme.primary,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 25,
          onChanged: (String val) {
            setState(() {
              _platform = val;
              dropdownValue = val;
            });
          },
          underline: const SizedBox(),
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

    return DefaultPage(
      backflag: true,
      reverse: true,
      child:
          Container(
            //color: Colors.black,
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: GradBox(
                  width: screenWidth*0.9,
                  height: screenHeight*0.75,
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("CREATE NEW EVENT", style: Theme.of(context).textTheme.headline2),
                              const SizedBox(height:45),
                              _buildName(),
                              const SizedBox(height:16),
                              _buildDesc(),
                              const SizedBox(height:16),
                              Center(child: Text("Meeting Platform", style: Theme.of(context).textTheme.headline4)),
                              const SizedBox(height:5),
                              _meetingPlatformDropdown(screenWidth),
                              const SizedBox(height:16),
                              _buildLocation(),
                              const SizedBox(height:16),
                              _buildEventURL(),
                              const SizedBox(height:16),
                              _buildDate(),
                              const SizedBox(height:16),
                              _buildTime(),
                              const SizedBox(height:16),
                              _buildDuration(),
                              const SizedBox(height:16),
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
    );
  }
}