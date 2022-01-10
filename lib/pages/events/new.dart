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
  String _platform = "IN_PERSON";
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
  TextEditingController durationController = TextEditingController();

  var dropdownValue = 'IN_PERSON';

  List<String> _dropdownItems = ['IN_PERSON', "ZOOM", "DISCORD", "HOPIN"];

  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    nameController.dispose();
    descController.dispose();
    linkController.dispose();
    dateController.dispose();
    durationController.dispose();
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
      decoration: FormFieldStyle(context, "Event Name"),
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
        _date = value;
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
                                                _buildEventURL(),
                                                SizedBox(height:16),
                                                Center(child: Text("Meeting Platform", style: Theme.of(context).textTheme.headline4)),
                                                SizedBox(height:5),
                                                _meetingPlatformDropdown(screenWidth),
                                                SizedBox(height:16),
                                                _buildDuration(),
                                                SizedBox(height:16),
                                                _buildDate(),
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