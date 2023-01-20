import 'package:flutter/material.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/background_shapes/CurvedTop.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/components/topbar/TopBar.dart';
import 'team_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/team.dart';
import 'view_team.dart';

class ViewInvites extends StatefulWidget {
  @override
  _ViewInvitesState createState() => _ViewInvitesState();
}

class _ViewInvitesState extends State<ViewInvites> {

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
    return team.admins.map((e) => e.id).toList().contains(id);
  }

  void getData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    memberID = prefs.getString('id');
    isAdmin = prefs.getBool('admin');
    team = await getUserTeam(token);
    if (team == null){ 
        requestsList = await getUserMail(token);
        numRequests = requestsList.length;
        _buildInvitesList();
    } else {
        requestsList = await getTeamMail(token);
        numRequests = requestsList.length;
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
  requestWidgetList = [];
  for(int i = 0; i < requestsList.length; i++){
    requestWidgetList.add(_buildRequests(i));
  }
}

void _remRequest(String requestID) {
    for (var r in requestsList) {
      if (r['_id'] == requestID) {
        requestsList.remove(r);
        numRequests -= 1;
        return;
      }
    }
}

Widget _buildInviteHeader() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("INVITES", style: Theme.of(context).textTheme.headline1)
        ]
    );
  }

 Widget _requestResponses(String requestType, String requestID){
     if ((team == null && requestType == "INVITE") ||
     (team != null && requestType == "JOIN")) {
         return Row (
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
                const SizedBox(width: 20),
                 SolidButton(
                          text: "Accept",
                          onPressed: () async {
                            await acceptRequest(token, requestID);
                            _remRequest(requestID);
                            _buildInvitesList();
                            setState(() {

                            });
                            if (requestType == 'INVITE') {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => ViewTeam()));
                            }
                          }
                ),
                const SizedBox(width: 20),
                SolidButton(
                    text: "Decline",
                    onPressed: () async {
                        await declineRequest(token, requestID);
                        _remRequest(requestID);
                        _buildInvitesList();
                        setState(() {

                        });
                    }
                )
             ]
         );
    } else {
         return Row (
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                 SolidButton(
                          text: "Cancel",
                          onPressed: () async {
                            await cancelRequest(token, requestID);
                            _remRequest(requestID);
                            _buildInvitesList();
                            setState(() {

                            });
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
    Row btnRow = _requestResponses(requestType, requestID);
    return Card(
        margin: const EdgeInsets.all(12),
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(requestType, style: Theme.of(context).textTheme.headline3),
              const SizedBox(height: 10),
              Text(inviteInfo, style: Theme.of(context).textTheme.bodyText2),
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
    return DefaultPage(
      backflag: true,
      reverse: true,
      child:
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: GradBox(
                  width: screenWidth*0.9,
                  height: screenHeight*0.75,
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: _buildInviteHeader()
                        ),
                        if (prefs == null)
                          const Center(child: CircularProgressIndicator())
                        else if (requestsList.isEmpty)
                          Text("No invites.", style: Theme.of(context).textTheme.bodyText2,)
                        else
                        Expanded(
                          child: ListView.builder(
                            itemCount: numRequests,
                            itemBuilder: (BuildContext context, int index){
                              return _buildRequests(index);
                            },
                          ),
                        )
                      ]
                  )
              )
          )
    );
  }
}

