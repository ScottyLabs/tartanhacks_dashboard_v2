import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barras/barras.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:thdapp/models/json-classes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'checkin-item-create.dart';



class QRPage extends StatefulWidget{
  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage>{

  List history;
  List scanConfig = ["", "", false, false];
  List checkinItems;
  String id;
  bool admin = false;
  String token;
  SharedPreferences prefs;
  TextEditingController checkinIdController = TextEditingController();

  void delHistory(hItem){
    setState(() {
      history.remove(hItem);
    });
  }

  void setConfig(value, index){
    setState(() {
      scanConfig[index] = value;
    });
  }

  Future getID() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("id");
      admin = prefs.getBool("is_admin");
      token = prefs.getString("token");
    });
  }

  Future<List> getCheckinItems() async{
    var response = await http.post(
        Uri.encodeFull("https://thd-api.herokuapp.com/checkin/get"),
        headers:{"token": token}
    );
    List data = json.decode(response.body);
    if(response.statusCode == 200){

      List res = data.map((element) =>
          CheckinItem.fromJson(element))
          .where((element) => element.self_checkin_enabled == false).toList();
      if(res.length > 0) {
        setState(() {
          List itemIDs = res.map((element) => element.id).toList();
          if (!itemIDs.contains(scanConfig[0])) {
            scanConfig[0] = res[0].id;
          }
        });
      }
      return res;
    }
    return null;
  }

  Future errorDialog(title, text, context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )
          ),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  Future checkinUser(user, item, context) async{
    var response = await http.post(
      Uri.encodeFull("https://thd-api.herokuapp.com/checkin/user"),
      headers:{"token": token},
      body:{
        "user_id": user,
        "checkin_item_id": item,
      }
    );
    print(response.body);
    if(response.statusCode != 200) {
      Map data = json.decode(response.body);
      errorDialog("Check-in Failed", data['message'], context);
    }else{
      errorDialog("Success!", "You were successfully checked in", context);
    }
  }

  Future scan(BuildContext context) async {
    final data = await Barras.scan(context);
    String scanRes = data;
    if(scanConfig[2] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            HistoryPage(id: scanRes, token: token,
                delHistory: delHistory, editing: true)),
      );
    }else if(!admin || scanConfig[3]){
      checkinUser(id, scanRes, context);
    }else{
      checkinUser(scanRes, scanConfig[0], context);
    }
  }

  Future setup() async{
    await getID();
    List l = await getCheckinItems();
    setState(() {
      checkinItems = l;
    });
  }

  @override
  void dispose() {
    checkinIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setup();
    super.initState();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                'Your QR Code',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 37, 130, 242),
            ),
            preferredSize: Size.fromHeight(60)),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: (id != null) ? QrImage(
                      data: "$id",
                      version: QrVersions.auto,
                      size: 250.0,
                      foregroundColor: Colors.black,
                    )
                    : Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Loading...",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    )
                  ),
                  const SizedBox(height: 20),
                  ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[
                        RaisedButton(
                          onPressed: () {
                            scan(context);
                          },
                          padding: const EdgeInsets.only(top:10, bottom:10,
                              left:30, right:30),
                          color: Color.fromARGB(255, 37, 130, 242),
                          child: Text('To Scanner',
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 30)),
                        ),
                        if(admin)
                        OutlineButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  ConfigPage(scanConfig: scanConfig,
                                      setConfig: setConfig, token: token,
                                      getCheckinItems: getCheckinItems,
                                      checkinItems: checkinItems)
                              ),
                            );
                          },
                          padding: const EdgeInsets.only(top:10, bottom:10,
                              left:30, right:30),
                          child: Icon(
                              Icons.settings_outlined,
                              size:30,
                              color: Color.fromARGB(255, 37, 130, 242)),
                        )
                      ]
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom:8, left:25, right:25),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Expanded(
                            child:TextField(
                                autofocus: false,
                                controller: checkinIdController,
                                decoration: InputDecoration(
                                    labelText: "Check in with event ID",
                                    border: OutlineInputBorder()
                                )
                            ),
                          ),
                          const SizedBox(width:10),
                          Container(
                            width: 60,
                            child: RaisedButton(
                              onPressed: () {
                                checkinUser(id, checkinIdController.text, context);
                              },
                              padding: const EdgeInsets.only(top:10, bottom:10),
                              color: Color.fromARGB(255, 37, 130, 242),
                              child: Icon(
                                  Icons.keyboard_return,
                                  size: 25,
                                  color: Colors.white),
                            ),
                          )
                        ]
                    )
                  ),
                  const SizedBox(height:10),
                  if(admin)
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            NewCIIPage()),
                      );
                    },
                    padding: const EdgeInsets.only(top:10, bottom:10,
                        left:30, right:30),
                    color: Color.fromARGB(255, 37, 130, 242),
                    child: Text('Create Checkin Items',
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 30)),
                  ),
                  const SizedBox(height: 8),
                  if(admin)
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ViewCIIPage()),
                      );
                    },
                    padding: const EdgeInsets.only(top:10, bottom:10,
                        left:30, right:30),
                    color: Color.fromARGB(255, 37, 130, 242),
                    child: Text('Edit Checkin Items',
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 30)),
                  )
                ]
            )
        )
    );
  }
}


class InfoTile extends StatelessWidget{
  final CheckinItem info;
  final bool editing;
  final Function delHistory;

  InfoTile({this.info, this.editing, this.delHistory});

