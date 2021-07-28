import 'package:flutter/material.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/models/project.dart';
import 'package:thdapp/models/prize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'checkin_home.dart';
import 'home.dart';
import 'events_home.dart';
import 'enter_prizes.dart';


class FormScreen extends StatefulWidget{
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  String _projName = "";
  String _projDesc = "";
  String _githubUrl = "";
  String _presUrl = "";
  String _vidUrl = "";
  List<Prize> prizes = [];
  List<String> selectedNames = [];
  List<String> prizeNames = [];
  List<String> initialPrizes = [];
  String userID = "";
  String projectID = "";
  String teamID = "";
  String token = "";
  bool hasProject = false;
  bool isPresenting = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController githubController = TextEditingController();
  TextEditingController slidesController = TextEditingController();
  TextEditingController videoController = TextEditingController();

  SharedPreferences prefs;
  int selectedIndex = 2;

  void onNavigationItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      if (selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new HomeScreen()),
        );
      } else if (selectedIndex == 1) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new EventsHomeScreen()),
        );
      } else if (selectedIndex == 3) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new CheckinHomeScreen(userId: userID,)),
        );
      } else if (selectedIndex == 4) {}
    });
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

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    userID = prefs.getString("id");
    teamID = prefs.getString("team_id");

    prizes = await getAllPrizes();
    prizeNames = getPrizeNames(prizes);
    Project proj = await getProject(teamID, token, _showDialog);
    if (proj != null) {
      hasProject = true;
      _projName = proj.name;
      _projDesc = proj.desc;
      _presUrl = proj.slides;
      _vidUrl = proj.video;
      _githubUrl = proj.github;
      projectID = proj.id;
      isPresenting = proj.willPresent;
      nameController.text = _projName;
      descController.text = _projDesc;
      slidesController.text = _presUrl;
      videoController.text = _vidUrl;
      githubController.text = _githubUrl;
      selectedNames = proj.prizes;
    }
    setState(() {});
  }

  void _showDialog(String response, String title) {
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
              },
            ),
          ],
        );
      },
    );
  }

  submitProject(String name, String desc, String teamID, String token, String github, String slides, String video, bool presenting, String id, List<String> prizeIds, Function _showDialog) async {
    print("has project is");
    print(hasProject);
    print("printing project id");
    print(id);
    bool res = false;
    if (hasProject) {
      res = await editProject(name, desc, teamID, token, github, slides, video, presenting, id, _showDialog);
    }
    else {
      res = await newProject(name, desc, teamID, token, github, slides, video, presenting, id, _showDialog);
    }
    if (res) {
      print("success!");
      return;
    }
    print("failure :(");
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Project Name'),
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
      decoration: InputDecoration(labelText: 'Project Description'),
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
      decoration: InputDecoration(labelText: 'GitHub Repository Url'),
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
      decoration: InputDecoration(labelText: 'Presentation Url'),
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
      decoration: InputDecoration(labelText: 'Video Url'),
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
        padding: new EdgeInsets.all(10.0),
        child: Column(
            children: <Widget>[
              SizedBox(width: 20,),
              Text('Presenting',textAlign: TextAlign.left, style: TextStyle(fontSize: 20.0), ),
              Text('Do you wish to present live at the expo? If not, you must submit a video.',textAlign: TextAlign.left, style: TextStyle(fontSize: 15.0), ),
              Switch(
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

  List<String> getPrizeNames(List<Prize> prizes) {
    List<String> prizeNames = [];

    for (var prize in prizes) {
      prizeNames.add(prize.name);
    }
    return prizeNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: new AppBar(
            title: new Text(
              'Project Submission Form',
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 20,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 37, 130, 242),
          ),
          preferredSize: Size.fromHeight(60)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildName(),
                  _buildDesc(),
                  _buildGitHubURL(),
                  _buildPresURL(),
                  _buildVidURL(),
                  _buildPresentingLive(),
                  RaisedButton(
                    color: Color.fromARGB(0xFF, 0x5D, 0x5F, 0x61),
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }

                      _formKey.currentState.save();


                      List<String> selectedIds = [];

                      for (var prizeItem in prizes) {
                        if (selectedNames.contains(prizeItem.name)) {
                          selectedIds.add(prizeItem.id);
                        }
                      }
                      print(selectedIds.toString());

                      //Send to API
                      submitProject(_projName, _projDesc, teamID, token, _githubUrl, _presUrl, _vidUrl, isPresenting, projectID, selectedIds, _showDialog);
                    },
                  ),
                  RaisedButton(
                    color: Color.fromARGB(0xFF, 0x5D, 0x5F, 0x61),
                    child: Text(
                      'Submit for Prizes',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      if(hasProject) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              PrizePage()
                          ),
                        );
                      }else{
                        _showDialog("Please create a project before submitting for prizes.",
                            "You don't have a project yet!");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), title: Text('HOME')),
          BottomNavigationBarItem(
              icon: Icon(Icons.event), title: Text('SCHEDULE')),
          BottomNavigationBarItem(
              icon: Icon(Icons.code), title: Text('PROJECT')),
          BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset), title: Text('POINTS')),
        ],
        currentIndex: selectedIndex,
        fixedColor: Color.fromARGB(255, 37, 130, 242),
        onTap: onNavigationItemTapped,
      ),
    );
  }
  
}
