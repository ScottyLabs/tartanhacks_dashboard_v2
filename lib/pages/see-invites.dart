import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import '../api.dart';
import 'team-api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '/models/team.dart';
import '/models/member.dart';
import 'dart:convert';
import 'teams_list.dart';
import 'dart:async';

class viewInvites extends StatefulWidget {
  @override
  _viewInvitesState createState() => _viewInvitesState();
}

class _viewInvitesState extends State<viewInvites> {

  bool isAdmin = false;
  bool isMember = false;
  String teamID = "";
  Team team;
  String token;
  String memberID;
  int numRequests;
  List<Widget> requestsWidgetList = <Widget>[];
  List<dynamic> requestsList;
  List<Widget> requestWidgetList = <Widget>[];
  SharedPreferences prefs;
  bool checkAdmin(String id){
    return team.admin.id == id;
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    memberID = prefs.getString('id');
    isAdmin = prefs.getBool('admin');
    team = await getUserTeam(token);
    if (team == null){ 
        requestsList = await getUserMail(token);
        print("test test test");
        numRequests = requestsList.length;
        print("num requests are");
        print(numRequests);
        _buildInvitesList();
    } else {
        print("tried heree");
        requestsList = await getTeamMail(token);
        numRequests = requestsList.length;
        print("num requests are");
        print(numRequests);
        _buildInvitesList();
    }
    
    setState(() {
    });
  }

  @override
  initState() {
    super.initState();
    getData();
  }


void _buildInvitesList(){
    for(int i = 0; i < numRequests; i++){
      requestWidgetList.add(_buildRequests(i));
    }
  }

Widget _buildInviteHeader() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("INVITES", style: Theme.of(context).textTheme.headline2)
        ]
    );
  }

 Widget _requestRespones(String requestType, String requestID, String inviteInfo){
     String textContent;
     if (team == null){
         textContent = inviteInfo;
     } else {
         textContent = inviteInfo;
     }
     print("worked here");
     if ((team == null && requestType == "INVITE") || 
     (team != null && requestType == "JOIN")) {
         return Row (
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
                 Text(textContent),
                 SolidButton(
                          text: "Accept",
                          onPressed: () async {
                            await acceptRequest(token, requestID);
                            _buildInvitesList();
                          }
                ),
                SolidButton(
                    text: "Decline",
                    onPressed: () async {
                        await declineRequest(token, requestID);
                        _buildInvitesList();
                    }
                )
             ]
         );
    } else {
         return Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text(textContent),
                 SolidButton(
                          text: "Cancel",
                          onPressed: () async {
                            await cancelRequest(token, requestID);
                            _buildInvitesList();
                          }
                    )
            ]
        );
     }
 }
  Widget _buildRequests(int index){
    String requestType = requestsList[index]['type'];
    String inviteInfo;
    if (team != null){
        inviteInfo = requestsList[index]['user']['email'];
    } else {
        inviteInfo = requestsList[index]['team']['name'];
    }
    String requestID = requestsList[index]['_id'];
    Row btnRow = _requestRespones(requestType, requestID, inviteInfo);
    print('building request');
    return Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(requestType, style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 8),
              btnRow
            ],
          )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    if(prefs == null){
      return LoadingScreen();
    } else {
    return Scaffold(
        body:  Container(
            child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
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
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                              child: _buildInviteHeader()
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: numRequests,
                                              itemBuilder: (BuildContext context, int index){
                                                print("testing item builder");
                                                return requestWidgetList[index];
                                              },
                                            ),
                                          )
                                        ]
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
}

