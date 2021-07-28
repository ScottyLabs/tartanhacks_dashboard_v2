import 'package:flutter/material.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/models/project.dart';
import 'package:thdapp/models/prize.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PrizePage extends StatefulWidget{

  @override
  _PrizeState createState() => _PrizeState();
}

class _PrizeState extends State<PrizePage>{

  List<Prize> prizes;
  String teamID;
  String token;
  Project project;
  SharedPreferences prefs;

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

  void _confirmDialog(String response, String title, Function execute) {
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
                "Cancel",
                style: new TextStyle(color: Colors.white),
              ),
              color: Colors.grey[500],
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Confirm",
                style: new TextStyle(color: Colors.white),
              ),
              color: Color.fromARGB(255, 37, 130, 242),
              onPressed: () {
                Navigator.of(context).pop();
                execute();
                getData();
              },
            ),
          ],
        );
      },
    );
  }

  Future getData() async{
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    teamID = prefs.getString("team_id");
    List<Prize> pzs = await getAllPrizes();
    Project proj = await getProject(teamID, token, _showDialog);
    setState(() {
      prizes = pzs;
      project = proj;
    });
    print(token);
    print(teamID);
  }

  @override
  void initState(){
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                'Enter Project For Prizes',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 37, 130, 242),
            ),
            preferredSize: Size.fromHeight(60)),
        body:Column(
            children: <Widget>[
              (prizes != null) ?
              Expanded(
                child: ListView.builder(
                  itemCount: prizes.length,
                  itemBuilder: (BuildContext context, int index){
                    return InfoTile(prizes[index], project, token, _showDialog, _confirmDialog);
                  },
                ),
              )
              : SizedBox(
              height: 100,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                      "Loading...",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      )
                  )
                )
              )
            ]
        )
    );
  }
}


class InfoTile extends StatelessWidget{
  final Prize prize;
  final Project project;
  final String token;
  final Function showDialog;
  final Function confirmDialog;

  InfoTile(this.prize, this.project, this.token, this.showDialog, this.confirmDialog);

  void enter(){
    enterProject(project.id, prize.id, token, showDialog);
  }

  @override
  Widget build(BuildContext context){
    return Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      prize.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  const SizedBox(height: 8),
                  Text(
                      prize.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      )
                  ),
                  const SizedBox(height: 8),
                  !(project.prizes.contains(prize.name)) ?
                  RaisedButton(
                    color: Color.fromARGB(255, 37, 130, 242),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      confirmDialog("Submit project for ${prize.name}?", "Submission Confirmation", enter);
                    },
                  )
                  : RaisedButton(
                    child: Text(
                      'Already Submitted',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: null,
                  )
                ]
            )
        )
    );
  }
}