  @override
  Widget build(BuildContext context){
    return Card(
        margin: const EdgeInsets.all(12),
        child: InkWell(
          onTap: () async {
            return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                      '${info.name}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          info.has_checked_in ?
                            'Checked in ${DateFormat.jm().add_yMd().format(
                                new DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(info.check_in_timestamp)*1000,
                                    ).toLocal()
                            )}.'
                            : 'Not checked in.',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                            )
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '${info.desc}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            )
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                    children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(editing)
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    delHistory(info);
                                  }
                              )
                            else
                              info.has_checked_in ?
                                  Icon(Icons.check_box)
                                : Icon(Icons.check_box_outline_blank)
                          ],
                        ),
                      const SizedBox(width: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${info.name}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            const SizedBox(height: 8),
                            Text(
                              info.has_checked_in ?
                                'Checked in ${DateFormat.jm().add_yMd().format(
                                    new DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(info.check_in_timestamp)*1000,
                                    ).toLocal()
                                )}.'
                                : "Not checked in.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                )
                            ),
                          ]
                      )
                    ]
                )
            )
        )
    );
  }
}

class HistoryPage extends StatefulWidget{
  final String id;
  final String token;
  final Function delHistory;
  final bool editing;

  HistoryPage({this.id, this.token, this.delHistory, this.editing});

  _HistoryPageState createState() => _HistoryPageState();

}

class _HistoryPageState extends State<HistoryPage>{

  String name;
  List history;
  bool loaded = false;

  Future getHistory() async{
    var queryParams = {
      "user_id": widget.id,
    };
    var response = await http.get(
        Uri.https("thd-api.herokuapp.com", "/checkin/history",
            queryParams),
        headers:{"token": widget.token}
    );

    Map data = json.decode(response.body);
    List raw = data["checkin_history"];
    raw = raw.map((element) =>
        CheckinItem.fromJson(Map<String, dynamic>.from(element))).toList();
    if(this.mounted){
      setState(() {
        name = data["user"]["name"];
        history = raw.reversed.toList();
        loaded = true;
      });
    }
  }

  @override
  void initState() {
    if(history != null){
      history = null;
    }
    if(name != null){
      name = null;
    }
    getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                "$name's History",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 37, 130, 242),
            ),
            preferredSize: Size.fromHeight(60)),
        body: Column(
            children: <Widget>[
              (history != null && history.length > 0) ?
                  Expanded(
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (BuildContext context, int index){
                        return InfoTile(info: history[index],
                          editing: widget.editing,
                          delHistory: widget.delHistory,);
                      },
                    ),
                  )
              : SizedBox(
                height: 100,
                child: Align(
                    alignment: Alignment.center,
                    child:
                    (loaded) ?
                    Text(
                        "No checkin items found.",
                        style: TextStyle(
                          fontSize: 30,
                        )
                    )
                    : Text(
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

class ConfigPage extends StatefulWidget{
  final List scanConfig;
  final Function setConfig;
  final String token;
  final List checkinItems;
  final Function getCheckinItems;

  ConfigPage({this.scanConfig, this.setConfig, this.token,
      this.checkinItems, this.getCheckinItems});

  _ConfigPageState createState() => _ConfigPageState();
}


class _ConfigPageState extends State<ConfigPage> {

  //final commentControl = TextEditingController();
  List scanConfig;
  List checkinItems;

  void setConfig(value, index){
    widget.setConfig(value, index);
    setState(() {
      scanConfig[index] = value;
    });
  }

  Future setup() async{
    List l = await widget.getCheckinItems();
    setState(() {
      checkinItems = l;
      scanConfig = widget.scanConfig;
    });
  }

  @override
  void dispose() {
    //commentControl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //commentControl.text = !widget.scanConfig[2] ? widget.scanConfig[1] : "";
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(checkinItems);
    return Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                'Scan Config',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 37, 130, 242),
            ),
            preferredSize: Size.fromHeight(60)),
        body:Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  (checkinItems == null) ?
                    [SizedBox(
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
                    )]
                  :[Row(
                        children: [
                          Container(
                            child: Text("Check In Item",
                                style: Theme.of(context).textTheme.subtitle1),
                            width: 150,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: DropdownButton<String>(
                                isExpanded: true,
                                value: scanConfig[0],
                                items: checkinItems
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                      value: value.id,
                                      child: Text(value.name)
                                  );
                                }).toList(),
                                disabledHint: Text("N/A"),
                                underline: Container(
                                    height: 0
                                ),
                                onChanged: (!scanConfig[2] && !scanConfig[3]) ?
                                    (String newValue) {
                                  setConfig(newValue, 0);
                                } : null
                            )
                          )
                        ]
                    ),
                    const SizedBox(height:20),
                    /*
                    TextField(
                      autofocus: false,
                      enabled: !widget.scanConfig[2],
                      controller: commentControl,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: !widget.scanConfig[2] ? "Additional comment"
                            : "No comments in viewing mode"
                      ),
                      onChanged: (String value) {
                        setConfig(value, 3);
                      },
                    ),
                    const SizedBox(height:20),
                    */
                    CheckboxListTile(
                      title: Text("View History"),
                      value: widget.scanConfig[2],
                      onChanged: (bool newValue) {
                        /*
                        if(newValue){
                          commentControl.clear();
                        }else{
                          commentControl.text = widget.scanConfig[1];
                        }
                         */
                        setConfig(newValue, 2);
                      }
                    ),
                    const SizedBox(height:15),
                    CheckboxListTile(
                        title: Text("Self-checkin"),
                        value: scanConfig[3],
                        onChanged: (bool newValue) {
                          /*
                          if(newValue){
                            commentControl.clear();
                          }else{
                            commentControl.text = widget.scanConfig[1];
                          }
                           */
                          setConfig(newValue, 3);
                        }
                    ),
                    const SizedBox(height:20),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.only(top:10, bottom:10,
                          left:60, right:60),
                      color: Color.fromARGB(255, 37, 130, 242),
                      child: Text('Confirm',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 30)),
                    )
                  ]
              )
            )
        )
    );
  }
}

